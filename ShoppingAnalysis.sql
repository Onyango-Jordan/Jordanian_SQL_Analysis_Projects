USE sample_data;

# Q1. Show me the details of sales where amounts are over 2000 and boxes are less than 100?
SELECT *
FROM sales
	WHERE amount > 2000 
	AND boxes < 100;
    
# Q2. How many sales were made by each sales person in the month of January 2022? 
SELECT 
	DATE(s.SaleDate),
    p.Salesperson,
    SUM(s.Amount) AS total_sales_made
FROM people p
	LEFT JOIN sales s
    ON p.SPID = s.SPID
    WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY DATE(s.SaleDate),p.Salesperson
ORDER BY DATE(s.SaleDate) ASC;

# Q3. Which Products sold more boxes?
SELECT
	p.Product,
    SUM(s.Boxes) AS total_number_of_boxes
FROM Products p
	LEFT JOIN sales s
    ON p.PID = s.PID
GROUP BY p.Product
ORDER BY total_number_of_boxes DESC;

# Q4. Which Product sold more boxes in the first 7 days of February 2022
SELECT
	p.Product,
    SUM(Boxes) AS total_number_of_boxes
FROM Products p
	LEFT JOIN Sales s
    ON p.PID = s.PID
    WHERE Year(SaleDate) = 2022
		AND Month(SaleDate) = 02
        AND DAY(SaleDate) BETWEEN 01 AND 07
GROUP BY p.Product
ORDER BY 2 DESC;

# Q5. Which sales had less than 100 customers and below 100 boxes? Did any occr on wednesday?
SELECT *,
	CASE
		WHEN customers < 100 AND BOxes < 100 AND WEEKDAY(SaleDate) = 2 THEN 'OK'
        ELSE 'NOT OKAY'
	END AS Result
FROM sales
ORDER BY Result DESC;





































































































































































    

    