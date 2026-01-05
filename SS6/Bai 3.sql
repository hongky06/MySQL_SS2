-- Tạo database
CREATE DATABASE SS6_REVENUE;
USE SS6_REVENUE;

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    total_amount DECIMAL(10,2)
);

-- Thêm dữ liệu mẫu
INSERT INTO orders (order_date, status, total_amount)
VALUES
('2024-10-01', 'completed', 5000000),
('2024-10-01', 'completed', 7000000),
('2024-10-01', 'pending',   3000000),
('2024-10-02', 'completed', 4000000),
('2024-10-02', 'completed', 8000000),
('2024-10-03', 'completed', 2000000),
('2024-10-03', 'cancelled', 6000000),
('2024-10-04', 'completed', 12000000);

-- 1. Tính tổng doanh thu theo từng ngày
SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

-- 2. Tính số lượng đơn hàng theo từng ngày
SELECT
    order_date,
    COUNT(order_id) AS total_orders
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

-- 3. Chỉ hiển thị các ngày có doanh thu > 10.000.000
SELECT
    order_date,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;
