// api/authApi.js
// Các hàm gọi API xác thực – hiện dùng mock, thay bằng axiosInstance sau

import axiosInstance from './axiosInstance';
import { MOCK_CREDENTIALS, MOCK_USER } from '../constants/mockData';

// Delay giả lập network
const delay = (ms) => new Promise((r) => setTimeout(r, ms));

// ── Đăng nhập ────────────────────────────────────────────
export const loginApi = async ({ email, password }) => {
  // TODO: thay bằng axiosInstance.post('/auth/login', { email, password })
  await delay(800);
  if (
    email === MOCK_CREDENTIALS.email &&
    password === MOCK_CREDENTIALS.password
  ) {
    return { user: MOCK_USER, token: MOCK_CREDENTIALS.token };
  }
  throw new Error('Email hoặc mật khẩu không đúng');
};

// ── Đăng ký ──────────────────────────────────────────────
export const registerApi = async ({ name, email, password }) => {
  // TODO: thay bằng axiosInstance.post('/auth/register', { name, email, password })
  await delay(1000);
  return {
    user: { ...MOCK_USER, name, email, id: `u${Date.now()}` },
    token: `mock_token_${Date.now()}`,
  };
};

// ── Đổi mật khẩu ─────────────────────────────────────────
export const changePasswordApi = async ({ oldPassword, newPassword }) => {
  await delay(600);
  return { success: true };
};

// ── Lấy thông tin user hiện tại ──────────────────────────
export const getMeApi = async () => {
  // TODO: thay bằng axiosInstance.get('/auth/me')
  await delay(300);
  return MOCK_USER;
};
