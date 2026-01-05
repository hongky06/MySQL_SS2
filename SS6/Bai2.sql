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
    total_amount DECIMAL(10,2) , 
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






UPDATE orders
SET total_amount = 1500000.00
WHERE order_id = 1;

UPDATE orders
SET total_amount = 2300000.00
WHERE order_id = 2;

UPDATE orders
SET total_amount = 1200000.00
WHERE order_id = 3;

UPDATE orders
SET total_amount = 800000.00
WHERE order_id = 4;

UPDATE orders
SET total_amount = 950000.00
WHERE order_id = 5;


Select 
c. customer_id , 
c.full_name, 
c.city , 
SUM(o. total_amount) AS total_spent 
FROM customers c 
JOIN orders o ON c.customer_id = o. customer_id 
GROUP BY c.customer_id, c.full_name;


-- hiển thị khách hàng chi tiêu cao nhất 

SELECT
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 1;

-- sắp xếp tổng tiền giảm dần 
Select  
c. customer_id , 
c.full_name , 
sum(o. total_amount) AS danhsach 

FROM customer c 
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;



 




