-- OLIST E-COMMERCE DATA ANALYSIS
-- Database: olist
-- Author: [Haseeb-u-Rehman]


USE olist;


-- Query 1: Monthly Revenue Trend

SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM olist_orders o 
JOIN olist_order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'  -- Only completed orders
GROUP BY order_year, order_month
ORDER BY order_year DESC, order_month DESC;


-- Query 2: Yearly Revenue Trend

SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM olist_orders o 
JOIN olist_order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_year
ORDER BY order_year DESC;


-- Query 3: Top 5 Customers by Revenue

SELECT 
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_order_value
FROM olist_customers c
JOIN olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;


-- Query 4: Customer Retention / Repeat Purchase Analysis

SELECT 
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS purchase_frequency,
    MIN(o.order_purchase_timestamp) AS first_purchase_date,
    MAX(o.order_purchase_timestamp) AS last_purchase_date
FROM olist_customers c 
JOIN olist_orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
HAVING purchase_frequency > 1  -- Only repeat customers
ORDER BY purchase_frequency DESC
LIMIT 10;


-- Query 5: Customer Churn Analysis

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        DATEDIFF('2018-10-01', MAX(o.order_purchase_timestamp)) AS days_since_last_order
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN days_since_last_order <= 30 THEN 'Active (0-30 days)'
        WHEN days_since_last_order <= 90 THEN 'At Risk (31-90 days)'
        WHEN days_since_last_order <= 180 THEN 'Churning (91-180 days)'
        ELSE 'Churned (180+ days)'
    END AS customer_status,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_orders), 1) AS avg_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM customer_orders
GROUP BY customer_status
ORDER BY 
    CASE customer_status
        WHEN 'Active (0-30 days)' THEN 1
        WHEN 'At Risk (31-90 days)' THEN 2
        WHEN 'Churning (91-180 days)' THEN 3
        ELSE 4
    END;


-- Query 6: Customer Lifetime Value (CLV)

SELECT 
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_spent,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value,
    MIN(o.order_purchase_timestamp) AS first_order_date,
    MAX(o.order_purchase_timestamp) AS last_order_date,
    DATEDIFF(MAX(o.order_purchase_timestamp), MIN(o.order_purchase_timestamp)) AS customer_lifespan_days
FROM olist_customers c
JOIN olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
HAVING total_orders > 1  -- Only repeat customers
ORDER BY total_spent DESC
LIMIT 20;


-- Query 7: Top 10 Product Categories by Revenue

SELECT 
    pct.product_category_name_english AS category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.product_id) AS units_sold,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM olist_order_payments p
JOIN olist_order_items oi ON p.order_id = oi.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
JOIN product_category_name_translation pct ON pr.product_category_name = pct.product_category_name
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 8: Best Selling Products

SELECT 
    oi.product_id,
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id, p.product_category_name
ORDER BY total_revenue DESC
LIMIT 20;



-- Query 9: Seller Rating and Performance

SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(r.review_score), 2) AS avg_rating,
    COUNT(r.review_comment_message) AS total_comments
FROM olist_sellers s 
JOIN olist_order_items oi ON s.seller_id = oi.seller_id
JOIN olist_order_reviews r ON oi.order_id = r.order_id
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING total_orders >= 10  -- Sellers with significant volume
ORDER BY avg_rating DESC, total_revenue DESC
LIMIT 20;



-- Query 10: Delivery Performance by State

SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
        THEN 1 ELSE 0 
    END) * 100, 2) AS late_delivery_pct
FROM olist_orders o 
JOIN olist_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
    AND o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 15;


-- Query 11: Order Status Distribution

SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM olist_orders
WHERE order_status != 'delivered'  -- FIXED: Was using LIKE incorrectly
GROUP BY order_status
ORDER BY order_count DESC;

-- Query 12: Time to Review (Days Between Delivery and Review)

SELECT 
    CASE 
        WHEN DATEDIFF(r.review_answer_timestamp, o.order_delivered_customer_date) <= 1 THEN 'Same Day'
        WHEN DATEDIFF(r.review_answer_timestamp, o.order_delivered_customer_date) <= 7 THEN '2-7 Days'
        WHEN DATEDIFF(r.review_answer_timestamp, o.order_delivered_customer_date) <= 30 THEN '8-30 Days'
        ELSE '30+ Days'
    END AS review_timeframe,
    COUNT(*) AS review_count,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_orders o 
