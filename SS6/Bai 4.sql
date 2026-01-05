CREATE DATABASE SS6_PRODUCTS;
USE SS6_PRODUCTS;

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
('Chuột Logitech', 1000000);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 1),
(1, 4, 2),
(2, 2, 1),
(2, 5, 3),
(3, 3, 1),
(3, 4, 1),
(4, 1, 2),
(5, 2, 2);


SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;


SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;


SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;
