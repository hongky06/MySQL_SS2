/* =====================
   TẠO DATABASE
===================== */
CREATE DATABASE HN_KS24_CSDL_SS12_CNTT5_DOHONGKY;
USE HN_KS24_CSDL_SS12_CNTT5_DOHONGKY;


CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

/* =====================
   DỮ LIỆU MẪU
===================== */
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00002','C00001',6.5),
('S00005','C00001',9.0),
('S00008','C00001',5.5);

-- Câu 1: Tạo View sinh viên cơ bản
CREATE VIEW View_StudentBasic AS
SELECT Student.StudentID,
       Student.FullName,
       Department.DeptName
FROM Student, Department
WHERE Student.DeptID = Department.DeptID;

-- Xem dữ liệu View
SELECT * FROM View_StudentBasic;

-- Câu 2: Tạo Index cho cột FullName
CREATE INDEX idx_FullName
ON Student(FullName);

-- Câu 3: Thủ tục lấy sinh viên khoa IT
DELIMITER $$

CREATE PROCEDURE GetStudentsIT()
BEGIN
    SELECT Student.StudentID,
           Student.FullName,
           Department.DeptName
    FROM Student, Department
    WHERE Student.DeptID = Department.DeptID
      AND Department.DeptName = 'Information Technology';
END$$

DELIMITER ;

CALL GetStudentsIT();

-- Câu 4a: View đếm số sinh viên mỗi khoa
CREATE VIEW View_StudentCountByDept AS
SELECT Department.DeptName,
       COUNT(Student.StudentID) AS TotalStudents
FROM Department
LEFT JOIN Student ON Department.DeptID = Student.DeptID
GROUP BY Department.DeptName;

-- Câu 4b: Khoa có nhiều sinh viên nhất
SELECT *
FROM View_StudentCountByDept
ORDER BY TotalStudents DESC
LIMIT 1;

-- Câu 5a: Thủ tục sinh viên điểm cao nhất theo môn
DELIMITER $$

CREATE PROCEDURE GetTopScoreStudent(IN p_CourseID CHAR(6))
BEGIN
    SELECT Student.StudentID,
           Student.FullName,
           Enrollment.Score
    FROM Student, Enrollment
    WHERE Student.StudentID = Enrollment.StudentID
      AND Enrollment.CourseID = p_CourseID
      AND Enrollment.Score = (
          SELECT MAX(Score)
          FROM Enrollment
          WHERE CourseID = p_CourseID
      );
END$$

DELIMITER ;

-- Câu 5b: Gọi thủ tục
CALL GetTopScoreStudent('C00001');


-- Bài 6a: View sinh viên IT học Database
CREATE VIEW View_IT_Enrollment_DB AS
SELECT Enrollment.StudentID,
       Enrollment.CourseID,
       Enrollment.Score
FROM Enrollment, Student
WHERE Enrollment.StudentID = Student.StudentID
  AND Student.DeptID = 'IT'
  AND Enrollment.CourseID = 'C00001'
WITH CHECK OPTION;

-- Bài 6b: Thủ tục cập nhật điểm
DELIMITER $$

CREATE PROCEDURE UpdateScore_IT_DB(
    IN p_StudentID CHAR(6),
    INOUT p_NewScore FLOAT
)
BEGIN
    IF p_NewScore > 10 THEN
        SET p_NewScore = 10;
    END IF;

    UPDATE View_IT_Enrollment_DB
    SET Score = p_NewScore
    WHERE StudentID = p_StudentID;
END$$

DELIMITER ;

-- Bài 6c: Gọi thủ tục
SET @newScore = 12;

CALL UpdateScore_IT_DB('S00001', @newScore);

SELECT @newScore AS DiemSauCapNhat;

SELECT * FROM View_IT_Enrollment_DB;
