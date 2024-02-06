--Below are Queries that answer Data science salary trens for the year 2020 through 2023

--Q1. What is is the average salary like across Different experience levels

SELECT
	CASE experience_level
		WHEN 'EX' THEN 'Experienced'
		WHEN 'EN' THEN 'Entry Level'
		WHEN 'MI' Then 'Mid-Level'
		WHEN 'SE' THEN 'Senior'
	END AS experience_level,
	AVG(Salary) AS average_salary
FROM ds_salaries
GROUP BY experience_level;

--Q2. Which is the most common job in the field of data science

SELECT TOP 10
	job_title,
	COUNT(*) AS number_of_jobs
FROM ds_salaries
GROUP BY job_title
ORDER BY 2 DESC;

-- Q3. How does Salary Distribution vary with company size
SELECT
	Company_size,
	MAX(salary) AS highest_salary,
	MIN(salary) AS minimum_salary,
	AVG(salary ) As average_salary
FROM ds_salaries
GROUP BY company_size

--Q4. Where are data science jobs primarily located

SELECT
	company_location,
	COUNT(*) AS number_of_companies
FROM ds_salaries
GROUP BY company_location
ORDER BY
	2 DESC

--Q5. Which jobs earn the highest salaries in the data science field?
SELECT TOP 10
	job_title,
	AVG(salary) AS average_salary
FROM ds_salaries
GROUP BY job_title
ORDER BY 2 DESC;

--Q6. Which job experience level has gost the highest number of remote workers

SELECT
	CASE experience_level
		WHEN 'EX' THEN 'Experienced'
		WHEN 'EN' THEN 'Entry Level'
		WHEN 'MI' Then 'Mid-Level'
		WHEN 'SE' THEN 'Senior'
	END AS experience_level,
	COUNT(*) AS number_of_workers
FROM ds_salaries
WHERE employee_residence <> company_location
GROUP BY experience_level
ORDER BY number_of_workers DESC;


--Q7. In which country do data scientist earn more than the average salary 
SELECT
	company_location
FROM ds_salaries
GROUP BY company_location
HAVING MIN(salary) >
(SELECT
	AVG(Salary)
FROM ds_salaries)

--Q8. Which Year were data scientist paid well in the industry?

SELECT
	Work_year,
	AVG(salary) AS avarage_pay
FROM ds_salaries
GROUP BY Work_Year
ORDER BY 2 DESC;


