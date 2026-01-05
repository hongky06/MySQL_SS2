
CREATE DATABASE SS6_REPORT;
USE SS6_REPORT;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);


CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price)
VALUES
('iPhone 14', 20000000),
('Samsung Galaxy S23', 18000000),
('Laptop Dell', 25000000),
('Tai nghe Sony', 3000000),
('Chuột Logitech', 1000000),
('Bàn phím Logitech', 1500000);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 3),
(2, 1, 4),
(3, 1, 5),

(4, 2, 6),
(5, 2, 5),

(6, 3, 2),
(7, 3, 3),
(8, 3, 6),

(9, 4, 10),
(10, 4, 5),

(11, 5, 20),

(12, 6, 8),
(13, 6, 5);

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    AVG(p.price) AS avg_price
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_revenue DESC
LIMIT 5;
