-- ============================================================
-- SEED DATA: Web Quản Lý Chi Tiêu Tích Hợp AI
-- Chạy SAU khi đã chạy schema.sql
-- ============================================================

USE expense_management;

-- ============================================================
-- CATEGORIES HỆ THỐNG (user_id = NULL, is_default = 1)
-- ============================================================

-- CHI TIÊU (expense)
INSERT INTO categories (user_id, parent_id, name, type, icon, color, is_default) VALUES
(NULL, NULL, 'Ăn uống',      'expense', 'UtensilsCrossed', '#f59e0b', 1),
(NULL, NULL, 'Di chuyển',    'expense', 'Car',              '#3b82f6', 1),
(NULL, NULL, 'Mua sắm',      'expense', 'ShoppingBag',      '#ec4899', 1),
(NULL, NULL, 'Giải trí',     'expense', 'Gamepad2',         '#8b5cf6', 1),
(NULL, NULL, 'Sức khỏe',     'expense', 'HeartPulse',       '#ef4444', 1),
(NULL, NULL, 'Giáo dục',     'expense', 'BookOpen',         '#06b6d4', 1),
(NULL, NULL, 'Hóa đơn',      'expense', 'FileText',         '#64748b', 1),
(NULL, NULL, 'Nhà ở',        'expense', 'Home',             '#10b981', 1),
(NULL, NULL, 'Làm đẹp',      'expense', 'Sparkles',         '#f43f5e', 1),
(NULL, NULL, 'Du lịch',      'expense', 'Plane',            '#0ea5e9', 1),
(NULL, NULL, 'Quà tặng',     'expense', 'Gift',             '#a855f7', 1),
(NULL, NULL, 'Chi khác',     'expense', 'MoreHorizontal',   '#94a3b8', 1);

-- THU NHẬP (income)
INSERT INTO categories (user_id, parent_id, name, type, icon, color, is_default) VALUES
(NULL, NULL, 'Lương',        'income',  'Banknote',         '#22c55e', 1),
(NULL, NULL, 'Thưởng',       'income',  'Trophy',           '#f59e0b', 1),
(NULL, NULL, 'Đầu tư',       'income',  'TrendingUp',       '#3b82f6', 1),
(NULL, NULL, 'Freelance',    'income',  'Laptop',           '#8b5cf6', 1),
(NULL, NULL, 'Quà nhận',     'income',  'Gift',             '#ec4899', 1),
(NULL, NULL, 'Thu khác',     'income',  'PlusCircle',       '#94a3b8', 1);

-- ============================================================
-- USER TEST
-- email: test@gmail.com | password: 123456
-- Bcrypt hash của "123456" với saltRounds=10
-- ============================================================
INSERT INTO users (email, password_hash, full_name, currency, theme) VALUES
('test@gmail.com',
 '$2a$10$qB1CUFCeOxyqGkkoLaP0Te5LeJPryHNQMkwdLt4DDzarrFIsBZx2.',
 'Nguyễn Test User', 'VND', 'light');

-- Lấy user_id vừa tạo
SET @user_id = LAST_INSERT_ID();

-- ============================================================
-- TÀI KHOẢN
-- ============================================================
INSERT INTO accounts (user_id, name, type, balance, color, icon, is_default) VALUES
(@user_id, 'Tien mat', 'cash',     2000000.00,  '#f59e0b', 'Wallet',     1),
(@user_id, 'MB Bank',  'bank',     15000000.00, '#2563eb', 'CreditCard', 0),
(@user_id, 'MoMo',     'e_wallet',   500000.00, '#a855f7', 'Smartphone', 0);

SET @acc_cash  = (SELECT id FROM accounts WHERE user_id = @user_id AND name = 'Tiền mặt');
SET @acc_bank  = (SELECT id FROM accounts WHERE user_id = @user_id AND name = 'MB Bank');
SET @acc_momo  = (SELECT id FROM accounts WHERE user_id = @user_id AND name = 'MoMo');

