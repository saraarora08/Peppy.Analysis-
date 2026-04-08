/* Q1: Total users onboarded
Business Impact: Measures user acquisition and platform growth */
SELECT COUNT(DISTINCT user_id) AS total_users
FROM users;


/* Q2: Monthly onboarding trend
Business Impact: Identifies growth patterns and onboarding performance */
SELECT DATE_FORMAT(signup_date, '%Y-%m') AS month, COUNT(*) AS users_onboarded
FROM users
GROUP BY month
ORDER BY month;


/* Q3: Conversion from signup to active usage
Business Impact: Measures onboarding effectiveness */
SELECT 
  ROUND(100 * COUNT(DISTINCT a.user_id) / COUNT(DISTINCT u.user_id), 2) AS conversion_rate
FROM users u
LEFT JOIN activity a ON u.user_id = a.user_id;


/* Q4: Users with no activity after signup
Business Impact: Identifies onboarding drop-offs */
SELECT COUNT(*) AS dropped_users
FROM users u
LEFT JOIN activity a ON u.user_id = a.user_id
WHERE a.user_id IS NULL;


/* Q5: Most engaged users
Business Impact: Helps identify loyal users */
SELECT user_id, COUNT(*) AS activity_count
FROM activity
GROUP BY user_id
ORDER BY activity_count DESC
LIMIT 5;


/* Q6: Most used features
Business Impact: Helps prioritize product improvements */
SELECT feature_name, COUNT(*) AS usage_count
FROM activity
GROUP BY feature_name
ORDER BY usage_count DESC;


/* Q7: Retention rate
Business Impact: Indicates user satisfaction and repeat engagement */
SELECT 
  ROUND(100 * SUM(CASE WHEN activity_count > 1 THEN 1 ELSE 0 END)/COUNT(*), 2) AS retention_rate
FROM (
  SELECT user_id, COUNT(*) AS activity_count
  FROM activity
  GROUP BY user_id
) sub;


/* Q8: Users who browsed but did not purchase
Business Impact: Identifies hesitation in sensitive product category */
SELECT DISTINCT pv.user_id
FROM product_views pv
LEFT JOIN orders o ON pv.user_id = o.user_id
WHERE o.user_id IS NULL;


/* Q9: Most viewed product categories
Business Impact: Understands user interest and demand */
SELECT category, COUNT(*) AS views
FROM product_views
GROUP BY category
ORDER BY views DESC;


/* Q10: Conversion rate by category
Business Impact: Identifies categories with high/low purchase intent */
SELECT 
  pv.category,
  COUNT(DISTINCT o.user_id) * 100.0 / COUNT(DISTINCT pv.user_id) AS conversion_rate
FROM product_views pv
LEFT JOIN orders o ON pv.user_id = o.user_id
GROUP BY pv.category;


/* Q11: Time to first engagement
Business Impact: Measures onboarding efficiency */
SELECT 
  AVG(DATEDIFF(a.activity_date, u.signup_date)) AS avg_days_to_engage
FROM users u
JOIN activity a ON u.user_id = a.user_id;

/* Q12: Engagement by source/channel
Business Impact: Identifies most effective acquisition channels */
SELECT source, COUNT(*) AS user_count
FROM users
GROUP BY source
ORDER BY user_count DESC;
    

