-- Nếu view đã tồn tại thì xóa để tạo lại
DROP VIEW IF EXISTS view_user_activity;

CREATE VIEW view_user_activity AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id;
