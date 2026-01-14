CREATE DATABASE social_network_pro;
USE social_network_pro;


/* Bảng Users */
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

/* Bảng Posts */
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* Bảng Comments */
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* Bảng Friends */
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20),
    CHECK (status IN ('pending','accepted')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

/* Bảng Likes */
CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);


INSERT INTO Users (username, password, email) VALUES
('an123','123','an@gmail.com'),
('binh456','123','binh@gmail.com'),
('cuong789','123','cuong@gmail.com');

INSERT INTO Posts (user_id, content) VALUES
(1,'Bài viết số 1'),
(1,'Bài viết số 2'),
(2,'Hello mọi người');


CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

SELECT * FROM vw_public_users;

/* ================================
   4. INDEX – TỐI ƯU TÌM KIẾM
================================ */

CREATE INDEX idx_username ON Users(username);

SELECT * FROM Users WHERE username = 'an123';



DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF EXISTS (SELECT * FROM Users WHERE user_id = p_user_id) THEN
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;
END $$

DELIMITER ;

CALL sp_create_post(1,'Bài viết thêm bằng Procedure');


CREATE VIEW vw_recent_posts AS
SELECT *
FROM Posts
WHERE created_at >= NOW() - INTERVAL 7 DAY;

SELECT * FROM vw_recent_posts ORDER BY created_at DESC;



CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_time ON Posts(user_id, created_at);

SELECT * FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC;



DELIMITER $$

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END $$

DELIMITER ;

CALL sp_count_posts(1, @total);
SELECT @total AS total_posts;


CREATE VIEW vw_active_users AS
SELECT *
FROM Users
WHERE created_at IS NOT NULL
WITH CHECK OPTION;

/* ================================
   10. STORED PROCEDURE – KẾT BẠN
================================ */

DELIMITER $$

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể kết bạn với chính mình';
    ELSE
        INSERT INTO Friends(user_id, friend_id, status)
        VALUES (p_user_id, p_friend_id, 'pending');
    END IF;
END $$

DELIMITER ;

CALL sp_add_friend(1,2);



DELIMITER $$

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE u_count INT;
    DECLARE p_count INT;

    SELECT COUNT(*) INTO u_count FROM Users WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO p_count FROM Posts WHERE post_id = p_post_id;

    IF u_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    ELSEIF p_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post không tồn tại';
    ELSE
        INSERT INTO Comments(user_id, post_id, content)
        VALUES (p_user_id, p_post_id, p_content);
    END IF;
END $$

DELIMITER ;

CALL sp_add_comment(2,1,'Bình luận đầu tiên');



CREATE VIEW vw_post_comments AS
SELECT c.content,
       u.username,
       c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id;

SELECT * FROM vw_post_comments;



DELIMITER $$

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    IF EXISTS (
        SELECT * FROM Likes
        WHERE user_id = p_user_id AND post_id = p_post_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã thích bài viết';
    ELSE
        INSERT INTO Likes(user_id, post_id)
        VALUES (p_user_id, p_post_id);
    END IF;
END $$

DELIMITER ;

CALL sp_like_post(1,1);
CALL sp_like_post(2,1);

CREATE INDEX idx_likes_post ON Likes(post_id);

CREATE VIEW vw_top_posts AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;

SELECT * FROM vw_top_posts;
