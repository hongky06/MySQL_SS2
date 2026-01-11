
-- 1) Sử dụng lại database
USE social_network_pro;

-- (Nếu view đã tồn tại thì xóa để tạo lại cho sạch)
DROP VIEW IF EXISTS view_users_summary;

-- =========================================
-- 2) Tạo VIEW view_users_summary

CREATE VIEW view_users_summary AS
SELECT
    u.user_id,
    u.username,
    COUNT(p.post_id) AS total_posts
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
GROUP BY
    u.user_id,
    u.username;

-- =========================================
-- 3) Truy vấn từ view_users_summary

SELECT
    user_id,
    username,
    total_posts
FROM view_users_summary
WHERE total_posts > 5;
