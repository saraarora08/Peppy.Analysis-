/* Q1: What is the total revenue generated? 
Business Impact: Measures overall financial performance and business growth. */
SELECT SUM(total_amt) AS total_revenue
FROM orders;


/* Q2: Who are the top 5 customers by total spending? 
Business Impact: Identifies key customers for retention and loyalty strategies. */
SELECT customer_id, SUM(total_amt) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 5;


/* Q3: Which product categories generate the most revenue? 
Business Impact: Guides marketing and inventory investment decisions. */
SELECT category_id, SUM(item_total) AS category_revenue
FROM order_items
JOIN products USING(product_id)
GROUP BY category_id
ORDER BY category_revenue DESC;


/* Q4: What are the top 5 bestselling products? 
Business Impact: Helps prioritize stock management and promotional focus. */
SELECT product_id, SUM(quantity) AS total_units_sold
FROM order_items
GROUP BY product_id
ORDER BY total_units_sold DESC
LIMIT 5;


/* Q5: Which cities contribute the most revenue? 
Business Impact: Reveals high-performing regions for targeted campaigns. */
SELECT c.city, SUM(o.total_amt) AS city_revenue
FROM orders o
JOIN customers c USING(customer_id)
GROUP BY c.city
ORDER BY city_revenue DESC
LIMIT 5;


/* Q6: What is the repeat purchase rate among customers? 
Business Impact: Indicates customer satisfaction and brand loyalty. */
SELECT 
  ROUND(100 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)/COUNT(*), 2) AS repeat_customer_rate
FROM (
  SELECT customer_id, COUNT(order_id) AS order_count
  FROM orders
  GROUP BY customer_id
) AS sub;


/* Q7: How do monthly sales trends look? 
Business Impact: Identifies seasonality and growth opportunities. */
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amt) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;


/* Q8: What is the revenue split by gender-targeted products? 
Business Impact: Informs product design and marketing segmentation. */
SELECT gender_target, SUM(item_total) AS total_revenue
FROM order_items
JOIN products USING(product_id)
GROUP BY gender_target
ORDER BY total_revenue DESC;


/* Q9: Which sales channels drive the highest revenue? 
Business Impact: Optimizes marketing spend and sales strategy. */
SELECT order_channel, SUM(total_amt) AS channel_revenue
FROM orders
GROUP BY order_channel
ORDER BY channel_revenue DESC;


/* Q10: Which products are frequently bought together? 
Business Impact: Supports bundle creation and cross-sell strategies. */
SELECT oi1.product_id AS product_1, oi2.product_id AS product_2, COUNT(*) AS pair_count
FROM order_items oi1
JOIN order_items oi2 
  ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
GROUP BY product_1, product_2
ORDER BY pair_count DESC
LIMIT 5;