JOIN olist_order_reviews r ON o.order_id = r.order_id
JOIN olist_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
    AND r.review_answer_timestamp IS NOT NULL
GROUP BY review_timeframe
ORDER BY 
    CASE review_timeframe
        WHEN 'Same Day' THEN 1
        WHEN '2-7 Days' THEN 2
        WHEN '8-30 Days' THEN 3
        ELSE 4
    END;


-- Query 13: Payment Method Distribution

SELECT 
    payment_type,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(AVG(payment_value), 2) AS avg_transaction_value
FROM olist_order_payments
GROUP BY payment_type
ORDER BY transaction_count DESC;


-- Query 14: Peak Shopping Hours and Days

SELECT 
    DAYNAME(o.order_purchase_timestamp) AS day_of_week,
    HOUR(o.order_purchase_timestamp) AS hour_of_day,
    COUNT(*) AS order_count,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM olist_orders o
JOIN olist_order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY day_of_week, hour_of_day
ORDER BY order_count DESC
LIMIT 20;

-- Query 15: RFM Analysis (Customer Segmentation)

WITH customer_metrics AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF('2018-10-01', MAX(o.order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(p.payment_value) AS monetary
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT 
        customer_unique_id,
        recency,
        frequency,
        monetary,
        -- FIXED: Lower recency = better (recent buyers) so ORDER BY ASC
        NTILE(5) OVER (ORDER BY recency ASC) AS r_score,
        -- FIXED: Higher frequency = better so ORDER BY DESC
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        -- FIXED: Higher monetary = better so ORDER BY DESC
        NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
    FROM customer_metrics
)
SELECT 
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Promising'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 THEN 'Lost'
        ELSE 'Potential'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_revenue,
    ROUND(AVG(frequency), 1) AS avg_orders,
    ROUND(AVG(recency), 1) AS avg_days_since_purchase
FROM rfm_scores
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- Query 16: Cohort Retention Analysis

WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m') AS cohort_month
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
user_activities AS (
    SELECT 
        fp.customer_unique_id,
        fp.cohort_month,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS activity_month,
        TIMESTAMPDIFF(MONTH, 
            STR_TO_DATE(CONCAT(fp.cohort_month, '-01'), '%Y-%m-%d'),
            o.order_purchase_timestamp) AS month_number
    FROM first_purchase fp
    JOIN olist_customers c ON fp.customer_unique_id = c.customer_unique_id
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN month_number = 0 THEN customer_unique_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN month_number = 1 THEN customer_unique_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN month_number = 2 THEN customer_unique_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN month_number = 3 THEN customer_unique_id END) AS month_3,
    COUNT(DISTINCT CASE WHEN month_number = 6 THEN customer_unique_id END) AS month_6,
    -- Calculate retention rates
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 1 THEN customer_unique_id END) * 100.0 / 
          NULLIF(COUNT(DISTINCT CASE WHEN month_number = 0 THEN customer_unique_id END), 0), 2) AS retention_month_1_pct
FROM user_activities
GROUP BY cohort_month
ORDER BY cohort_month;

-- Query 17: Review Sentiment Impact on Repeat Purchase

WITH customer_reviews AS (
    SELECT 
        c.customer_unique_id,
        AVG(r.review_score) AS avg_review,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN avg_review >= 4.5 THEN 'Excellent (4.5-5)'
        WHEN avg_review >= 4.0 THEN 'Good (4-4.5)'
        WHEN avg_review >= 3.0 THEN 'Average (3-4)'
        ELSE 'Poor (1-3)'
    END AS experience_rating,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_purchase_rate
FROM customer_reviews
GROUP BY experience_rating
ORDER BY 
    CASE experience_rating
        WHEN 'Excellent (4.5-5)' THEN 1
        WHEN 'Good (4-4.5)' THEN 2
        WHEN 'Average (3-4)' THEN 3
        ELSE 4
    END;
