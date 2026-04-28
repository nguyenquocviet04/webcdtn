// src/controllers/budget.controller.js
import { query } from '../config/db.js';
import { success, error } from '../utils/response.js';
import { getCurrentMonthYear } from '../utils/dateHelper.js';

// ── GET /budgets ─────────────────────────────────────────────
export const getBudgets = async (req, res, next) => {
  try {
    const { month: qMonth, year: qYear } = req.query;
    const { month, year } = getCurrentMonthYear();

    const m = parseInt(qMonth) || month;
    const y = parseInt(qYear)  || year;

    const [rows] = await query(
      `SELECT b.*,
         c.name AS category_name, c.icon AS category_icon, c.color AS category_color,
         COALESCE((
           SELECT SUM(t.amount)
           FROM transactions t
           WHERE t.user_id = b.user_id
             AND t.category_id = b.category_id
             AND t.type = 'expense'
             AND MONTH(t.transaction_date) = b.month
             AND YEAR(t.transaction_date)  = b.year
         ), 0) AS amount_spent
       FROM budgets b
       LEFT JOIN categories c ON b.category_id = c.id
       WHERE b.user_id = ? AND b.month = ? AND b.year = ?
       ORDER BY c.name ASC`,
      [req.user.id, m, y],
    );

    const enriched = rows.map((b) => ({
      ...b,
      amount_spent:  parseFloat(b.amount_spent),
      percent_used:  b.amount_limit > 0
        ? Math.round((parseFloat(b.amount_spent) / parseFloat(b.amount_limit)) * 100)
        : 0,
    }));

    return success(res, enriched);
  } catch (err) { next(err); }
};

// ── POST /budgets ────────────────────────────────────────────
// UPSERT: nếu đã có ngân sách tháng đó thì cập nhật
export const createBudget = async (req, res, next) => {
  try {
    const { category_id, amount_limit, month: qMonth, year: qYear } = req.body;
    const { month, year } = getCurrentMonthYear();
    const m = parseInt(qMonth) || month;
    const y = parseInt(qYear)  || year;

    await query(
      `INSERT INTO budgets (user_id, category_id, amount_limit, month, year)
       VALUES (?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE amount_limit = VALUES(amount_limit)`,
      [req.user.id, category_id, parseFloat(amount_limit), m, y],
    );

    const [rows] = await query(
      `SELECT b.*, c.name AS category_name, c.icon AS category_icon, c.color AS category_color
       FROM budgets b
       LEFT JOIN categories c ON b.category_id = c.id
       WHERE b.user_id = ? AND b.category_id = ? AND b.month = ? AND b.year = ?`,
      [req.user.id, category_id, m, y],
    );

    return success(res, rows[0], 'Tạo/cập nhật ngân sách thành công!', 201);
  } catch (err) { next(err); }
};

// ── PUT /budgets/:id ─────────────────────────────────────────
export const updateBudget = async (req, res, next) => {
  try {
    const [existing] = await query(
      'SELECT id FROM budgets WHERE id = ? AND user_id = ?',
      [req.params.id, req.user.id],
    );
    if (!existing.length) return error(res, 'Không tìm thấy ngân sách.', 404);

    await query(
      'UPDATE budgets SET amount_limit = ? WHERE id = ?',
      [parseFloat(req.body.amount_limit), req.params.id],
    );

    const [rows] = await query('SELECT * FROM budgets WHERE id = ?', [req.params.id]);
    return success(res, rows[0], 'Cập nhật ngân sách thành công!');
  } catch (err) { next(err); }
};

// ── DELETE /budgets/:id ──────────────────────────────────────
export const deleteBudget = async (req, res, next) => {
  try {
    const [existing] = await query(
      'SELECT id FROM budgets WHERE id = ? AND user_id = ?',
      [req.params.id, req.user.id],
    );
    if (!existing.length) return error(res, 'Không tìm thấy ngân sách.', 404);

    await query('DELETE FROM budgets WHERE id = ?', [req.params.id]);
    return success(res, null, 'Xóa ngân sách thành công!');
  } catch (err) { next(err); }
};
