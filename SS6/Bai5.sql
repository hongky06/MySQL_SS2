CREATE DATABASE SS6_VIP;
USE SS6_VIP;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (full_name, city)
VALUES
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'Hải Phòng'),
('Lê Văn Cường', 'Đà Nẵng'),
('Phạm Thị Dung', 'Hà Nội'),
('Hoàng Văn Em', 'TP Hồ Chí Minh');
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, '2024-10-01', 3000000),
(1, '2024-10-03', 4000000),
(1, '2024-10-05', 5000000),

(2, '2024-10-02', 2000000),
(2, '2024-10-04', 2500000),

(3, '2024-10-01', 6000000),
(3, '2024-10-03', 7000000),
(3, '2024-10-06', 3000000),

(4, '2024-10-02', 1500000),

(5, '2024-10-01', 8000000),
(5, '2024-10-04', 4000000),
(5, '2024-10-06', 3000000);

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING 
    COUNT(o.order_id) >= 3
    AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;
