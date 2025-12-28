DROP DATABASE IF EXISTS SchoolDB;
CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Class (
    maclass VARCHAR(20) PRIMARY KEY,
    nameclass VARCHAR(50) NOT NULL,
    namhoc INT CHECK (namhoc >= 2000)
);


CREATE TABLE Student (
    mastudent VARCHAR(20) PRIMARY KEY,
    namestudent VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    maclass VARCHAR(20),

    FOREIGN KEY (maclass) REFERENCES Class(maclass)
);


CREATE TABLE MonHoc (
    mamonhoc VARCHAR(20) PRIMARY KEY,
    namemonhoc VARCHAR(50) NOT NULL,
    sotin INT,
    CONSTRAINT chk_sotin CHECK (sotin > 0)
);


CREATE TABLE Teacher (
    magv VARCHAR(20) PRIMARY KEY,
    hoten VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- =========================
-- 6. Gán giảng viên dạy môn (1 GV -> N môn)
-- =========================
ALTER TABLE MonHoc
ADD COLUMN magv VARCHAR(20);

ALTER TABLE MonHoc
ADD CONSTRAINT fk_teacher
FOREIGN KEY (magv) REFERENCES Teacher(magv);

CREATE TABLE DangKy (
    mastudent VARCHAR(20),
    mamonhoc VARCHAR(20),
    ngaydangky DATE,

    PRIMARY KEY (mastudent, mamonhoc),

    FOREIGN KEY (mastudent) REFERENCES Student(mastudent),
    FOREIGN KEY (mamonhoc) REFERENCES MonHoc(mamonhoc)
);


CREATE TABLE Score (
    mastudent VARCHAR(20),
    mamonhoc VARCHAR(20),
    diemqt DECIMAL(4,2),
    diemck DECIMAL(4,2),

    PRIMARY KEY (mastudent, mamonhoc),

    CONSTRAINT chk_diemqt CHECK (diemqt BETWEEN 0 AND 10),
    CONSTRAINT chk_diemck CHECK (diemck BETWEEN 0 AND 10),

    FOREIGN KEY (mastudent) REFERENCES Student(mastudent),
    FOREIGN KEY (mamonhoc) REFERENCES MonHoc(mamonhoc)
);
