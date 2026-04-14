// store/transactionStore.js
// Zustand store cho giao dịch, danh mục, ví

import { create } from 'zustand';
import {
  MOCK_TRANSACTIONS,
  MOCK_BUDGETS,
  MOCK_WALLETS,
} from '../constants/mockData';
import {
  EXPENSE_CATEGORIES,
  INCOME_CATEGORIES,
} from '../constants/categories';

const useTransactionStore = create((set, get) => ({
  // ── State ───────────────────────────────────────────────
  transactions:       [...MOCK_TRANSACTIONS],
  budgets:            [...MOCK_BUDGETS],
  wallets:            [...MOCK_WALLETS],
  expenseCategories:  [...EXPENSE_CATEGORIES],
  incomeCategories:   [...INCOME_CATEGORIES],
  isLoading:          false,
  error:              null,

  // ── TRANSACTIONS CRUD ───────────────────────────────────
  addTransaction: (tx) => {
    const newTx = { ...tx, id: `t${Date.now()}` };
    set((s) => ({ transactions: [newTx, ...s.transactions] }));
  },

  updateTransaction: (id, data) => {
    set((s) => ({
      transactions: s.transactions.map((t) =>
        t.id === id ? { ...t, ...data } : t,
      ),
    }));
  },

  deleteTransaction: (id) => {
    set((s) => ({
      transactions: s.transactions.filter((t) => t.id !== id),
    }));
  },

  // ── BUDGETS CRUD ────────────────────────────────────────
  addBudget: (budget) => {
    const newBudget = { ...budget, id: `b${Date.now()}` };
    set((s) => ({ budgets: [newBudget, ...s.budgets] }));
  },

  updateBudget: (id, data) => {
    set((s) => ({
      budgets: s.budgets.map((b) =>
        b.id === id ? { ...b, ...data } : b,
      ),
    }));
  },

  deleteBudget: (id) => {
    set((s) => ({ budgets: s.budgets.filter((b) => b.id !== id) }));
  },

  // ── WALLETS CRUD ────────────────────────────────────────
  addWallet: (wallet) => {
    const newWallet = { ...wallet, id: `w${Date.now()}` };
    set((s) => ({ wallets: [newWallet, ...s.wallets] }));
  },

  updateWallet: (id, data) => {
    set((s) => ({
      wallets: s.wallets.map((w) =>
        w.id === id ? { ...w, ...data } : w,
      ),
    }));
  },

  deleteWallet: (id) => {
    set((s) => ({ wallets: s.wallets.filter((w) => w.id !== id) }));
  },

  // ── CATEGORIES CRUD ─────────────────────────────────────
  addCategory: (cat, type) => {
    const newCat = { ...cat, id: `cat${Date.now()}`, isDefault: false };
    if (type === 'expense') {
      set((s) => ({ expenseCategories: [...s.expenseCategories, newCat] }));
    } else {
      set((s) => ({ incomeCategories: [...s.incomeCategories, newCat] }));
    }
  },

  updateCategory: (id, data, type) => {
    const key = type === 'expense' ? 'expenseCategories' : 'incomeCategories';
    set((s) => ({
      [key]: s[key].map((c) => (c.id === id ? { ...c, ...data } : c)),
    }));
  },

  deleteCategory: (id, type) => {
    const key = type === 'expense' ? 'expenseCategories' : 'incomeCategories';
    set((s) => ({ [key]: s[key].filter((c) => c.id !== id && !c.isDefault) }));
  },
}));

export default useTransactionStore;
