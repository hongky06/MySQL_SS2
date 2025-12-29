-- Tạo database và sử dụng
CREATE DATABASE SchoolDB;
USE SchoolDB;

-- Bảng Student
CREATE TABLE Student (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(50)
);

INSERT INTO Student VALUES
('1', 'Nguyen Van A'),
('2', 'Tran Thi B');

-- Bảng Subject
CREATE TABLE Subject (
    subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(50)
);

INSERT INTO Subject VALUES
('S1', 'Toan'),
('S2', 'Lap trinh'),
('S3', 'Co so du lieu');

-- Bảng Enrollment (đăng ký môn học)
CREATE TABLE Enrollment (
    student_id VARCHAR(20),
    subject_id VARCHAR(20),
    enroll_date DATE,

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),

    -- Không cho 1 sinh viên đăng ký trùng 1 môn
    UNIQUE (student_id, subject_id)
);

-- Thêm dữ liệu đăng ký
INSERT INTO Enrollment(student_id, subject_id, enroll_date)
VALUES
('1', 'S1', '2025-01-01'),
('1', 'S2', '2025-01-02'),
('2', 'S1', '2025-01-03');

-- Xem tất cả lượt đăng ký
SELECT * FROM Enrollment;

-- Xem đăng ký của sinh viên cụ thể
SELECT * FROM Enrollment WHERE student_id = '1';
