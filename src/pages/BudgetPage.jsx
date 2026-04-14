// pages/BudgetPage.jsx
// Quản lý ngân sách: CRUD + BudgetProgressBar + cảnh báo

import { useMemo, useState } from 'react';
import { Plus, Pencil, Trash2, AlertTriangle } from 'lucide-react';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import toast from 'react-hot-toast';
import useTransactionStore from '../store/transactionStore';
import { formatCurrency } from '../utils/formatCurrency';
import { sumBy, calcPercent } from '../utils/calcPercent';
import { getCategoryById }    from '../constants/categories';
import BudgetProgressBar      from '../components/ui/BudgetProgressBar';
import CategoryIcon           from '../components/ui/CategoryIcon';
import AmountInput            from '../components/ui/AmountInput';
import Button                 from '../components/ui/Button';
import Modal                  from '../components/ui/Modal';
import ConfirmDialog          from '../components/ui/ConfirmDialog';
import EmptyState             from '../components/ui/EmptyState';
import dayjs from 'dayjs';

const schema = yup.object({
  categoryId: yup.string().required('Chọn danh mục'),
  limit:      yup.number().min(10000, 'Tối thiểu 10.000₫').required('Nhập hạn mức'),
});

const BudgetPage = () => {
  const { budgets, transactions, expenseCategories, addBudget, updateBudget, deleteBudget } =
    useTransactionStore();

  const [modalOpen, setModalOpen] = useState(false);
  const [editData,  setEditData]  = useState(null);
  const [deleteId,  setDeleteId]  = useState(null);

  const thisMonth = dayjs().format('YYYY-MM');
  const monthTxs  = transactions.filter((t) => t.date?.startsWith(thisMonth) && t.type === 'expense');

  // Tính spent theo từng budget
  const budgetSpent = useMemo(() => {
    const result = {};
    budgets.forEach((b) => {
      result[b.id] = sumBy(monthTxs.filter((t) => t.categoryId === b.categoryId), 'amount');
    });
    return result;
  }, [budgets, monthTxs]);

  const totalLimit = useMemo(() => sumBy(budgets, 'limit'), [budgets]);
  const totalSpent = useMemo(() => Object.values(budgetSpent).reduce((s, v) => s + v, 0), [budgetSpent]);

  const exceededCount = budgets.filter((b) => calcPercent(budgetSpent[b.id] || 0, b.limit) >= 100).length;
  const warningCount  = budgets.filter((b) => {
    const p = calcPercent(budgetSpent[b.id] || 0, b.limit);
    return p >= 80 && p < 100;
  }).length;

  const {
    register, handleSubmit, control, reset, formState: { errors, isSubmitting },
  } = useForm({ resolver: yupResolver(schema) });

  const openAdd = () => {
    setEditData(null);
    reset({ categoryId: '', limit: 0 });
    setModalOpen(true);
  };

  const openEdit = (b) => {
    setEditData(b);
    reset({ categoryId: b.categoryId, limit: b.limit });
    setModalOpen(true);
  };

  const onSubmit = (data) => {
    const payload = { ...data, period: 'month', month: thisMonth };
    if (editData) {
      updateBudget(editData.id, payload);
      toast.success('Đã cập nhật ngân sách');
    } else {
      addBudget(payload);
      toast.success('Đã thêm ngân sách mới');
    }
    setModalOpen(false);
  };

  const usedCategoryIds = budgets.map((b) => b.categoryId);
  const availableCats   = expenseCategories.filter(
    (c) => !usedCategoryIds.includes(c.id) || editData?.categoryId === c.id,
  );

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-800 dark:text-white">Ngân sách</h1>
          <p className="text-sm text-slate-500 dark:text-slate-400">
            Tháng {dayjs().format('MM/YYYY')}
          </p>
        </div>
        <Button icon={Plus} size="sm" onClick={openAdd}>
          Thêm ngân sách
        </Button>
      </div>

      {/* Alert */}
      {(exceededCount > 0 || warningCount > 0) && (
        <div className="flex items-start gap-3 p-4 rounded-2xl bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800">
          <AlertTriangle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
          <div>
            <p className="text-sm font-semibold text-amber-800 dark:text-amber-300">Cảnh báo ngân sách</p>
            <p className="text-xs text-amber-700 dark:text-amber-400 mt-0.5">
              {exceededCount > 0 && `${exceededCount} danh mục đã vượt hạn mức. `}
              {warningCount  > 0 && `${warningCount} danh mục sắp đạt hạn mức (≥80%).`}
            </p>
          </div>
        </div>
      )}

      {/* Summary */}
      <div className="grid grid-cols-3 gap-3">
        {[
          { label: 'Tổng hạn mức',  value: formatCurrency(totalLimit),          color: 'text-primary-600'  },
          { label: 'Đã chi tiêu',   value: formatCurrency(totalSpent),           color: 'text-expense-600'  },
          { label: 'Còn lại',       value: formatCurrency(totalLimit - totalSpent), color: totalLimit >= totalSpent ? 'text-income-600' : 'text-expense-600' },
        ].map(({ label, value, color }) => (
          <div key={label} className="card p-4 text-center">
            <p className={`text-base font-bold ${color}`}>{value}</p>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">{label}</p>
          </div>
        ))}
      </div>

      {/* Budget list */}
      {budgets.length === 0 ? (
        <EmptyState
          title="Chưa có ngân sách nào"
          description="Thêm hạn mức chi tiêu cho từng danh mục để kiểm soát tài chính tốt hơn."
          action={openAdd}
          actionLabel="Thêm ngân sách đầu tiên"
        />
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {budgets.map((b) => {
            const spent = budgetSpent[b.id] || 0;
            return (
              <div key={b.id} className="relative group">
                <BudgetProgressBar budget={b} spent={spent} />
                {/* Edit/Delete overlay */}
                <div className="absolute top-3 right-3 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button
                    onClick={() => openEdit(b)}
                    className="p-1.5 rounded-lg bg-white dark:bg-dark-800 shadow-sm text-slate-400 hover:text-primary-600 transition-colors"
                  >
                    <Pencil className="w-3.5 h-3.5" />
                  </button>
                  <button
                    onClick={() => setDeleteId(b.id)}
                    className="p-1.5 rounded-lg bg-white dark:bg-dark-800 shadow-sm text-slate-400 hover:text-expense-600 transition-colors"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Modal thêm/sửa ngân sách */}
      <Modal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        title={editData ? 'Sửa ngân sách' : 'Thêm ngân sách'}
        size="sm"
        footer={
          <div className="flex justify-end gap-3">
            <Button variant="secondary" onClick={() => setModalOpen(false)}>Hủy</Button>
            <Button loading={isSubmitting} onClick={handleSubmit(onSubmit)}>Lưu</Button>
          </div>
        }
      >
        <form className="space-y-4" onSubmit={handleSubmit(onSubmit)}>
          {/* Danh mục */}
          <div>
            <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">
              Danh mục <span className="text-expense-600">*</span>
            </label>
            <select {...register('categoryId')} className="select-base" disabled={!!editData}>
              <option value="">-- Chọn danh mục --</option>
              {availableCats.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
            {errors.categoryId && <p className="mt-1 text-xs text-expense-600">{errors.categoryId.message}</p>}
          </div>

          {/* Hạn mức */}
          <Controller
            name="limit"
            control={control}
            render={({ field }) => (
              <AmountInput
                label="Hạn mức chi tiêu"
                required
                value={field.value}
                onChange={field.onChange}
                error={errors.limit?.message}
              />
            )}
          />
        </form>
      </Modal>

      {/* Confirm delete */}
      <ConfirmDialog
        isOpen={!!deleteId}
        onClose={() => setDeleteId(null)}
        onConfirm={() => { deleteBudget(deleteId); toast.success('Đã xóa ngân sách'); setDeleteId(null); }}
        title="Xóa ngân sách"
        message="Ngân sách này sẽ bị xóa. Bạn có thể thêm lại bất cứ lúc nào."
      />
    </div>
  );
};

export default BudgetPage;
