CREATE DATABASE HN_KS24_CNTT5_DOHONGKY ;
USE HN_KS24_CNTT5_DOHONGKY ; 
CREATE TABLE Reader (
	reader_id INT auto_increment primary key , 
    reader_name VARCHAR(100) NOT NULL , 
    phone VARCHAR(15) UNIQUE , 
    register_date DATE DEFAULT (CURRENT_DATE)
);



CREATE TABLE Book (
book_id INT auto_increment  primary key, 
book_title VARCHAR(150) NOT NULL , 
author VARCHAR(100) , 
publish_year INT check (publish_year >= 1900)
);

CREATE TABLE Borrow (
reader_id INT , 
book_id INT , 
borrow_date DATE default(CURRENT_DATE) , 
return_date DATE 
);

-- cau 2,1
alter table Reader add email varchar(100 ) UNIQUE ; 
alter table Book modify author VARCHAR(150) ; 
ALTER TABLE Borrow
ADD CONSTRAINT chk_return
CHECK (return_date IS NULL OR return_date >= borrow_date);


-- cau 3 
INSERT INTO Reader (reader_name, phone, register_date, email)
VALUES
('Nguyễn Văn An', '0901234567', '2024-09-01', 'an.nguyen@gmail.com'),
('Trần Thị Bình', '0912345678', '2024-09-05', 'binh.tran@gmail.com'),
('Lê Minh Châu', '0923456789', '2024-09-10', 'chau.le@gmail.com');

INSERT INTO Book (book_id, book_title, author, publish_year)
VALUES 
(101, 'Lập trình C căn bản', 'Nguyễn Văn A', 2018),
(102, 'Cơ sở dữ liệu', 'Trần Thị B', 2020),
(103, 'Lập trình Java', 'Lê Minh C', 2019),
(104, 'Hệ quản trị MySQL', 'Phạm Văn D', 2021);


INSERT INTO Borrow (reader_id, book_id, borrow_date, return_date)
VALUES
(1, 101, '2024-09-15', NULL),
(1, 102, '2024-09-15', '2024-09-25'),
(2, 103, '2024-09-18', NULL);

 
 
UPDATE Borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1;

UPDATE Book
SET publish_year = 2023
WHERE publish_year >= 2021;


DELETE FROM Borrow
WHERE borrow_date < '2024-09-18';


 
SELECT * FROM Reader;
SELECT * FROM Book;
SELECT * FROM Borrow;
