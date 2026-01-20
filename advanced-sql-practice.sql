

USE online_store;


SELECT * FROM customers;
SELECT * FROM orders;


-- Task 1: Join query (orders + customer names)
SELECT
    o.id AS order_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount
FROM orders o
         INNER JOIN customers c
                    ON o.customer_id = c.id
ORDER BY o.id;

-- Task 2: Left join query (includes guest orders)
SELECT
    o.id AS order_id,
    o.customer_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount
FROM orders o
         LEFT JOIN customers c
                   ON o.customer_id = c.id
ORDER BY o.id;


-- Task 3: Group by query (total spent per customer)
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
         INNER JOIN orders o
                    ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC;


-- Task 4: Count orders per customer (includes 0-order customers)
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.id) AS order_count
FROM customers c
         LEFT JOIN orders o
                   ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC, c.last_name ASC, c.first_name ASC;


-- Task 5A: WHERE example (only include orders > 200, then sum per customer)
SELECT
    o.customer_id,
    SUM(o.total_amount) AS total_spent_over_200_orders
FROM orders o
WHERE o.total_amount > 200
GROUP BY o.customer_id
ORDER BY total_spent_over_200_orders DESC;

-- Task 5B: HAVING example (only customers whose total spending > 200)
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
         INNER JOIN orders o
                    ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 200
ORDER BY total_spent DESC;


-- Task 6: Scalar subquery (above-average orders)
SELECT
    id AS order_id,
    customer_id,
    order_date,
    total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC, order_id ASC;


-- Task 7: Column subquery (orders for Smith customers)
SELECT
    id AS order_id,
    customer_id,
    order_date,
    total_amount
FROM orders
WHERE customer_id IN (
    SELECT id
    FROM customers
    WHERE last_name = 'Smith'
)
ORDER BY order_id;


-- Task 8: Customers without any orders
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name
FROM customers c
         LEFT JOIN orders o
                   ON c.id = o.customer_id
WHERE o.id IS NULL
ORDER BY c.id;


-- Task 9: Revenue per date
SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY order_date
ORDER BY order_date ASC;


-- Task 10: Customers with at least 2 orders
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.id) AS order_count
FROM customers c
         INNER JOIN orders o
                    ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
HAVING COUNT(o.id) >= 2
ORDER BY order_count DESC, c.id ASC;