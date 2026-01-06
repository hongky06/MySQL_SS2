CREATE DATABASE TMDT;
USE TMDT;


CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);


CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);


INSERT INTO customers (name, email)
VALUES
('Nguyễn Văn A', 'a@gmail.com'),
('Trần Thị B', 'b@gmail.com'),
('Lê Văn C', 'c@gmail.com'),
('Phạm Thị D', 'd@gmail.com'),
('Hoàng Văn E', 'e@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, '2025-01-01', 1500000),
(1, '2025-01-05', 700000),
(2, '2025-01-03', 230000),
(3, '2025-01-04', 980000),
(3, '2025-01-06', 450000),
(3, '2025-01-08', 1200000),
(5, '2025-01-07', 890000);

SELECT 
    name,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.customer_id = customers.id
    ) AS order_count
FROM customers;
