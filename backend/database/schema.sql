-- ============================================================
-- SCHEMA: Web Quản Lý Chi Tiêu Tích Hợp AI
-- Database: expense_management
-- MySQL 8+
-- ============================================================

DROP DATABASE IF EXISTS expense_management;
CREATE DATABASE expense_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE expense_management;

-- ============================================================
-- 1. USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email        VARCHAR(255)   NOT NULL UNIQUE,
  password_hash VARCHAR(255)  NOT NULL,
  full_name    VARCHAR(100)   NOT NULL,
  avatar_url   VARCHAR(500)   NULL,
  currency     VARCHAR(10)    NOT NULL DEFAULT 'VND',
  theme        ENUM('light','dark') NOT NULL DEFAULT 'light',
  created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. ACCOUNTS (Ví / Tài khoản ngân hàng)
-- ============================================================
CREATE TABLE IF NOT EXISTS accounts (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED   NOT NULL,
  name         VARCHAR(100)   NOT NULL,
  type         ENUM('cash','bank','e_wallet','credit_card') NOT NULL DEFAULT 'cash',
  balance      DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
  color        VARCHAR(20)    NOT NULL DEFAULT '#6366f1',
  icon         VARCHAR(50)    NOT NULL DEFAULT 'Wallet',
  is_default   TINYINT(1)     NOT NULL DEFAULT 0,
  created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_accounts_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_accounts_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. CATEGORIES (Danh mục – hệ thống & riêng từng user)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED   NULL,          -- NULL = danh mục hệ thống
  parent_id    INT UNSIGNED   NULL,          -- Danh mục cha (tự tham chiếu)
  name         VARCHAR(100)   NOT NULL,
  type         ENUM('income','expense') NOT NULL,
  icon         VARCHAR(50)    NOT NULL DEFAULT 'Tag',
  color        VARCHAR(20)    NOT NULL DEFAULT '#6366f1',
  is_default   TINYINT(1)     NOT NULL DEFAULT 0,

  CONSTRAINT fk_categories_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id)
    REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX idx_categories_user_id (user_id),
  INDEX idx_categories_type (type),
  INDEX idx_categories_is_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. TRANSACTIONS (Giao dịch thu/chi)
