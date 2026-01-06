CREATE DATABASE TMDT;
USE TMDT;

CREATE TABLE khachhang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE dathang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES khachhang(id)
);

INSERT INTO khachhang (name, email)
VALUES
('Nguyễn Văn A', 'a@gmail.com'),
('Trần Thị B', 'b@gmail.com'),
('Lê Văn C', 'c@gmail.com'),
('Phạm Thị D', 'd@gmail.com'),
('Hoàng Văn E', 'e@gmail.com'),
('Đỗ Thị F', 'f@gmail.com'),
('Vũ Văn G', 'g@gmail.com');
INSERT INTO dathang (customer_id, order_date, total_amount)
VALUES
(1, '2025-01-01', 1500000.00),
(2, '2025-01-02', 230000.50),
(3, '2025-01-03', 980000.00),
(1, '2025-01-04', 450000.75),
(4, '2025-01-05', 1200000.00),
(2, '2025-01-06', 670000.00),
(5, '2025-01-07', 890000.25);


select * from khachhang ;


SELECT *
FROM khachhang
-- kiểu tra những khách hàng đã đặt hàng có trong dánh sách khách hàng hay không  
WHERE id IN (
    SELECT customer_id
    FROM dathang
    -- lấy tất cả những khách hàng đã đặt hàng ra ngoài 
);
