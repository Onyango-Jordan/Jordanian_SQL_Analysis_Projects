USE hresourcedb;
SELECT * FROM hr;
# QUESTIONS

# 1. What is the gender  breakdown of employees in the company?
SELECT
	gender,
    COUNT(*) AS number_of_employees
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY gender;
    
# 2.What is the race ethnicity breakdown of employees in the cmpany?
SELECT
	race,
    COUNT(*) as number_employees
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY race
ORDER BY COUNT(*) DESC;

# 3. What is the age distribution of employees per gender in the company?
SELECT
	CASE 
		WHEN age >= 18 AND age <= 24 THEN '18-24'  
        WHEN age >= 25 AND age <= 34 THEN '25-34' 
		WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    gender,
	COUNT(1) AS number_per_age_group
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY age_group, gender
ORDER BY age_group, gender;


# 4. How many employees work at the headquarters versus remote locations?
SELECT
	location,
    COUNT(*) AS employees_in_location
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY location;

# 5. What is the average length of employment for employees who have been terminated?
SELECT
	ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS average_length_of_employment
FROM hr
WHERE termdate <= CURDATE()
	AND termdate <> 0000-00-00
    AND age >= 18;
    
# 6.How does the gender distribution vary across departments?
SELECT
	department,
    gender,
    COUNT(*) as_number_of_employees
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY 
	department,
    gender
ORDER BY 3 DESC;
	
# 7.WHat is the distribution of job titles across the company?
SELECT
	jobtitle,
    COUNT(*) AS employees_per_title
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY jobtitle
ORDER BY 2 DESC;

# 8. Which department has the highest turnover rate?
SELECT
	department,
    total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM  (
	SELECT
		department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

# 9. WHat is the distribution of employees across locations by city and sate?
SELECT
	location_state,
    location_city,
    COUNT(*) as_number_per_location
FROM hr
WHERE age >= 18
	AND termdate = 0000-00-00
GROUP BY location_state, location_city
ORDER BY 1, 2, 3 DESC;


# 10. How has the company's employee count changed over time based on hire date and termdate
SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_cahnge,
    ROUND((hires - terminations)/hires * 100, 2) AS pct_net_change
FROM (
	SELECT
		YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
	FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

# 11. What is the tenure distribution in each deparment?
SELECT
	department,
    ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_tenure
FROM hr
WHERE age >= 18
	AND termdate <> 0000-00-00
    AND termdate <= CURDATE()
GROUP BY department
ORDER BY 2 DESC;






