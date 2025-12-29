USE SchoolDB;

-------------------------------
-- 1️⃣ Thêm một sinh viên mới
-------------------------------
INSERT INTO Student(student_id, full_name)
VALUES ('3', 'Le Van C');

---------------------------------------------
-- 2️⃣ Đăng ký ít nhất 2 môn cho sinh viên đó
---------------------------------------------
INSERT INTO Enrollment(student_id, subject_id, enroll_date)
VALUES
('3', 'S1', '2025-01-10'),
('3', 'S2', '2025-01-11');

--------------------------------------------------
-- 3️⃣ Thêm và cập nhật điểm cho sinh viên vừa thêm
--------------------------------------------------

-- Thêm điểm
INSERT INTO Score(student_id, subject_id, mid_score, final_score)
VALUES
('3', 'S1', 7.0, 8.0),
('3', 'S2', 6.5, 7.0);

-- Cập nhật điểm cuối kỳ (ví dụ cập nhật S1)
UPDATE Score
SET final_score = 9.0
WHERE student_id = '3' AND subject_id = 'S1';

-------------------------------------
-- 4️⃣ Xóa một lượt đăng ký không hợp lệ
-- (ví dụ xóa đăng ký môn S2 của SV 3)
-------------------------------------
DELETE FROM Enrollment
WHERE student_id = '3' AND subject_id = 'S2';

--------------------------------------------------------
-- 5️⃣ Lấy danh sách sinh viên và điểm số tương ứng
--------------------------------------------------------
SELECT 
    s.student_id,
    s.full_name,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
FROM Score sc
JOIN Student s ON sc.student_id = s.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;