-- ============================================================
CREATE TABLE IF NOT EXISTS transactions (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNSIGNED   NOT NULL,
  account_id       INT UNSIGNED   NOT NULL,
  category_id      INT UNSIGNED   NOT NULL,
  type             ENUM('income','expense') NOT NULL,
  amount           DECIMAL(15,2)  NOT NULL,
  description      VARCHAR(255)   NOT NULL DEFAULT '',
  note             TEXT           NULL,
  image_url        VARCHAR(500)   NULL,
  transaction_date DATE           NOT NULL,
  created_at       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_transactions_user     FOREIGN KEY (user_id)     REFERENCES users(id)       ON DELETE CASCADE,
  CONSTRAINT fk_transactions_account  FOREIGN KEY (account_id)  REFERENCES accounts(id)    ON DELETE RESTRICT,
  CONSTRAINT fk_transactions_category FOREIGN KEY (category_id) REFERENCES categories(id)  ON DELETE RESTRICT,

  INDEX idx_transactions_user_id          (user_id),
  INDEX idx_transactions_account_id       (account_id),
  INDEX idx_transactions_category_id      (category_id),
  INDEX idx_transactions_date             (transaction_date),
  INDEX idx_transactions_user_date        (user_id, transaction_date),
  INDEX idx_transactions_user_type        (user_id, type),
  INDEX idx_transactions_user_cat_date    (user_id, category_id, transaction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. BUDGETS (Ngân sách theo tháng)
-- ============================================================
CREATE TABLE IF NOT EXISTS budgets (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED   NOT NULL,
  category_id  INT UNSIGNED   NOT NULL,
  amount_limit DECIMAL(15,2)  NOT NULL,
  month        TINYINT        NOT NULL COMMENT '1-12',
  year         INT            NOT NULL,
  created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_budgets_user     FOREIGN KEY (user_id)    REFERENCES users(id)      ON DELETE CASCADE,
  CONSTRAINT fk_budgets_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  UNIQUE KEY uq_budget_user_cat_month_year (user_id, category_id, month, year),
  INDEX idx_budgets_user_month_year (user_id, month, year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6. TRANSFERS (Chuyển tiền giữa các ví)
-- ============================================================
CREATE TABLE IF NOT EXISTS transfers (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         INT UNSIGNED   NOT NULL,
  from_account_id INT UNSIGNED   NOT NULL,
  to_account_id   INT UNSIGNED   NOT NULL,
  amount          DECIMAL(15,2)  NOT NULL,
  fee             DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
  description     VARCHAR(255)   NULL,
  transfer_date   DATE           NOT NULL,
  created_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_transfers_user         FOREIGN KEY (user_id)         REFERENCES users(id)    ON DELETE CASCADE,
  CONSTRAINT fk_transfers_from_account FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE RESTRICT,
  CONSTRAINT fk_transfers_to_account   FOREIGN KEY (to_account_id)   REFERENCES accounts(id) ON DELETE RESTRICT,

  INDEX idx_transfers_user_id       (user_id),
  INDEX idx_transfers_from_account  (from_account_id),
  INDEX idx_transfers_to_account    (to_account_id),
  INDEX idx_transfers_date          (transfer_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 7. RECURRING TRANSACTIONS (Giao dịch định kỳ)
-- ============================================================
CREATE TABLE IF NOT EXISTS recurring_transactions (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED   NOT NULL,
  account_id   INT UNSIGNED   NOT NULL,
  category_id  INT UNSIGNED   NOT NULL,
  type         ENUM('income','expense') NOT NULL,
  amount       DECIMAL(15,2)  NOT NULL,
  description  VARCHAR(255)   NOT NULL DEFAULT '',
  frequency    ENUM('daily','weekly','monthly','yearly') NOT NULL,
  start_date   DATE           NOT NULL,
  next_date    DATE           NOT NULL,
  is_active    TINYINT(1)     NOT NULL DEFAULT 1,
  created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_recurring_user     FOREIGN KEY (user_id)    REFERENCES users(id)      ON DELETE CASCADE,
  CONSTRAINT fk_recurring_account  FOREIGN KEY (account_id)  REFERENCES accounts(id)   ON DELETE RESTRICT,
  CONSTRAINT fk_recurring_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,

  INDEX idx_recurring_user_id    (user_id),
  INDEX idx_recurring_next_date  (next_date),
  INDEX idx_recurring_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 8. AI_CONVERSATIONS (Phiên chat AI)
-- ============================================================
CREATE TABLE IF NOT EXISTS ai_conversations (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED  NOT NULL,
  title      VARCHAR(255)  NOT NULL DEFAULT 'Cuộc trò chuyện mới',
  created_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_ai_conv_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_ai_conv_user_id (user_id),
  INDEX idx_ai_conv_updated (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 9. AI_MESSAGES (Tin nhắn trong phiên chat)
-- ============================================================
CREATE TABLE IF NOT EXISTS ai_messages (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  conversation_id INT UNSIGNED  NOT NULL,
  role            ENUM('user','assistant') NOT NULL,
  content         TEXT          NOT NULL,
  created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_ai_msg_conversation FOREIGN KEY (conversation_id)
    REFERENCES ai_conversations(id) ON DELETE CASCADE,
  INDEX idx_ai_msg_conversation_id (conversation_id),
  INDEX idx_ai_msg_created_at      (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 10. NOTIFICATIONS (Thông báo)
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     INT UNSIGNED  NOT NULL,
  title       VARCHAR(200)  NOT NULL,
  message     TEXT          NOT NULL,
  type        ENUM('budget_warning','recurring','system','transfer') NOT NULL DEFAULT 'system',
  is_read     TINYINT(1)    NOT NULL DEFAULT 0,
  related_id  INT           NULL COMMENT 'ID liên quan (transaction_id, budget_id...)',
  created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_notifications_user_id   (user_id),
  INDEX idx_notifications_is_read   (is_read),
  INDEX idx_notifications_user_read (user_id, is_read),
  INDEX idx_notifications_created   (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- ============================================================
-- 11. FINANCIAL_HEALTH_SCORES (Điểm sức khoẻ tài chính)
-- ============================================================
CREATE TABLE IF NOT EXISTS financial_health_scores (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNSIGNED NOT NULL,
  month            TINYINT NOT NULL COMMENT '1-12',
  year             INT NOT NULL,
  total_score      INT NOT NULL DEFAULT 0,
  grade            VARCHAR(20),
  score_savings    INT DEFAULT 0,
  score_budget     INT DEFAULT 0,
  score_stability  INT DEFAULT 0,
  score_diversity  INT DEFAULT 0,
  score_trend      INT DEFAULT 0,
  savings_rate     DECIMAL(5,2) DEFAULT 0,
  cv_value         DECIMAL(5,2) DEFAULT 0,
  income_sources   INT DEFAULT 0,
  created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_user_month_year (user_id, month, year),
  CONSTRAINT fk_health_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_health_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
