
USE social_network_pro;

-- (0) Xóa index nếu đã tạo trước đó (KHÔNG dùng IF EXISTS)
DROP INDEX idx_created_at_user_id ON posts;

-- (1) Truy vấn: tìm tất cả bài viết năm 2026 của user_id = 1
EXPLAIN ANALYZE
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';

-- (2) Tạo composite index idx_created_at_user_id
CREATE INDEX idx_created_at_user_id
ON posts (created_at, user_id);

-- (3) Chạy lại EXPLAIN ANALYZE sau khi tạo index
EXPLAIN ANALYZE
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';

-- (4) Kiểm tra index đã được dùng chưa
EXPLAIN
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';

-- (5) Xóa index (kết thúc bài)
DROP INDEX idx_created_at_user_id ON posts;

-- (6) Kiểm tra lại index
SHOW INDEX FROM posts;
