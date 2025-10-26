/* Q1: What is the total revenue generated to date? 
Business Impact: Shows overall sales performance and business health.
*/
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE order_status = 'Delivered';

/* Q2: Who are the top 3 customers by total spending? 
Business Impact: Identifies high-value customers for loyalty programs and retention strategies.
*/
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

/* Q3: Which product category generates the highest revenue? 
Business Impact: Helps prioritize marketing, inventory, and promotions for top-performing categories.
*/
SELECT 
    cat.category_name, 
    ROUND(SUM(od.subtotal), 2) AS category_revenue
FROM order_details od
JOIN product p ON od.product_id = p.product_id
JOIN category cat ON p.category_id = cat.category_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY cat.category_name
ORDER BY category_revenue DESC
LIMIT 1;

/* Q4: What are the top 5 selling products by quantity? 
Business Impact: Highlights high-demand SKUs for inventory planning and promotional focus.
*/
SELECT 
    p.product_name, 
    SUM(od.quantity) AS total_units_sold
FROM order_details od
JOIN product p ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;

/* Q5: Which marketing channels generate the most revenue? 
Business Impact: Informs marketing spend allocation for highest ROI.
*/
SELECT 
    c.ad_source AS marketing_channel, 
    ROUND(SUM(o.total_amount), 2) AS channel_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.ad_source
ORDER BY channel_revenue DESC;

/* Q6: Identify products with zero sales to date. 
Business Impact: Flags underperforming products for promotion or discontinuation decisions.
*/
SELECT 
    p.product_id, 
    p.product_name
FROM product p
LEFT JOIN order_details od ON p.product_id = od.product_id
LEFT JOIN orders o ON od.order_id = o.order_id AND o.order_status = 'Delivered'
WHERE od.product_id IS NULL;

/* Q7: What is the repeat purchase rate of customers? 
Business Impact: Measures customer loyalty and effectiveness of retention strategies.
*/
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END) * 100.0
        / COUNT(DISTINCT customer_id), 2
    ) AS repeat_customer_percent
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
) AS customer_orders;

/* Q8: What are the monthly revenue trends? 
Business Impact: Identifies seasonality, peak sales months, and campaign opportunities.
*/
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month, 
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY month
ORDER BY month;

/* Q9: Who is the highest revenue customer in each city? 
Business Impact: Enables hyperlocal marketing and VIP customer targeting.
*/
WITH city_top_customers AS (
    SELECT 
        c.city, 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(o.total_amount) AS total_spent,
        ROW_NUMBER() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS rn
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.city, c.customer_id
)
SELECT city, customer_name, total_spent 
FROM city_top_customers
WHERE rn = 1;

/* Q10: Which products have the highest discount frequency? 
Business Impact: Evaluates pricing strategy and identifies products often discounted.
*/
SELECT 
    p.product_name, 
    COUNT(*) AS discount_count
FROM order_details od
JOIN product p ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE p.discount > 0
AND o.order_status = 'Delivered'
GROUP BY p.product_name
ORDER BY discount_count DESC;

/* Q11: Average order value by marketing channel. 
Business Impact: Understands channel profitability and customer value segmentation.
*/
SELECT 
    c.ad_source AS marketing_channel, 
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.ad_source;

/* Q12: Revenue distribution by customer gender. 
Business Impact: Guides marketing and product strategy based on gender-based preferences.
*/
SELECT 
    c.gender, 
    ROUND(SUM(o.total_amount), 2) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.gender
ORDER BY revenue DESC;

/* 
End of Peppy Business Insights SQL Project.
This dataset is synthetic and demonstrates business analytics skills in a real-world e-commerce context.
*/