-- ============================================================
-- LẤY ID DANH MỤC HỆ THỐNG
-- ============================================================
SET @cat_food       = (SELECT id FROM categories WHERE name = 'Ăn uống'   AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_transport  = (SELECT id FROM categories WHERE name = 'Di chuyển' AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_shopping   = (SELECT id FROM categories WHERE name = 'Mua sắm'   AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_entertain  = (SELECT id FROM categories WHERE name = 'Giải trí'  AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_health     = (SELECT id FROM categories WHERE name = 'Sức khỏe'  AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_education  = (SELECT id FROM categories WHERE name = 'Giáo dục'  AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_bills      = (SELECT id FROM categories WHERE name = 'Hóa đơn'   AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_housing    = (SELECT id FROM categories WHERE name = 'Nhà ở'     AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_beauty     = (SELECT id FROM categories WHERE name = 'Làm đẹp'   AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_travel     = (SELECT id FROM categories WHERE name = 'Du lịch'   AND type = 'expense' AND user_id IS NULL LIMIT 1);
SET @cat_salary     = (SELECT id FROM categories WHERE name = 'Lương'     AND type = 'income'  AND user_id IS NULL LIMIT 1);
SET @cat_bonus      = (SELECT id FROM categories WHERE name = 'Thưởng'    AND type = 'income'  AND user_id IS NULL LIMIT 1);
SET @cat_invest     = (SELECT id FROM categories WHERE name = 'Đầu tư'    AND type = 'income'  AND user_id IS NULL LIMIT 1);
SET @cat_freelance  = (SELECT id FROM categories WHERE name = 'Freelance'  AND type = 'income'  AND user_id IS NULL LIMIT 1);

-- ============================================================
-- GIAO DỊCH 3 THÁNG GẦN NHẤT (40+ giao dịch để test báo cáo)
-- ============================================================

-- ── THÁNG 2 THÁNG TRƯỚC ───────────────────────────────────
INSERT INTO transactions (user_id, account_id, category_id, type, amount, description, transaction_date) VALUES
(@user_id, @acc_bank,  @cat_salary,    'income',  12000000, 'Lương tháng',                DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01')),
(@user_id, @acc_bank,  @cat_food,      'expense',  850000,  'Ăn uống cả tháng',           DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-05')),
(@user_id, @acc_cash,  @cat_transport, 'expense',  300000,  'Đi lại tháng',               DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-08')),
(@user_id, @acc_bank,  @cat_bills,     'expense', 1200000,  'Tiền điện nước',             DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-10')),
(@user_id, @acc_bank,  @cat_housing,   'expense', 3000000,  'Tiền thuê nhà',              DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01')),
(@user_id, @acc_cash,  @cat_shopping,  'expense',  650000,  'Mua đồ dùng',                DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-15')),
(@user_id, @acc_bank,  @cat_health,    'expense',  500000,  'Khám sức khỏe',              DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-20')),
(@user_id, @acc_bank,  @cat_freelance, 'income',  2000000,  'Thu nhập thêm',              DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-25'));

-- ── THÁNG TRƯỚC ──────────────────────────────────────────
INSERT INTO transactions (user_id, account_id, category_id, type, amount, description, transaction_date) VALUES
(@user_id, @acc_bank,  @cat_salary,    'income',  12000000, 'Lương tháng',                DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')),
(@user_id, @acc_bank,  @cat_bonus,     'income',   1500000, 'Thưởng hoàn thành dự án',   DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-05')),
(@user_id, @acc_cash,  @cat_food,      'expense',   85000,  'Cơm trưa văn phòng',        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-02')),
(@user_id, @acc_cash,  @cat_food,      'expense',  120000,  'Coffee với đồng nghiệp',    DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-04')),
(@user_id, @acc_bank,  @cat_shopping,  'expense',  350000,  'Mua áo H&M',                DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-06')),
(@user_id, @acc_momo,  @cat_transport, 'expense',  200000,  'Grab đi làm cả tuần',       DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-08')),
(@user_id, @acc_bank,  @cat_bills,     'expense', 1200000,  'Tiền điện tháng',            DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-10')),
(@user_id, @acc_cash,  @cat_entertain, 'expense',  450000,  'Netflix + Spotify',          DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-12')),
(@user_id, @acc_bank,  @cat_housing,   'expense', 3000000,  'Tiền thuê nhà tháng',        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')),
(@user_id, @acc_cash,  @cat_food,      'expense',  250000,  'Đi ăn sinh nhật bạn',       DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-14')),
(@user_id, @acc_bank,  @cat_health,    'expense',  800000,  'Khám sức khỏe định kỳ',     DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-16')),
(@user_id, @acc_bank,  @cat_education, 'expense',  180000,  'Mua sách Atomic Habits',    DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-18')),
(@user_id, @acc_momo,  @cat_beauty,    'expense',  300000,  'Cắt tóc + dưỡng da',        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-20')),
(@user_id, @acc_bank,  @cat_invest,    'income',  1000000,  'Cổ tức chứng khoán',         DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-22')),
(@user_id, @acc_bank,  @cat_travel,    'expense',  500000,  'Đặt vé xe đi Đà Lạt',       DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-24')),
(@user_id, @acc_bank,  @cat_freelance, 'income',  2500000,  'Dự án thiết kế web',         DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-26'));

-- ── THÁNG HIỆN TẠI ───────────────────────────────────────
INSERT INTO transactions (user_id, account_id, category_id, type, amount, description, note, transaction_date) VALUES
(@user_id, @acc_bank,  @cat_salary,    'income',  12000000, 'Lương tháng này',            '', DATE_FORMAT(CURDATE(), '%Y-%m-01')),
(@user_id, @acc_bank,  @cat_housing,   'expense', 3000000,  'Tiền thuê nhà',              '', DATE_FORMAT(CURDATE(), '%Y-%m-01')),
(@user_id, @acc_cash,  @cat_food,      'expense',   85000,  'Cơm trưa văn phòng',        '', DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(@user_id, @acc_bank,  @cat_shopping,  'expense',  350000,  'Mua áo H&M',                'Sale 30%', DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(@user_id, @acc_momo,  @cat_transport, 'expense',  200000,  'Grab đi làm cả tuần',       '', DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(@user_id, @acc_bank,  @cat_bills,     'expense', 1200000,  'Tiền điện tháng',            '', DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(@user_id, @acc_cash,  @cat_entertain, 'expense',  450000,  'Netflix + Spotify',          'Gia hạn 3 tháng', DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(@user_id, @acc_bank,  @cat_freelance, 'income',  2500000,  'Dự án thiết kế web',         '', DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(@user_id, @acc_cash,  @cat_food,      'expense',  120000,  'Coffee với khách hàng',     '', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(@user_id, @acc_bank,  @cat_health,    'expense',  800000,  'Khám sức khỏe định kỳ',     'Bệnh viện FV', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(@user_id, @acc_cash,  @cat_food,      'expense',  250000,  'Đi ăn sinh nhật bạn',       '', DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(@user_id, @acc_bank,  @cat_bonus,     'income',   500000,  'Thưởng hoàn thành dự án',   '', DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
(@user_id, @acc_bank,  @cat_shopping,  'expense',  650000,  'Mua đồ dùng gia đình',      'IKEA', DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
(@user_id, @acc_cash,  @cat_food,      'expense',   90000,  'Bún bò Huế',                '', DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
(@user_id, @acc_bank,  @cat_education, 'expense',  180000,  'Mua sách lập trình',        '', DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
(@user_id, @acc_momo,  @cat_beauty,    'expense',  300000,  'Cắt tóc + dưỡng da',        '', DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
(@user_id, @acc_bank,  @cat_invest,    'income',  1000000,  'Cổ tức chứng khoán',         '', DATE_SUB(CURDATE(), INTERVAL 11 DAY)),
(@user_id, @acc_bank,  @cat_travel,    'expense',  500000,  'Đặt vé xe đi Đà Lạt',       '', DATE_SUB(CURDATE(), INTERVAL 12 DAY)),
(@user_id, @acc_cash,  @cat_food,      'expense',  150000,  'Đặt đồ ăn Baemin',          '', DATE_SUB(CURDATE(), INTERVAL 13 DAY)),
(@user_id, @acc_momo,  @cat_transport, 'expense',  400000,  'Đổ xăng xe máy',            '', DATE_SUB(CURDATE(), INTERVAL 14 DAY));

-- ============================================================
-- NGÂN SÁCH THÁNG HIỆN TẠI
-- ============================================================
INSERT INTO budgets (user_id, category_id, amount_limit, month, year) VALUES
(@user_id, @cat_food,      3000000, MONTH(CURDATE()), YEAR(CURDATE())),
(@user_id, @cat_shopping,  2000000, MONTH(CURDATE()), YEAR(CURDATE())),
(@user_id, @cat_transport, 1000000, MONTH(CURDATE()), YEAR(CURDATE())),
(@user_id, @cat_entertain,  500000, MONTH(CURDATE()), YEAR(CURDATE())),
(@user_id, @cat_health,    1500000, MONTH(CURDATE()), YEAR(CURDATE()));

-- ============================================================
-- THÔNG BÁO MẪU
-- ============================================================
INSERT INTO notifications (user_id, title, message, type, is_read) VALUES
(@user_id, 'Chào mừng!', 'Chào mừng bạn đến với Web Quản Lý Chi Tiêu. Hãy bắt đầu theo dõi chi tiêu của bạn ngay!', 'system', 0),
(@user_id, 'Ngân sách Ăn uống gần đạt giới hạn', 'Bạn đã chi 73% ngân sách Ăn uống tháng này. Hãy cân nhắc chi tiêu!', 'budget_warning', 0);

SELECT 'Seed completed successfully!' AS status;
