/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File

-- Câu 1: Trigger kiểm tra điểm (BEFORE INSERT)
DELIMITER $$

CREATE TRIGGER tg_CheckScore
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    IF NEW.Score < 0 THEN
        SET NEW.Score = 0;
    ELSEIF NEW.Score > 10 THEN
        SET NEW.Score = 10;
    END IF;
END$$

DELIMITER ;

-- Câu 2: Transaction thêm sinh viên mới
START TRANSACTION;

INSERT INTO Students (StudentID, FullName)
VALUES ('SV02', 'Ha Bich Ngoc');

UPDATE Students
SET TotalDebt = 5000000
WHERE StudentID = 'SV02';

COMMIT;
-- Câu 3: Trigger ghi log khi cập nhật điểm
DELIMITER $$

CREATE TRIGGER tg_LogGradeUpdate
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score <> NEW.Score THEN
        INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
        VALUES (OLD.StudentID, OLD.Score, NEW.Score, NOW());
    END IF;
END$$

DELIMITER ;


-- Câu 4: Stored Procedure đóng học phí SV01
DELIMITER $$

CREATE PROCEDURE sp_PayTuition()
BEGIN
    DECLARE v_TotalDebt DECIMAL(10,2);

    START TRANSACTION;

    UPDATE Students
    SET TotalDebt = TotalDebt - 2000000
    WHERE StudentID = 'SV01';

    SELECT TotalDebt INTO v_TotalDebt
    FROM Students
    WHERE StudentID = 'SV01';

    IF v_TotalDebt < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- Câu 5: Trigger cấm sửa điểm đã qua môn (>= 4.0)
DELIMITER $$

CREATE TRIGGER tg_PreventPassUpdate
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sinh vien da qua mon, khong duoc phep sua diem';
    END IF;
END$$

DELIMITER ;

-- Câu 6: Stored Procedure xóa điểm môn học an toàn
DELIMITER $$
CREATE PROCEDURE sp_DeleteStudentGrade (
    IN p_StudentID CHAR(5),
    IN p_SubjectID CHAR(5)
)
BEGIN
    DECLARE v_OldScore DECIMAL(4,2);

    START TRANSACTION; 
    
END$$

DELIMITER ;

