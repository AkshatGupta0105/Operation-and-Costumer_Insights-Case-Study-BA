-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    signup_date DATE
);

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category VARCHAR(50),
    product_name VARCHAR(100),
    price NUMERIC(10,2) CHECK (price >= 0)
);

-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date TIMESTAMP,
    quantity INT CHECK (quantity > 0),
    status VARCHAR(20) CHECK (status IN ('Delivered', 'Cancelled')),
    unit_price NUMERIC(10,2),
    order_amount NUMERIC(12,2)
);

-- Deliveries Table
CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    rider_id INT,
    time_taken INT, -- in minutes
    promised_minutes INT,
    was_late BOOLEAN
);


select * from deliveries
COPY public.deliveries(delivery_id, order_id, rider_id, time_taken, promised_minutes, was_late)
FROM 'D:/akshat folder/PROJECTS/zepto sql/deliveries.csv'
DELIMITER ',';

COPY public.orders(order_id, customer_id, product_id, order_date, quantity, status, unit_price, order_amount)
FROM 'D:/akshat folder/PROJECTS/zepto sql/orders.csv'
DELIMITER ',' 
;

select * from products
-- Customers
COPY public.customers(customer_id, name, city, signup_date)
FROM 'D:/akshat folder/PROJECTS/zepto sql/customers.csv'
DELIMITER ',' CSV HEADER;

-- Orders
COPY public.orders(order_id, customer_id, product_id, order_date, quantity, status, unit_price, order_amount)
FROM 'D:/akshat folder/PROJECTS/zepto sql/orders.csv'
DELIMITER ',' CSV HEADER;

-- Products
COPY public.products(product_id, product_name, category, price)
FROM 'D:/akshat folder/PROJECTS/zepto sql/products.csv'
DELIMITER ',' CSV HEADER;

-- Deliveries
COPY public.deliveries(delivery_id, order_id, rider_id, time_taken, promised_minutes, was_late)
FROM 'D:/akshat folder/PROJECTS/zepto sql/deliveries.csv'
DELIMITER ',' CSV HEADER;


select * from products

------Queries--------


--1)Repeat vs one time
SELECT 
    COUNT(DISTINCT customer_id) FILTER (WHERE order_count = 1) AS one_time_customers,
    COUNT(DISTINCT customer_id) FILTER (WHERE order_count > 1) AS repeat_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) t;


--2)Top 5 product by selling revenue
SELECT 
    p.product_name,
    SUM(o.quantity * o.cost) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;


--3)Revenue by city
SELECT 
    c.city,
    SUM(o.cost) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;


--4) Month-over-Month AOV Trend
WITH monthly_aov AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        ROUND(SUM(o.total_amount) * 1.0 / COUNT(o.order_id), 2) AS avg_order_value
    FROM orders o
    GROUP BY DATE_TRUNC('month', o.order_date)
    ORDER BY month
)
SELECT 
    month,
    avg_order_value,
    LAG(avg_order_value) OVER (ORDER BY month) AS prev_month_aov,
    ROUND(
        ((avg_order_value - LAG(avg_order_value) OVER (ORDER BY month)) 
        / NULLIF(LAG(avg_order_value) OVER (ORDER BY month),0)) * 100, 2
    ) AS mom_change_percentage
FROM monthly_aov;



--5)Costumer Retension vs Churn
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Low-frequency'
        ELSE 'Loyal'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers)),2) AS percentage
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) sub
GROUP BY customer_segment;

select * from orders

ALTER TABLE orders
RENAME COLUMN unit_price TO cost;

--6) Profitablity with categories
SELECT p.category,
       SUM(o.total_amount) AS revenue,
       SUM(o.total_amount - o.cost) AS profit,
       ROUND((SUM(o.total_amount - o.cost)::DECIMAL / SUM(o.total_amount))*100,2) AS margin_percentage
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;



--7) Refunds and Complaints

SELECT p.category,
       SUM(o.total_amount) AS revenue,
       SUM(o.total_amount - o.cost) AS profit,
       ROUND((SUM(o.total_amount - o.cost)::DECIMAL / SUM(o.total_amount))*100,2) AS margin_percentage
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;


--8) Rider Efficiency vs Delivery

SELECT d.rider_id,
       COUNT(d.delivery_id) AS total_deliveries,
       SUM(CASE WHEN d.was_late = TRUE THEN 1 ELSE 0 END) AS late_deliveries,
       ROUND((SUM(CASE WHEN d.was_late = TRUE THEN 1 ELSE 0 END)::DECIMAL / COUNT(d.delivery_id))*100,2) AS late_percentage
FROM deliveries d
GROUP BY d.rider_id
ORDER BY late_percentage DESC
LIMIT 10;


--9) Geographic Heat Map

WITH cte AS
(SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_revenue,
RANK() OVER(ORDER BY SUM(o.total_amount)) AS lowrank,
RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS toprank
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC)
SELECT * from cte 
where toprank <= 10 or lowrank <=10;


--10) Late delivery impact

WITH late_orders AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE d.was_late = TRUE
),
repeat_customers AS (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
)
SELECT 
    (SELECT COUNT(*) FROM repeat_customers WHERE customer_id IN (SELECT customer_id FROM late_orders)) AS late_and_repeat,
    (SELECT COUNT(*) FROM late_orders) AS total_late_customers,
    ROUND(( (SELECT COUNT(*) FROM repeat_customers WHERE customer_id IN (SELECT customer_id FROM late_orders))::DECIMAL 
           / (SELECT COUNT(*) FROM late_orders) )*100,2) AS retention_after_late;

