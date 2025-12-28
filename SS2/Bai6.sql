CREATE TABLE Score (
    mastudent VARCHAR(20),
    mamonhoc VARCHAR(20),
    diemqt DECIMAL(4,2),
    diemck DECIMAL(4,2),

    -- Không được nhập trùng kết quả của 1 sinh viên trên 1 môn
    PRIMARY KEY (mastudent, mamonhoc),

    -- Ràng buộc điểm 0 - 10
    CONSTRAINT chk_diemqt CHECK (diemqt BETWEEN 0 AND 10),
    CONSTRAINT chk_diemck CHECK (diemck BETWEEN 0 AND 10),

    -- Khóa ngoại
    FOREIGN KEY (mastudent) REFERENCES Student(mastudent),
    FOREIGN KEY (mamonhoc) REFERENCES MonHoc(mamonhoc)
);
