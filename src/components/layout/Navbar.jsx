// components/layout/Navbar.jsx
// Top navigation bar: breadcrumb, search, notifications, user menu

import { useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Menu, Bell, Search, ChevronRight, LogOut, User, Settings } from 'lucide-react';
import useAuthStore from '../../store/authStore';
import useUIStore   from '../../store/uiStore';
import toast from 'react-hot-toast';

// Map route → tên trang
const PAGE_NAMES = {
  '/dashboard':        'Tổng quan',
  '/transactions':     'Giao dịch',
  '/budget':           'Ngân sách',
  '/reports':          'Báo cáo',
  '/ai-chat':          'AI Tư vấn',
  '/categories':       'Danh mục',
  '/wallets':          'Ví / Tài khoản',
  '/settings':         'Cài đặt',
};

const Navbar = () => {
  const { user, logout }           = useAuthStore();
  const { toggleSidebar, sidebarOpen } = useUIStore();
  const location                   = useLocation();
  const navigate                   = useNavigate();
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const [searchValue, setSearchValue]   = useState('');

  const pageName = PAGE_NAMES[location.pathname] || 'Trang';

  const handleLogout = () => {
    logout();
    toast.success('Đã đăng xuất');
    navigate('/login');
  };

  return (
    <header className="fixed top-0 right-0 z-20 h-[var(--navbar-height)] bg-white/80 dark:bg-dark-800/80 backdrop-blur-md border-b border-slate-100 dark:border-slate-700/50 transition-all duration-300"
      style={{
        left: `var(--sidebar-width, 260px)`,
        // Điều chỉnh khi sidebar thu/mở
      }}
    >
      <div className="flex items-center h-full px-4 gap-3">
        {/* Hamburger – mobile */}
        <button
          onClick={toggleSidebar}
          className="p-2 rounded-xl text-slate-500 hover:text-slate-700 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors lg:hidden"
        >
          <Menu className="w-5 h-5" />
        </button>

        {/* Breadcrumb */}
        <div className="flex items-center gap-1.5 text-sm">
          <span className="text-slate-400 dark:text-slate-500 hidden sm:block">FinanceAI</span>
          <ChevronRight className="w-3.5 h-3.5 text-slate-300 hidden sm:block" />
          <span className="font-semibold text-slate-800 dark:text-white">{pageName}</span>
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* Search bar – desktop */}
        <div className="relative hidden md:block">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            placeholder="Tìm kiếm..."
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            className="pl-9 pr-4 py-2 text-sm rounded-xl border border-slate-200 dark:border-slate-600 bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-primary-500/30 focus:border-primary-400 w-52 transition-all"
          />
        </div>

        {/* Notification bell */}
        <button className="relative p-2 rounded-xl text-slate-500 hover:text-slate-700 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
          <Bell className="w-5 h-5" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-expense-500 rounded-full ring-2 ring-white dark:ring-dark-800" />
        </button>

        {/* User menu */}
        <div className="relative">
          <button
            onClick={() => setUserMenuOpen(!userMenuOpen)}
            className="flex items-center gap-2 p-1 pr-2.5 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
          >
            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary-400 to-primary-600 flex items-center justify-center">
              <span className="text-xs font-bold text-white">
                {user?.name?.charAt(0)?.toUpperCase() || 'U'}
              </span>
            </div>
            <span className="text-sm font-medium text-slate-700 dark:text-slate-300 hidden sm:block">
              {user?.name?.split(' ').slice(-1)[0] || 'User'}
            </span>
          </button>

          {/* Dropdown menu */}
          {userMenuOpen && (
            <>
              <div className="fixed inset-0 z-10" onClick={() => setUserMenuOpen(false)} />
              <div className="absolute right-0 top-full mt-2 w-52 bg-white dark:bg-dark-800 rounded-2xl shadow-card-lg border border-slate-100 dark:border-slate-700 z-20 animate-slide-up overflow-hidden">
                <div className="p-3 border-b border-slate-100 dark:border-slate-700">
                  <p className="text-sm font-semibold text-slate-800 dark:text-white">{user?.name}</p>
                  <p className="text-xs text-slate-400 truncate">{user?.email}</p>
                </div>
                <div className="p-1.5">
                  <button
                    onClick={() => { navigate('/settings'); setUserMenuOpen(false); }}
                    className="flex items-center gap-2.5 w-full px-3 py-2 text-sm text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl transition-colors"
                  >
                    <User className="w-4 h-4" /> Hồ sơ cá nhân
                  </button>
                  <button
                    onClick={() => { navigate('/settings'); setUserMenuOpen(false); }}
                    className="flex items-center gap-2.5 w-full px-3 py-2 text-sm text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl transition-colors"
                  >
                    <Settings className="w-4 h-4" /> Cài đặt
                  </button>
                  <button
                    onClick={handleLogout}
                    className="flex items-center gap-2.5 w-full px-3 py-2 text-sm text-expense-600 hover:bg-expense-50 dark:hover:bg-expense-900/20 rounded-xl transition-colors mt-1"
                  >
                    <LogOut className="w-4 h-4" /> Đăng xuất
                  </button>
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  );
};

export default Navbar;
