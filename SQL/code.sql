CREATE DATABASE ECOM;

USE ECOM;

-- IMPORT CUSTOMERS TABLE VIA IMPORT WIZARD

-- IMPORT ORDERS TABLE VIA IMPORT WIZARD

-- IMPORT PRODUCTS TABLE VIA IMPORT WIZARD

-- IMPORT REVIEWS TABLE VIA IMPORT WIZARD

ALTER TABLE customers
ADD COLUMN new_date DATE,
DROP PRIMARY KEY,
MODIFY id CHAR(8) PRIMARY KEY,
MODIFY first_name VARCHAR(50) NOT NULL,
MODIFY last_name VARCHAR(50) NOT NULL,
MODIFY gender VARCHAR(10) NOT NULL,
MODIFY age_group VARCHAR(15) NOT NULL,
MODIFY country VARCHAR(25) NOT NULL;

UPDATE customers
SET new_date = STR_TO_DATE(signup_date, '%d/%m/%Y');

ALTER TABLE customers
DROP COLUMN signup_date,
CHANGE new_date signup_date DATE;

-- NEW DATE COLUMN ADDED TO CONVERT TEXT STRING TO DATE FORMAT

ALTER TABLE products
DROP PRIMARY KEY,
MODIFY id CHAR(7) PRIMARY KEY,
MODIFY product_name VARCHAR(100) NOT NULL,
MODIFY category VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD COLUMN new_date DATE,
DROP PRIMARY KEY,
MODIFY id CHAR(8) PRIMARY KEY,
MODIFY quantity INT UNSIGNED NOT NULL,
ADD CONSTRAINT chk_qty CHECK (quantity > 0),
MODIFY unit_price DECIMAL (10,2) NOT NULL,
ADD CONSTRAINT chk_price CHECK (unit_price >= 0),
MODIFY order_status VARCHAR(20) NOT NULL,
MODIFY payment_method VARCHAR(50) NOT NULL,
MODIFY product_id CHAR(7),
MODIFY customer_id CHAR(8),
MODIFY review_id CHAR(8);

UPDATE orders
SET new_date = STR_TO_DATE(order_date, '%d/%m/%Y');

ALTER TABLE orders
DROP COLUMN order_date,
CHANGE new_date order_date DATE;


-- NEW DATE COLUMN ADDED TO CONVERT TEXT STRING TO DATE FORMAT

ALTER TABLE reviews
DROP PRIMARY KEY,
MODIFY id CHAR(8) PRIMARY KEY,
MODIFY rating TINYINT UNSIGNED NOT NULL,
ADD CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
MODIFY review_text VARCHAR(20) NOT NULL,
MODIFY order_id CHAR(8) NOT NULL,
ADD UNIQUE KEY uq_reviews_order (order_id),
MODIFY product_id CHAR(7),
MODIFY customer_id CHAR(8);

-- REVIEW TEXTS ARE INCONSISTANT AND NEED TO BE CLEANED TO ALLOW FOR ACCURATE REPORTING

UPDATE reviews 
SET review_text = 'very bad'
WHERE rating = 1;

UPDATE reviews
SET review_text = 'bad'
WHERE rating = 2;

UPDATE reviews
SET review_text = 'average'
WHERE rating = 3;

UPDATE reviews
SET review_text = 'good'
WHERE rating = 4;

UPDATE reviews
SET review_text = 'very good'
WHERE rating = 5;

-- FOREIGN KEYS ADDED TO SCHEMA

ALTER TABLE orders
ADD CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES products(id),
ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
ADD CONSTRAINT fk_orders_review FOREIGN KEY (review_id) REFERENCES reviews(id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products(id),
ADD CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
ADD CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES orders(id);


-- 1. DAILY SALES FIGURES

CREATE or REPLACE VIEW daily_sales AS
SELECT order_date,
       COUNT(*) AS orders,
       SUM(quantity*unit_price) AS total_revenue
FROM orders
WHERE order_status IN ('Delivered', 'Shipped', 'Pending')
GROUP BY order_date WITH ROLLUP
ORDER BY order_date;

-- 2. TOP CUSTOMERS BY TOTAL REVENUE

CREATE or REPLACE VIEW top_customers AS
SELECT customers.id, 
	   first_name, 
	   last_name, 
	   COUNT(orders.id) AS total_orders, 
	   SUM(quantity*unit_price) AS revenue
FROM customers
JOIN orders ON orders.customer_id = customers.id
GROUP BY customers.id
ORDER BY revenue DESC
LIMIT 200;

SELECT * FROM top_customers;

-- 3. LOWEST RATED PRODUCTS

CREATE or REPLACE VIEW low_rated_products AS
SELECT product_name, 
	   AVG(rating) AS avg_rating
FROM reviews
JOIN products on products.id = reviews.product_id
GROUP BY product_id
HAVING avg_rating < 3
ORDER BY avg_rating DESC;

-- 4. BULK ORDERS

CREATE or REPLACE VIEW bulk_orders AS
SELECT id, 
	   quantity,
CASE
	WHEN quantity = 1 THEN 'Single'
	WHEN quantity = 2 THEN 'Multi'
	ELSE 'Bulk'
END AS order_type
FROM orders;

-- 5. AVERAGE REVENUE PER ORDER BY PAYMENT METHOD

CREATE or REPLACE VIEW avg_rev_per_order AS
SELECT id, 
	   quantity,
       unit_price,
       (quantity*unit_price) AS revenue,
       AVG(quantity*unit_price) OVER(PARTITION BY payment_method) AS avg_revenue, 
       payment_method
FROM orders;

-- 6. PRODUCTS RANKED BY TOTAL REVENUE

CREATE or REPLACE VIEW product_revenue AS
SELECT 
	   DENSE_RANK() OVER(ORDER BY SUM(quantity*unit_price)DESC) AS product_rank,
       products.id,
	   product_name, 
	   SUM(quantity*unit_price) AS total_revenue
FROM products
JOIN orders ON orders.product_id = products.id
GROUP BY products.id, products.product_name;

-- 7. CUSTOMERS DIVIDED INTO TIERS BASED ON REVENUE GENERATED

CREATE OR REPLACE VIEW customer_tiers AS
SELECT customer_id, 
	   first_name, 
       last_name, 
       COUNT(*) AS total_orders, 
       SUM(quantity*unit_price) AS total_revenue, 
	   NTILE(10) OVER(ORDER BY SUM(quantity*unit_price) DESC) AS revenue_tier
FROM orders
JOIN customers ON customers.id = orders.customer_id
GROUP BY customer_id, first_name, last_name;
 
 -- 8. ENSURING CUSTOMER DATA INTEGRITY USING TRIGGERS
 
 DELIMITER $$
 
 CREATE TRIGGER valid_customer_data
	BEFORE INSERT ON customers FOR EACH ROW
    BEGIN
		IF NEW.first_name IS NULL OR NEW.first_name = ''
        THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'PLEASE ENTER YOUR FIRST NAME';
END IF;
END $$

DELIMITER ;
        
-- END
