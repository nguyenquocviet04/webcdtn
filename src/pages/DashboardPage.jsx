// pages/DashboardPage.jsx
// Trang tổng quan với StatCards, Charts và danh sách giao dịch gần nhất

import { useMemo, useState } from 'react';
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend,
} from 'recharts';
import {
  TrendingUp, TrendingDown, Wallet, Plus, ArrowRight,
} from 'lucide-react';
import { Link } from 'react-router-dom';
import useTransactionStore from '../store/transactionStore';
import useUIStore from '../store/uiStore';
import useAuthStore from '../store/authStore';
import { formatCurrency } from '../utils/formatCurrency';
import { formatDate } from '../utils/formatDate';
import { sumBy, groupBy } from '../utils/calcPercent';
import { getCategoryById } from '../constants/categories';
import { MOCK_DAILY_CHART } from '../constants/mockData';
import StatCard from '../components/ui/StatCard';
import BudgetProgressBar from '../components/ui/BudgetProgressBar';
import CategoryIcon from '../components/ui/CategoryIcon';
import Button from '../components/ui/Button';
import dayjs from 'dayjs';

// Màu biểu đồ
const CHART_COLORS = [
  '#2563eb','#f97316','#8b5cf6','#06b6d4','#ec4899',
  '#10b981','#f59e0b','#64748b','#ef4444','#3b82f6',
];

// Custom tooltip cho chart thu/chi
const CustomTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-white dark:bg-dark-800 rounded-xl shadow-card-lg border border-slate-100 dark:border-slate-700 p-3 text-sm">
      <p className="font-semibold text-slate-700 dark:text-slate-300 mb-2">{label}</p>
      {payload.map((p) => (
        <div key={p.name} className="flex items-center gap-2">
          <div className="w-2.5 h-2.5 rounded-full" style={{ background: p.color }} />
          <span className="text-slate-500">{p.name === 'thu' ? 'Thu nhập' : 'Chi tiêu'}:</span>
          <span className="font-semibold">{formatCurrency(p.value, true)}</span>
        </div>
      ))}
    </div>
  );
};

