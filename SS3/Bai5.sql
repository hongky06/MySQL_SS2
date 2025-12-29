USE SchoolDB;

-- 1️⃣ Tạo bảng Score
CREATE TABLE Score (
    student_id VARCHAR(20),
    subject_id VARCHAR(20),
    mid_score DECIMAL(3,1),
    final_score DECIMAL(3,1),

    -- Khóa ngoại liên kết
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),

    -- Mỗi sinh viên chỉ có 1 bảng điểm cho 1 môn
    UNIQUE (student_id, subject_id),

    -- Ràng buộc điểm từ 0 đến 10
    CHECK (mid_score BETWEEN 0 AND 10),
    CHECK (final_score BETWEEN 0 AND 10)
);

-- 2️⃣ Thêm điểm cho ít nhất 2 sinh viên
INSERT INTO Score(student_id, subject_id, mid_score, final_score)
VALUES
('1', 'S1', 7.5, 8.0),
('1', 'S2', 6.0, 7.5),
('2', 'S1', 8.0, 9.0);

-- 3️⃣ Cập nhật điểm cuối kỳ cho 1 sinh viên
-- Ví dụ: Sinh viên 1 môn S1
UPDATE Score
SET final_score = 9.5
WHERE student_id = '1' AND subject_id = 'S1';

-- 4️⃣ Lấy toàn bộ bảng điểm
SELECT * FROM Score;

-- 5️⃣ Lấy các sinh viên có điểm cuối kỳ >= 8
SELECT *
FROM Score
WHERE final_score >= 8;
