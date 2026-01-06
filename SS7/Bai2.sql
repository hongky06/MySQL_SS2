CREATE DATABASE TMDT;
USE TMDT;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO products (name, price)
VALUES
('iPhone 14', 20000000),
('Samsung S23', 18000000),
('Laptop Dell', 25000000),
('Tai nghe Sony', 3000000),
('Chuột Logitech', 800000),
('Bàn phím cơ', 1500000),
('Màn hình LG', 5000000);


INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(2, 4, 3),
(3, 1, 1),
(3, 5, 2),
(4, 6, 1);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
