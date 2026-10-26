CREATE DATABASE IF NOT EXISTS OnlineShoppingCart;
USE OnlineShoppingCart;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(200)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Cart_Items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    UNIQUE (cart_id, product_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    order_status VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

INSERT INTO Customers
(customer_name, email, phone, address)
VALUES
('Arun Kumar', 'arun@gmail.com', '9876543210', 'Chennai'),
('Priya Sharma', 'priya@gmail.com', '9876501234', 'Coimbatore'),
('Rahul Raj', 'rahul@gmail.com', '9876512345', 'Salem');

INSERT INTO Products
(product_name, category, price, stock)
VALUES
('Laptop', 'Electronics', 55000.00, 10),
('Headphones', 'Electronics', 1500.00, 25),
('Keyboard', 'Accessories', 800.00, 30),
('Mouse', 'Accessories', 500.00, 40),
('Smartphone', 'Electronics', 25000.00, 15);

INSERT INTO Cart (customer_id)
VALUES (1);

INSERT INTO Cart_Items
(cart_id, product_id, quantity)
VALUES
(1, 1, 1),
(1, 2, 2),
(1, 4, 1);

-- Display all products
SELECT * FROM Products;

-- Search for a product
SELECT *
FROM Products
WHERE product_name LIKE '%Laptop%';

-- Display cart items and subtotals
SELECT
    p.product_name,
    p.price,
    ci.quantity,
    p.price * ci.quantity AS subtotal
FROM Cart_Items ci
JOIN Products p ON ci.product_id = p.product_id
WHERE ci.cart_id = 1;

-- Calculate shopping cart total
SELECT
    c.cart_id,
    SUM(p.price * ci.quantity) AS total_amount
FROM Cart c
JOIN Cart_Items ci ON c.cart_id = ci.cart_id
JOIN Products p ON ci.product_id = p.product_id
WHERE c.cart_id = 1
GROUP BY c.cart_id;

-- Display customers and their carts
SELECT
    c.customer_name,
    ca.cart_id,
    ca.created_at
FROM Customers c
JOIN Cart ca ON c.customer_id = ca.customer_id;

-- Update product price
UPDATE Products
SET price = 52000.00
WHERE product_name = 'Laptop';

-- Display all orders
SELECT * FROM Orders;
