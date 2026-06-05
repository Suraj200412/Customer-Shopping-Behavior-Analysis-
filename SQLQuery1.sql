
USE data_analysis_project

SELECT * FROM customer_behaviour_analysis

SELECT
category,
    ROUND(SUM(purchase_amount),2) AS highest_revenue
FROM customer_behaviour_analysis
GROUP BY category
ORDER BY highest_revenue DESC


SELECT * FROM customer_behaviour_analysis

SELECT
    discount_applied,
    ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customer_behaviour_analysis
GROUP BY discount_applied


SELECT * FROM customer_behaviour_analysis

SELECT
    gender,
    ROUND(SUM(purchase_amount),2) AS highest_revenue
FROM customer_behaviour_analysis
GROUP BY gender
ORDER BY highest_revenue DESC


SELECT * FROM customer_behaviour_analysis

-- Which customer used a discount but still spent more then the average purchase amount?
SELECT * FROM customer_behaviour_analysis

SELECT TOP 10
    customer_id,
    purchase_amount,
    discount_applied
FROM customer_behaviour_analysis
WHERE discount_applied= 'Yes' AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer_behaviour_analysis)

--which are the top/bottem 5 prodect with the highest average review rating
SELECT * FROM customer_behaviour_analysis

SELECT TOP 5
    item_purchased,
    ROUND(AVG(review_rating),2) AS Avg_ratings
    FROM customer_behaviour_analysis
    GROUP BY item_purchased
    ORDER BY Avg_ratings DESC

SELECT TOP 5
    item_purchased,
    ROUND(AVG(review_rating),2) AS Avg_ratings
    FROM customer_behaviour_analysis
    GROUP BY item_purchased
    ORDER BY Avg_ratings ASC


-- Average purchase: standrad vs Express shipping
SELECT * FROM customer_behaviour_analysis

SELECT
    shipping_type,
    COUNT(DISTINCT customer_id) as order_placed,
    ROUND(AVG(purchase_amount),2) as avg_purchase,
    ROUND(SUM(purchase_amount),2) AS revenue
FROM customer_behaviour_analysis
--WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type
ORDER BY revenue DESC


-- Do suscribed customer spand more ?  compair averagge speed and total revenue between suscribers and non suscribers.
SELECT * FROM customer_behaviour_analysis

SELECT 
    subscription_status,
    COUNT(customer_id) as users,
    ROUND(AVG(purchase_amount),2) as avg_revenue,
    ROUND(SUM(purchase_amount),2) as total_revenue
FROM customer_behaviour_analysis
GROUP BY subscription_status


-- Top 5 product with highest discount using %
SELECT * FROM customer_behaviour_analysis

SELECT Top 5
    item_purchased,
    COUNT(item_purchased) AS total_number_of_times_sold,
    COUNT(CASE WHEN discount_applied='Yes' THEN 1 END) AS Number_of_times_sold_when_discount_applied,
    COUNT(CASE WHEN discount_applied='Yes' THEN 1 END) *100.0 / COUNT(*) AS discount_percent
FROM customer_behaviour_analysis
GROUP BY item_purchased
ORDER BY discount_percent DESC


--Segment customer into new, returnung and loyal based on theair total number of previous purchase,
--and show the count of each segment.
SELECT * FROM customer_behaviour_analysis

SELECT
    CASE
        WHEN previous_purchases= '0' THEN 'New Customer'
        WHEN previous_purchases BETWEEN 1 AND 15 THEN 'Returning Customer'
    ELSE 'Loyal Customers'
END AS customer_segment,
COUNT (*) AS customer_count
FROM customer_behaviour_analysis
GROUP BY CASE
        WHEN previous_purchases= '0' THEN 'New Customer'
        WHEN previous_purchases BETWEEN 1 AND 15 THEN 'Returning Customer'
    ELSE 'Loyal Customers'
END


--What are the top 3 most purchased products within each category?
SELECT * FROM customer_behaviour_analysis

WITH CTE AS
(
SELECT
    category,
    item_purchased,
    COUNT(item_purchased) AS most_purchased,
    RANK() OVER(PARTITION BY category ORDER BY COUNT(item_purchased) DESC) AS RNK
FROM customer_behaviour_analysis
GROUP BY category,item_purchased
)
SELECT * FROM CTE
WHERE RNK <=3


--are customers who are repeat buyers (more then previous purchased) also likely to subscribe?

SELECT
    CASE
        WHEN previous_purchases > 5 THEN 'Repeat Buyers'
        ELSE 'Normal Buyers'
    END AS customer_type,
    subscription_status,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CASE
                                       WHEN previous_purchases > 5 THEN 'Repeat Buyers'
                                       ELSE 'Normal Buyers'
                                   END
                                   ) AS percents
FROM customer_behaviour_analysis
GROUP BY CASE
        WHEN previous_purchases > 5 THEN 'Repeat Buyers'
        ELSE 'Normal Buyers'
    END, subscription_status


--What is the reverse contribute of each age group?


SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 35 AND 50 THEN '35-50'
        ELSE '51+'
    END AS age_group,
    ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customer_behaviour_analysis
GROUP BY CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 35 AND 50 THEN '35-50'
        ELSE '51+'
    END
    ORDER BY total_revenue DESC
