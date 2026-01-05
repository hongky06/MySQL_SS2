CREATE DATABASE SS6_1 ; 
use SS6_1 ; 

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    -- chỉ cho phép giá trị cố định là 1 trong 3 , nếu trùng thì sẽ k thêm được 

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (full_name, city)
VALUES
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'Hải Phòng'),
('Lê Văn Cường', 'Đà Nẵng'),
('Phạm Thị Dung', 'Hà Nội'),
('Hoàng Văn Em', 'TP Hồ Chí Minh');


INSERT INTO orders (customer_id, order_date, status)
VALUES
(1, '2024-10-01', 'pending'),
(1, '2024-10-03', 'completed'),
(2, '2024-10-02', 'completed'),
(3, '2024-10-04', 'cancelled'),
(4, '2024-10-05', 'pending');


-- hiển thị danh sách đơn hàng kèm tên khách hàng
SELECT 
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM orders o

JOIN customers c ON o.customer_id = c.customer_id;


-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng 

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;


-- hiển thị những khách hàng có ít nhất 1 đơn hàng 
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;
