
DROP DATABASE IF EXISTS SchoolDB;
CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Student (
    mastudent VARCHAR(20) PRIMARY KEY,
    namestudent VARCHAR(50) NOT NULL
);

CREATE TABLE MonHoc (
    mamonhoc VARCHAR(20) PRIMARY KEY,
    namemonhoc VARCHAR(50) NOT NULL,
    sotin INT,
    CONSTRAINT chk_sotin CHECK (sotin > 0)
);

CREATE TABLE DangKy (
    mastudent VARCHAR(20),
    mamonhoc VARCHAR(20),
    ngaydangky DATE,

    -- KHÔNG ĐƯỢC ĐĂNG KÝ TRÙNG
    PRIMARY KEY (mastudent, mamonhoc),

    FOREIGN KEY (mastudent) REFERENCES Student(mastudent),
    FOREIGN KEY (mamonhoc) REFERENCES MonHoc(mamonhoc)
);


CREATE TABLE Teacher (
    magv VARCHAR(20) PRIMARY KEY,
    hoten VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);


ALTER TABLE MonHoc
ADD COLUMN magv VARCHAR(20);

ALTER TABLE MonHoc
ADD CONSTRAINT fk_teacher
FOREIGN KEY (magv) REFERENCES Teacher(magv);
