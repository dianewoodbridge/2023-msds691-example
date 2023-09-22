------------------------------------
-- Example 1. Activity Rank
-- https://platform.stratascratch.com/coding/10351-activity-rank
-- Find the email activity rank (total number of emails sent) for each user.  
-- The user with the highest number of emails sent will have a rank of 1, and so on. 
-- Output the user, total emails, and their activity rank.
-- Order records by the total emails in descending order. 
-- Sort users with the same number of emails in alphabetical order.
------------------------------------
SELECT from_user, total_emails, ROW_NUMBER() OVER (ORDER BY total_emails DESC, from_user)
FROM
(
SELECT from_user, COUNT(*) as total_emails
FROM  google_gmail_emails 
GROUP BY from_user
) as gmail_total_emails


------------------------------------
-- Example 2. Days At Number One
-- https://platform.stratascratch.com/coding/10173-days-at-number-one
-- Find the number of days a US track has stayed in the 1st position 
-- for both the US and worldwide rankings on the same day. 
-- Output the track name and the number of days in the 1st position. 
-- Order your output alphabetically by track name.
------------------------------------
WITH rank_1_us_ranking AS
(SELECT trackname, artist, date
FROM spotify_daily_rankings_2017_us
WHERE position = 1),
rank_1_worldwide_ranking AS
(SELECT trackname, artist, date
FROM spotify_worldwide_daily_song_ranking
WHERE position = 1)
SELECT rank_1_us_ranking.trackname, COUNT(*)
FROM rank_1_us_ranking
JOIN spotify_worldwide_daily_song_ranking
ON rank_1_us_ranking.trackname = spotify_worldwide_daily_song_ranking.trackname
AND rank_1_us_ranking.artist = spotify_worldwide_daily_song_ranking.artist
AND rank_1_us_ranking.date = spotify_worldwide_daily_song_ranking.date
GROUP BY rank_1_us_ranking.trackname 
ORDER BY trackname

------------------------------------
-- Example 3. Revenue Over Time
-- https://platform.stratascratch.com/coding/10314-revenue-over-time
-- Find the 3-month rolling average of total revenue from purchases 
-- given a table with users, their purchase amount, and date purchased. 
---- Do not include returns which are represented by negative purchase values. 
---- Output the year-month (YYYY-MM) and 3-month rolling average of revenue, 
---- sorted from earliest month to latest month. 
---- A 3-month rolling average is defined by calculating the average total revenue 
---- from all user purchases for the current month and previous two months. 
---- The first two months will not be a true 3-month rolling average 
---- since we are not given data from last year. 
---- Assume each month has at least one purchase.
------------------------------------
WITH 
amazon_purchases_no_returns AS
(SELECT TO_CHAR(created_at, 'YYYY-MM') as month, purchase_amt::REAL
FROM amazon_purchases
WHERE purchase_amt > 0)
SELECT month, AVG(monthly_purchase_amt) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM
(
SELECT month, SUM(purchase_amt) AS monthly_purchase_amt
FROM amazon_purchases_no_returns
GROUP BY month
) AS monthly_total_purchase

------------------------------------
-- Example 4. Monthly Percentage Difference
-- https://platform.stratascratch.com/coding/10319-monthly-percentage-difference
-- Given a table of purchases by date, 
-- calculate the month-over-month percentage change in revenue. 
-- The output should include the year-month date (YYYY-MM) and percentage change, 
-- rounded to the 2nd decimal point, and sorted 
-- from the beginning of the year to the end of the year.
-- The percentage change column will be populated from the 2nd month 
-- forward and can be calculated as 
-- ((this month's revenue - last month's revenue) / last month's revenue)*100.
------------------------------------
WITH monthly_revenue AS
(SELECT TO_CHAR(created_at, 'YYYY-MM') AS year_month, SUM(value) as revenue
FROM sf_transactions
GROUP BY TO_CHAR(created_at, 'YYYY-MM'))
SELECT year_month, ROUND((revenue - LAG(revenue) OVER (ORDER BY year_month))/(LAG(revenue) OVER (ORDER BY year_month)) * 100, 2)
FROM monthly_revenue


