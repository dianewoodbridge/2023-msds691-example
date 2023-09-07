----------------------------------------------------------------------------------
-- Ex 1. Find the 3 most profitable companies in the entire world.
---- Output the result along with the corresponding company name.
---- Sort the result based on profits in descending order.
-- https://platform.stratascratch.com/coding/10354-most-profitable-companies
----------------------------------------------------------------------------------
SELECT company, profit
FROM (
SELECT company, SUM(profits) AS profit
FROM forbes_global_2010_2014
GROUP BY company) AS aggregates
ORDER BY profit DESC
LIMIT 3;


----------------------------------------------------------------------------------
-- Ex 2. Meta/Facebook is developing a search algorithm that will allow users to search through their post history. You have been assigned to evaluate the performance of this algorithm.
-- We have a table with the user's search term, search result positions, and whether or not the user clicked on the search result.
-- Write a query that assigns ratings to the searches in the following way:
---- If the search was not clicked for any term, assign the search with rating=1
---- If the search was clicked but the top position of clicked terms was outside the top 3 positions, assign the search a rating=2
---- If the search was clicked and the top position of a clicked term was in the top 3 positions, assign the search a rating=3
-- As a search ID can contain more than one search term, select the highest rating for that search ID. Output the search ID and its highest rating.
-- https://platform.stratascratch.com/coding/10350-algorithm-performance
----------------------------------------------------------------------------------
SELECT search_id, MAX(rating) AS max_rating
FROM
(
    SELECT search_id,
           CASE 
            WHEN clicked = 0 THEN 1
            WHEN clicked = 1 AND search_results_position > 3 THEN 2
            WHEN clicked = 1 AND search_results_position <= 3 THEN 3
           END AS rating
    FROM fb_search_events
) AS fb_search_score
GROUP BY search_id

----------------------------------------------------------------------------------
-- Ex 3. You have been asked to find the job titles of the highest-paid employees.
----  Your output should include the highest-paid title or multiple titles with the same salary.
-- https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries
----------------------------------------------------------------------------------
SELECT worker_title
FROM worker
JOIN title
ON worker.worker_id = title.worker_ref_id
GROUP BY worker_title
HAVING MAX(salary) = (SELECT MAX(salary) FROM worker)


----------------------------------------------------------------------------------
-- Ex 4. Identify projects that are at risk for going overbudget. A project is considered to be overbudget if the cost of all employees assigned to the project is greater than the budget of the project.
---- You'll need to prorate the cost of the employees to the duration of the project. For example, if the budget for a project that takes half a year to complete is $10K, then the total half-year salary of all employees assigned to the project should not exceed $10K. Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than one year.
---- Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).
---- HINT: to make it simpler, consider that all years have 365 days. You don't need to think about the leap years.
-- https://platform.stratascratch.com/coding/10304-risky-projects
----------------------------------------------------------------------------------
SELECT title, budget, CEIL(SUM(cost)) AS prorated_employee_expense
FROM
(
    SELECT id, emp_id, title, budget, salary::REAL/365::REAL * (end_date - start_date) AS cost
    FROM linkedin_projects
    JOIN 
    (
        SELECT emp_id, project_id, salary
        FROM linkedin_emp_projects
        JOIN linkedin_employees
        ON id = emp_id
    ) AS prj_emp_salary
    ON id = project_id
) AS project_individual_cost
GROUP BY title, budget
HAVING SUM(cost) > budget