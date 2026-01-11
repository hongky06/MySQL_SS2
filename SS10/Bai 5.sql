
USE social_network_pro;

-- (0) Nếu trước đó đã tạo idx_hometown thì xóa đi để đo "TRƯỚC index"
=
DROP INDEX idx_hometown ON users;

-- =========================================
-- (3) TRUY VẤN: users ở "Hà Nội" + JOIN posts


-- (4) EXPLAIN ANALYZE TRƯỚC KHI CÓ INDEX
EXPLAIN ANALYZE
SELECT
    u.username,
    p.post_id,
    p.content
FROM users u
JOIN posts p ON p.user_id = u.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- =========================================
-- (2) TẠO INDEX idx_hometown TRÊN users(hometown)
-- =========================================
CREATE INDEX idx_hometown ON users (hometown);

-- (4) EXPLAIN ANALYZE SAU KHI CÓ INDEX
EXPLAIN ANALYZE
SELECT
    u.username,
    p.post_id,
    p.content
FROM users u
JOIN posts p ON p.user_id = u.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- Xem nhanh MySQL có dùng idx_hometown không
EXPLAIN
SELECT
    u.username,
    p.post_id,
    p.content
FROM users u
JOIN posts p ON p.user_id = u.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- (Tuỳ chọn) Kiểm tra index
SHOW INDEX FROM users;
