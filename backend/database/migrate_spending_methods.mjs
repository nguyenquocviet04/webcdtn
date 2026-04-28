// Migration: tạo bảng phương pháp chi tiêu
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

const conn = await mysql.createConnection({
  host:     process.env.DB_HOST     || 'localhost',
  port:     parseInt(process.env.DB_PORT) || 3306,
  user:     process.env.DB_USER     || 'root',
  password: process.env.DB_PASSWORD || '123456',
  database: process.env.DB_NAME     || 'expense_management',
  charset:  'utf8mb4',
});

console.log('Connected. Running migration...');

await conn.execute(`
  CREATE TABLE IF NOT EXISTS spending_methods (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT UNSIGNED NULL,
    name       VARCHAR(100) NOT NULL,
    description TEXT,
    icon       VARCHAR(10)  DEFAULT '📊',
    is_system  BOOLEAN      DEFAULT FALSE,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
`);
console.log('✅ spending_methods table ready');

await conn.execute(`
  CREATE TABLE IF NOT EXISTS method_allocations (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    method_id  INT NOT NULL,
    label      VARCHAR(100) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    color      VARCHAR(20)  DEFAULT '#2563eb',
    sort_order INT          DEFAULT 0,
    FOREIGN KEY (method_id) REFERENCES spending_methods(id) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
`);
console.log('✅ method_allocations table ready');

// Seed system methods nếu chưa có
const [existing] = await conn.execute('SELECT id FROM spending_methods WHERE is_system = 1');

if (existing.length === 0) {
  // Insert 3 phương pháp mặc định
  const [m1] = await conn.execute(
    `INSERT INTO spending_methods (user_id, name, description, icon, is_system)
     VALUES (NULL, ?, ?, ?, 1)`,
    ['Quy tắc 50/30/20', 'Phân chia thu nhập thành 3 nhóm: Nhu cầu thiết yếu (50%), Mong muốn (30%) và Tiết kiệm (20%). Lý tưởng cho người mới bắt đầu quản lý tài chính.', '🍕'],
  );
  const [m2] = await conn.execute(
    `INSERT INTO spending_methods (user_id, name, description, icon, is_system)
     VALUES (NULL, ?, ?, ?, 1)`,
    ['Quy tắc 6 chiếc lọ', 'Chia thu nhập vào 6 lọ với mục đích rõ ràng, giúp cân bằng giữa chi tiêu hiện tại và tương lai tài chính.', '🍯'],
  );
  const [m3] = await conn.execute(
    `INSERT INTO spending_methods (user_id, name, description, icon, is_system)
     VALUES (NULL, ?, ?, ?, 1)`,
    ['Quy tắc 70/20/10', 'Đơn giản hoá tài chính cá nhân: 70% chi tiêu cuộc sống, 20% tiết kiệm & đầu tư, 10% trả nợ hoặc từ thiện.', '📊'],
  );

  const id1 = m1.insertId;
  const id2 = m2.insertId;
  const id3 = m3.insertId;

  // Allocations cho 50/30/20
  await conn.execute(
    `INSERT INTO method_allocations (method_id, label, percentage, color, sort_order) VALUES
     (?, ?, ?, ?, ?), (?, ?, ?, ?, ?), (?, ?, ?, ?, ?)`,
    [id1, 'Nhu cầu thiết yếu', 50, '#2563EB', 1,
     id1, 'Mong muốn & Giải trí', 30, '#7C3AED', 2,
     id1, 'Tiết kiệm & Đầu tư', 20, '#16A34A', 3],
  );
  // Allocations cho 6 chiếc lọ
  await conn.execute(
    `INSERT INTO method_allocations (method_id, label, percentage, color, sort_order) VALUES
     (?, ?, ?, ?, ?), (?, ?, ?, ?, ?), (?, ?, ?, ?, ?),
     (?, ?, ?, ?, ?), (?, ?, ?, ?, ?), (?, ?, ?, ?, ?)`,
    [id2, 'Chi tiêu thiết yếu', 55, '#2563EB', 1,
     id2, 'Tự do tài chính', 10, '#16A34A', 2,
     id2, 'Giáo dục & Phát triển', 10, '#D97706', 3,
     id2, 'Hưởng thụ', 10, '#EC4899', 4,
     id2, 'Tiết kiệm dài hạn', 10, '#059669', 5,
     id2, 'Từ thiện & Đóng góp', 5, '#DC2626', 6],
  );
  // Allocations cho 70/20/10
  await conn.execute(
    `INSERT INTO method_allocations (method_id, label, percentage, color, sort_order) VALUES
     (?, ?, ?, ?, ?), (?, ?, ?, ?, ?), (?, ?, ?, ?, ?)`,
    [id3, 'Chi tiêu cuộc sống', 70, '#2563EB', 1,
     id3, 'Tiết kiệm & Đầu tư', 20, '#16A34A', 2,
     id3, 'Trả nợ & Từ thiện', 10, '#D97706', 3],
  );
  console.log('✅ System methods seeded (3 methods)');
} else {
  console.log('ℹ️  System methods already exist, skipping seed');
}

await conn.end();
console.log('✅ Migration complete!');
