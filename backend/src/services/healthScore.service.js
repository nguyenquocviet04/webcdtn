// src/services/healthScore.service.js
// Tính điểm sức khoẻ tài chính 0-100

import { query } from '../config/db.js';

export async function calculateHealthScore(userId, month, year) {

  // Lấy tổng thu tháng này
  const [[incRow]] = await query(
    `SELECT COALESCE(SUM(amount), 0) as income FROM transactions
     WHERE user_id=? AND type='income'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?`,
    [userId, month, year],
  );

  // Lấy tổng chi tháng này
  const [[expRow]] = await query(
    `SELECT COALESCE(SUM(amount), 0) as expense FROM transactions
     WHERE user_id=? AND type='expense'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?`,
    [userId, month, year],
  );

  // Lấy ngân sách và chi thực tế theo category
  const [budgets] = await query(
    `SELECT b.category_id, b.amount_limit,
            COALESCE(SUM(t.amount), 0) as spent
     FROM budgets b
     LEFT JOIN transactions t ON t.category_id=b.category_id
       AND t.user_id=b.user_id
       AND MONTH(t.transaction_date)=? AND YEAR(t.transaction_date)=?
     WHERE b.user_id=? AND b.month=? AND b.year=?
     GROUP BY b.category_id, b.amount_limit`,
    [month, year, userId, month, year],
  );

  // Lấy chi tiêu theo ngày trong tháng (để tính CV)
  const [dailyRows] = await query(
    `SELECT DATE(transaction_date) as day, SUM(amount) as total
     FROM transactions
     WHERE user_id=? AND type='expense'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?
     GROUP BY DATE(transaction_date)`,
    [userId, month, year],
  );

  // Lấy số nguồn thu (số category income có giao dịch)
  const [[srcRow]] = await query(
    `SELECT COUNT(DISTINCT category_id) as sources FROM transactions
     WHERE user_id=? AND type='income'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?`,
    [userId, month, year],
  );

  const income      = Number(incRow.income);
  const expense     = Number(expRow.expense);
  const savings_rate = income > 0 ? (income - expense) / income : 0;

  // TIÊU CHÍ 1: Tỷ lệ tiết kiệm (tối đa 30 điểm)
  const s1 = savings_rate >= 0.3 ? 30
           : savings_rate >= 0.2 ? 24
           : savings_rate >= 0.1 ? 16
           : savings_rate > 0    ? 8 : 0;

  // TIÊU CHÍ 2: Tuân thủ ngân sách (tối đa 25 điểm)
  const compliant = budgets.filter((b) => Number(b.spent) <= Number(b.amount_limit)).length;
  const s2 = budgets.length > 0 ? Math.round((compliant / budgets.length) * 25) : 12;

  // TIÊU CHÍ 3: Ổn định chi tiêu — Coefficient of Variation (tối đa 20 điểm)
  const amounts = dailyRows.map((r) => Number(r.total));
  let s3 = 10;
  let cv_value = 0;
  if (amounts.length > 2) {
    const mean     = amounts.reduce((a, b) => a + b, 0) / amounts.length;
    const variance = amounts.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / amounts.length;
    const std      = Math.sqrt(variance);
    cv_value = mean > 0 ? std / mean : 1;
    s3 = cv_value < 0.3 ? 20
       : cv_value < 0.5 ? 15
       : cv_value < 0.8 ? 10 : 5;
  }

  // TIÊU CHÍ 4: Đa dạng nguồn thu (tối đa 15 điểm)
  const sources = Number(srcRow.sources);
  const s4 = sources >= 3 ? 15 : sources === 2 ? 10 : sources === 1 ? 5 : 0;

  // TIÊU CHÍ 5: Xu hướng so với tháng trước (tối đa 10 điểm)
  const prevMonth = month === 1 ? 12 : month - 1;
  const prevYear  = month === 1 ? year - 1 : year;
  const [[prevInc]] = await query(
    `SELECT COALESCE(SUM(amount), 0) as i FROM transactions
     WHERE user_id=? AND type='income'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?`,
    [userId, prevMonth, prevYear],
  );
  const [[prevExp]] = await query(
    `SELECT COALESCE(SUM(amount), 0) as e FROM transactions
     WHERE user_id=? AND type='expense'
     AND MONTH(transaction_date)=? AND YEAR(transaction_date)=?`,
    [userId, prevMonth, prevYear],
  );
  const prevRate = Number(prevInc.i) > 0
    ? (Number(prevInc.i) - Number(prevExp.e)) / Number(prevInc.i) : 0;
  const s5 = savings_rate > prevRate + 0.02 ? 10
           : savings_rate >= prevRate - 0.02 ? 5 : 0;

  const total = s1 + s2 + s3 + s4 + s5;
  const grade = total >= 80 ? 'Xuất sắc'
              : total >= 65 ? 'Tốt'
              : total >= 50 ? 'Trung bình'
              : total >= 35 ? 'Cần cố gắng' : 'Báo động';

  // Upsert vào DB
  await query(
    `INSERT INTO financial_health_scores
      (user_id, month, year, total_score, grade, score_savings, score_budget,
       score_stability, score_diversity, score_trend, savings_rate, cv_value, income_sources)
     VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
     ON DUPLICATE KEY UPDATE
      total_score=VALUES(total_score), grade=VALUES(grade),
      score_savings=VALUES(score_savings), score_budget=VALUES(score_budget),
      score_stability=VALUES(score_stability), score_diversity=VALUES(score_diversity),
      score_trend=VALUES(score_trend), savings_rate=VALUES(savings_rate),
      cv_value=VALUES(cv_value), income_sources=VALUES(income_sources),
      updated_at=NOW()`,
    [userId, month, year, total, grade, s1, s2, s3, s4, s5,
      Math.round(savings_rate * 100), Math.round(cv_value * 100), sources],
  );

  return {
    total_score: total,
    grade,
    month,
    year,
    breakdown: {
      savings:   { score: s1, max: 30, label: 'Tỷ lệ tiết kiệm' },
      budget:    { score: s2, max: 25, label: 'Tuân thủ ngân sách' },
      stability: { score: s3, max: 20, label: 'Ổn định chi tiêu' },
      diversity: { score: s4, max: 15, label: 'Đa dạng nguồn thu' },
      trend:     { score: s5, max: 10, label: 'Xu hướng cải thiện' },
    },
    meta: {
      savings_rate_pct: Math.round(savings_rate * 100),
      income,
      expense,
      sources,
    },
  };
}
