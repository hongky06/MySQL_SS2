
USE social_network_pro;

-- (2) Truy vấn tìm tất cả User ở Hà Nội + EXPLAIN ANALYZE (TRƯỚC KHI TẠO INDEX)
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

-- (3) Tạo chỉ mục idx_hometown cho cột hometown
CREATE INDEX idx_hometown ON users (hometown);

-- (4) Chạy lại truy vấn (2) với EXPLAIN ANALYZE (SAU KHI TẠO INDEX)
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

-- (4) (Tuỳ chọn) Dễ nhìn hơn: xem MySQL có dùng index không
EXPLAIN
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

-- (6) Xóa chỉ mục idx_hometown khỏi bảng users
DROP INDEX idx_hometown ON users;

-- (6) Kiểm tra lại index còn hay không
SHOW INDEX FROM users;
