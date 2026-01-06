
CREATE DATABASE TMDT;
USE TMDT;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);

INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, '2025-01-01', 1500000),
(1, '2025-01-05', 700000),
(2, '2025-01-03', 230000),
(3, '2025-01-04', 980000),
(3, '2025-01-06', 450000),
(3, '2025-01-08', 1200000),
(4, '2025-01-07', 3000000);


SELECT customer_id, SUM(total_amount) AS total_money
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_per_customer)
    FROM (
        SELECT SUM(total_amount) AS total_per_customer
        FROM orders
        GROUP BY customer_id
    ) AS temp
);
