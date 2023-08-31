---------------------------------------------------------------------------
-- Ex1. 
-- Find the unique owner_name and the pe_description of facilities
-- owned by 'BAKERY' where low-risk cases have been reported.
---- owner_name should include 'BAKERY'  and 
---- pe_description should include ‘low-risk’ (case-insensitive)
--
-- https://platform.stratascratch.com/coding/9697-bakery-owned-facilities
---------------------------------------------------------------------------
SELECT DISTINCT owner_name, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE LOWER(owner_name) LIKE '%bakery%' AND LOWER(pe_description) LIKE '%low risk%';

---------------------------------------------------------------------------
-- Ex2.
-- Calculate the total revenue in March 2019. Include only customers who were active in March 2019.
-- To calculate the total, you can use SUM(attribute).
--
-- https://platform.stratascratch.com/coding/9782-customer-revenue-in-march
---------------------------------------------------------------------------
SELECT SUM(total_order_cost) AS revenue
FROM orders
WHERE EXTRACT(month FROM order_date) = 3 and EXTRACT(year FROM order_date) = 2019
AND cust_id NOT IN 
(
SELECT cust_id 
FROM orders
WHERE  EXTRACT(month FROM order_date) <> 3 and EXTRACT(year FROM order_date) <> 2019
)


---------------------------------------------------------------------------
-- Ex3. 
-- You are given a table of users who have been blocked from Facebook, 
-- together with the date, duration, and the reason for the blocking. 
-- The duration is expressed as the number of days after blocking date 
-- and if this field is empty, this means that a user is blocked permanently.
-- 
-- Return the unique user_ids were blocked in December 2021 in ascending order. 
-- Include both the users who were blocked in December 2021 and 
-- those who were blocked before but remained blocked for at least a part of December 2021.
--
-- https://platform.stratascratch.com/coding/2084-blocked-users
---------------------------------------------------------------------------
SELECT DISTINCT user_id
FROM fb_blocked_users
WHERE TO_CHAR(block_date, 'YYYY-MM') = '2021-12'
OR 
(DATE_TRUNC('month', block_date) <= DATE'2021-12-01'
AND 
(DATE_TRUNC('day', block_date + block_duration::INT) >= DATE'2021-12-31' OR block_duration IS NULL))
ORDER BY user_id

---------------------------------------------------------------------------
-- Ex4. 
-- FROM epa_air_quality, return the string of 'year-mo', site_id and value
-- , which represents the smaller value 
-- between daily_mean_pm10_concentration and daily_aqi_value for the same date
-- where its county is not Butte 
-- ordered by site_id (ascending), date (ascending) and val (descending)
---------------------------------------------------------------------------
SELECT DISTINCT TO_CHAR(date,'YYYY-MM') AS date, 
				site_id, 
				LEAST(daily_mean_pm10_concentration, daily_aqi_value) AS val
FROM epa_air_quality 
WHERE site_id IN
(SELECT site_id
FROM epa_site_location
WHERE county <> 'Butte')
ORDER BY site_id ASC, date ASC, val DESC