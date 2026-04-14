// components/transaction/TransactionModal.jsx
// Form thêm và sửa giao dịch đầy đủ

import { useEffect } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import toast from 'react-hot-toast';
import Modal from '../ui/Modal';
import Button from '../ui/Button';
import AmountInput from '../ui/AmountInput';
import CategoryIcon from '../ui/CategoryIcon';
import useTransactionStore from '../../store/transactionStore';
import { formatDate } from '../../utils/formatDate';
import dayjs from 'dayjs';

// Schema validation
const schema = yup.object({
  type:        yup.string().oneOf(['income', 'expense']).required('Chọn loại giao dịch'),
  amount:      yup.number().min(1000, 'Số tiền tối thiểu 1.000₫').required('Nhập số tiền'),
  categoryId:  yup.string().required('Chọn danh mục'),
  walletId:    yup.string().required('Chọn ví/tài khoản'),
  date:        yup.string().required('Chọn ngày'),
  description: yup.string().required('Nhập mô tả ngắn'),
  note:        yup.string(),
});

const TransactionModal = ({ isOpen, onClose, editData = null }) => {
  const {
    addTransaction, updateTransaction,
    expenseCategories, incomeCategories, wallets,
  } = useTransactionStore();

  const {
    register, handleSubmit, control, watch, setValue,
    reset, formState: { errors, isSubmitting },
  } = useForm({
    resolver: yupResolver(schema),
    defaultValues: {
      type:        'expense',
      amount:      0,
      categoryId:  '',
      walletId:    wallets[0]?.id || '',
      date:        dayjs().format('YYYY-MM-DD'),
      description: '',
      note:        '',
    },
  });

  const type = watch('type');
  const categories = type === 'income' ? incomeCategories : expenseCategories;

  // Fill form khi sửa
  useEffect(() => {
    if (editData) {
      reset({
        type:        editData.type,
        amount:      editData.amount,
        categoryId:  editData.categoryId,
        walletId:    editData.walletId,
        date:        editData.date,
        description: editData.description,
        note:        editData.note || '',
      });
    } else {
      reset({
        type: 'expense', amount: 0, categoryId: '',
        walletId: wallets[0]?.id || '',
        date: dayjs().format('YYYY-MM-DD'), description: '', note: '',
      });
    }
  }, [editData, isOpen]);

  // Reset categoryId khi đổi type
  useEffect(() => {
    if (!editData) setValue('categoryId', '');
  }, [type]);

  const onSubmit = async (data) => {
    try {
      if (editData) {
        updateTransaction(editData.id, data);
        toast.success('Đã cập nhật giao dịch');
      } else {
        addTransaction(data);
        toast.success('Đã thêm giao dịch mới');
      }
      onClose();
      reset();
    } catch {
      toast.error('Có lỗi xảy ra, thử lại sau');
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={editData ? 'Sửa giao dịch' : 'Thêm giao dịch mới'}
      size="md"
      footer={
        <div className="flex justify-end gap-3">
          <Button variant="secondary" onClick={onClose}>Hủy</Button>
          <Button
            variant={type === 'income' ? 'income' : 'primary'}
            loading={isSubmitting}
            onClick={handleSubmit(onSubmit)}
          >
            {editData ? 'Cập nhật' : 'Thêm giao dịch'}
          </Button>
        </div>
      }
    >
      <form className="space-y-4" onSubmit={handleSubmit(onSubmit)}>
        {/* Loại giao dịch */}
        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
            Loại giao dịch <span className="text-expense-600">*</span>
          </label>
          <div className="grid grid-cols-2 gap-2">
            {[
              { value: 'expense', label: 'Chi tiêu', color: 'expense' },
              { value: 'income',  label: 'Thu nhập', color: 'income'  },
            ].map(({ value, label, color }) => (
              <label
                key={value}
                className={[
                  'flex items-center justify-center gap-2 p-3 rounded-xl border-2 cursor-pointer transition-all duration-200',
                  type === value
                    ? color === 'expense'
                      ? 'border-expense-500 bg-expense-50 text-expense-700'
                      : 'border-income-500 bg-income-50 text-income-700'
                    : 'border-slate-200 hover:border-slate-300 text-slate-600',
                ].join(' ')}
              >
                <input
                  type="radio"
                  value={value}
                  {...register('type')}
                  className="sr-only"
                />
                <span className="text-sm font-semibold">{label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Số tiền */}
        <Controller
          name="amount"
          control={control}
          render={({ field }) => (
            <AmountInput
              label="Số tiền"
              required
              value={field.value}
              onChange={field.onChange}
              error={errors.amount?.message}
            />
          )}
        />

        {/* Danh mục */}
        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
            Danh mục <span className="text-expense-600">*</span>
          </label>
          <div className="grid grid-cols-3 gap-2 max-h-44 overflow-y-auto pr-1">
            {categories.map((cat) => {
              const selected = watch('categoryId') === cat.id;
              return (
                <label
                  key={cat.id}
                  className={[
                    'flex flex-col items-center gap-1.5 p-2.5 rounded-xl border-2 cursor-pointer transition-all duration-200',
                    selected
                      ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/20'
                      : 'border-slate-100 dark:border-slate-700 hover:border-slate-300',
                  ].join(' ')}
                >
                  <input type="radio" value={cat.id} {...register('categoryId')} className="sr-only" />
                  <CategoryIcon category={cat} size="sm" />
                  <span className="text-xs text-center text-slate-600 dark:text-slate-400 leading-tight line-clamp-2">
                    {cat.name}
                  </span>
                </label>
              );
            })}
          </div>
          {errors.categoryId && (
            <p className="mt-1 text-xs text-expense-600">{errors.categoryId.message}</p>
          )}
        </div>

        {/* Ví và Ngày – 2 cột */}
        <div className="grid grid-cols-2 gap-3">
          {/* Ví */}
          <div>
            <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">
              Ví/TK <span className="text-expense-600">*</span>
            </label>
            <select {...register('walletId')} className="select-base">
              {wallets.map((w) => (
                <option key={w.id} value={w.id}>{w.name}</option>
              ))}
            </select>
            {errors.walletId && (
              <p className="mt-1 text-xs text-expense-600">{errors.walletId.message}</p>
            )}
          </div>

          {/* Ngày */}
          <div>
            <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">
              Ngày <span className="text-expense-600">*</span>
            </label>
            <input type="date" {...register('date')} className="input-base" />
            {errors.date && (
              <p className="mt-1 text-xs text-expense-600">{errors.date.message}</p>
            )}
          </div>
        </div>

        {/* Mô tả */}
        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">
            Mô tả <span className="text-expense-600">*</span>
          </label>
          <input
            type="text"
            placeholder="VD: Cơm trưa, Lương tháng 4..."
            {...register('description')}
            className="input-base"
          />
          {errors.description && (
            <p className="mt-1 text-xs text-expense-600">{errors.description.message}</p>
          )}
        </div>

        {/* Ghi chú */}
        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">
            Ghi chú
          </label>
          <textarea
            rows={2}
            placeholder="Ghi chú thêm (không bắt buộc)"
            {...register('note')}
            className="input-base resize-none"
          />
        </div>
      </form>
    </Modal>
  );
};

export default TransactionModal;