const DashboardPage = () => {
  const { transactions, budgets } = useTransactionStore();
  const { setQuickAddOpen }       = useUIStore();
  const { user }                  = useAuthStore();

  const thisMonth = dayjs().format('YYYY-MM');

  // Lọc giao dịch tháng này
  const monthTxs = useMemo(
    () => transactions.filter((t) => t.date?.startsWith(thisMonth)),
    [transactions, thisMonth],
  );

  const totalIncome  = useMemo(() => sumBy(monthTxs.filter((t) => t.type === 'income'),  'amount'), [monthTxs]);
  const totalExpense = useMemo(() => sumBy(monthTxs.filter((t) => t.type === 'expense'), 'amount'), [monthTxs]);
  const balance      = totalIncome - totalExpense;

  // Dữ liệu pie chart theo danh mục chi
  const expensePieData = useMemo(() => {
    const expTxs   = monthTxs.filter((t) => t.type === 'expense');
    const grouped  = groupBy(expTxs, 'categoryId');
    return Object.entries(grouped)
      .map(([catId, txs]) => ({
        name:  getCategoryById(catId).name,
        value: sumBy(txs, 'amount'),
        color: getCategoryById(catId).color,
      }))
      .sort((a, b) => b.value - a.value)
      .slice(0, 6);
  }, [monthTxs]);

  // Tính spent per budget
  const budgetSpent = useMemo(() => {
    const result = {};
    budgets.forEach((b) => {
      result[b.id] = sumBy(
        monthTxs.filter((t) => t.type === 'expense' && t.categoryId === b.categoryId),
        'amount',
      );
    });
    return result;
  }, [budgets, monthTxs]);

  // 5 giao dịch gần nhất
  const recentTxs = useMemo(
    () => [...transactions].sort((a, b) => new Date(b.date) - new Date(a.date)).slice(0, 6),
    [transactions],
  );

  const greeting = () => {
    const h = new Date().getHours();
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <p className="text-slate-500 dark:text-slate-400 text-sm">{greeting()},</p>
          <h1 className="text-2xl font-bold text-slate-800 dark:text-white">
            {user?.name?.split(' ').slice(-1)[0] || 'Bạn'} 👋
          </h1>
        </div>
        <Button icon={Plus} onClick={() => setQuickAddOpen(true)}>
          Thêm giao dịch
        </Button>
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <StatCard
          label="Tổng thu tháng này"
          value={formatCurrency(totalIncome)}
          icon="TrendingUp"
          iconColor="text-income-600"
          iconBg="bg-income-50"
          change={8}
        />
        <StatCard
          label="Tổng chi tháng này"
          value={formatCurrency(totalExpense)}
          icon="TrendingDown"
          iconColor="text-expense-600"
          iconBg="bg-expense-50"
          change={-3}
        />
        <StatCard
          label="Số dư tháng này"
          value={formatCurrency(balance)}
          icon="Wallet"
          iconColor="text-primary-600"
          iconBg="bg-primary-50"
        />
      </div>

      {/* Charts row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Area chart thu/chi 7 ngày */}
        <div className="card p-5 lg:col-span-2">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700 dark:text-white">Thu / Chi 7 ngày gần nhất</h2>
            <Link to="/reports" className="text-xs text-primary-600 hover:underline flex items-center gap-0.5">
              Xem báo cáo <ArrowRight className="w-3 h-3" />
            </Link>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={MOCK_DAILY_CHART} margin={{ top: 5, right: 5, left: -20, bottom: 0 }}>
              <defs>
                <linearGradient id="thuGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%"  stopColor="#16a34a" stopOpacity={0.15} />
                  <stop offset="95%" stopColor="#16a34a" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="chiGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%"  stopColor="#dc2626" stopOpacity={0.15} />
                  <stop offset="95%" stopColor="#dc2626" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
              <XAxis dataKey="date"  tick={{ fontSize: 11, fill: '#94a3b8' }} />
              <YAxis tick={{ fontSize: 11, fill: '#94a3b8' }} tickFormatter={(v) => formatCurrency(v, true)} />
              <Tooltip content={<CustomTooltip />} />
              <Area type="monotone" dataKey="thu" stroke="#16a34a" strokeWidth={2} fill="url(#thuGradient)" name="thu" dot={false} />
              <Area type="monotone" dataKey="chi" stroke="#dc2626" strokeWidth={2} fill="url(#chiGradient)" name="chi" dot={false} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Pie chart theo danh mục */}
        <div className="card p-5">
          <h2 className="text-sm font-semibold text-slate-700 dark:text-white mb-4">
            Chi tiêu theo danh mục
          </h2>
          {expensePieData.length > 0 ? (
            <ResponsiveContainer width="100%" height={220}>
              <PieChart>
                <Pie
                  data={expensePieData}
                  cx="50%" cy="45%"
                  innerRadius={55} outerRadius={80}
                  paddingAngle={3}
                  dataKey="value"
                >
                  {expensePieData.map((entry, i) => (
                    <Cell key={i} fill={entry.color || CHART_COLORS[i % CHART_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip
                  formatter={(value) => formatCurrency(value)}
                  contentStyle={{ borderRadius: '12px', border: '1px solid #f1f5f9', fontSize: 12 }}
                />
                <Legend
                  iconType="circle"
                  iconSize={8}
                  formatter={(val) => <span style={{ fontSize: 11, color: '#64748b' }}>{val}</span>}
                />
              </PieChart>
            </ResponsiveContainer>
          ) : (
            <div className="flex items-center justify-center h-48 text-slate-400 text-sm">
              Chưa có chi tiêu tháng này
            </div>
          )}
        </div>
      </div>

      {/* Bottom row: Recent transactions + Budget */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {/* Giao dịch gần nhất */}
        <div className="card p-5">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700 dark:text-white">Giao dịch gần nhất</h2>
            <Link to="/transactions" className="text-xs text-primary-600 hover:underline flex items-center gap-0.5">
              Xem tất cả <ArrowRight className="w-3 h-3" />
            </Link>
          </div>
          <div className="space-y-1 -mx-1">
            {recentTxs.map((tx) => {
              const cat = getCategoryById(tx.categoryId);
              return (
                <div key={tx.id} className="flex items-center gap-3 p-2 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                  <CategoryIcon category={cat} size="sm" />
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-slate-700 dark:text-slate-300 truncate">{tx.description}</p>
                    <p className="text-xs text-slate-400">{cat.name} · {formatDate(tx.date)}</p>
                  </div>
                  <span className={`text-sm font-semibold flex-shrink-0 ${tx.type === 'income' ? 'text-income-600' : 'text-expense-600'}`}>
                    {tx.type === 'income' ? '+' : '-'}{formatCurrency(tx.amount, true)}
                  </span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Ngân sách */}
        <div className="card p-5">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700 dark:text-white">Ngân sách tháng này</h2>
            <Link to="/budget" className="text-xs text-primary-600 hover:underline flex items-center gap-0.5">
              Quản lý <ArrowRight className="w-3 h-3" />
            </Link>
          </div>
          <div className="space-y-4">
            {budgets.slice(0, 5).map((b) => (
              <BudgetProgressBar key={b.id} budget={b} spent={budgetSpent[b.id] || 0} compact />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
