#1. Who is at the top of the organization (i.e.,  reports to no one).

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'Manager'
FROM 
	Employees
WHERE 
	ReportsTo IS NULL;


#2. Who reports to William Patterson?

SELECT 
	CONCAT(emp.FirstName,' ',emp.LastName) AS 'Employee'
FROM 
	classicmodels.Employees AS emp
	LEFT JOIN classicmodels.Employees AS Mgr
	ON emp.reportsTo = mgr.EmployeeNumber
WHERE
	CONCAT(mgr.FirstName,' ',mgr.LastName) = 'William Patterson';

#Using Subquery

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'Employee'
FROM Employees
WHERE 
	ReportsTo = (
					SELECT 
						EmployeeNumber
					FROM Employees
					WHERE 
						CONCAT(FirstName,' ',LastName) = 'William Patterson'
				);

#3. List all the products purchased by Herkku Gifts.

SELECT 
	p.ProductName,
	p.Productline,
	p.ProductVendor
FROM
	classicmodels.Products AS P
	INNER JOIN classicmodels.orderdetails AS od
	ON p.ProductCode = od.ProductCode
	INNER JOIN classicmodels.orders AS o 
	ON od.OrderNumber = o.OrderNumber
	INNER JOIN classicmodels.Customers AS c
	ON o.CustomerNumber = c.CustomerNumber
WHERE
	c.CustomerName = 'Herkku Gifts';


/*4. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order.
 *  Sort by employee last name and first name*/

SELECT 
	CONCAT(e.FirstName,' ',e.LastName) AS 'Salesman',
	ROUND(SUM(COALESCE(od.QuantityOrdered * od.PriceEach,0)) * (5/100), 2) AS 'Commission'
FROM
	classicmodels.Employees AS e
	INNER JOIN classicmodels.Customers AS c
	ON e.EmployeeNumber = c.SalesRepEmployeeNumber
	INNER JOIN classicmodels.Orders AS o
	ON c.CustomerNumber = o.CustomerNumber
	INNER JOIN classicmodels.orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
GROUP by 
	CONCAT(e.FirstName,' ',e.LastName)
ORDER BY
	CONCAT(e.FirstName,' ',e.LastName);

#5. What is the difference in days between the most recent and oldest order date in the Orders file?

SELECT 
	DATEDIFF(MAX(OrderDate), MIN(OrderDate)) AS 'Number of Days Between first and last order'
FROM
	classicmodels.Orders


#6. Compute the average time between order date and ship date for each customer ordered by the largest difference.	
	
	SELECT 
		c.CustomerName,
		ROUND(AVG(DATEDIFF(ShippedDate, OrderDate)),0) AS 'AverageOrderProcessingDays'
	FROM 
		classicmodels.Customers AS c
		INNER JOIN classicmodels.Orders AS o
		ON c.CustomerNumber = o.CustomerNumber
	GROUP BY
		c.CustomerName
	ORDER BY
		AVG(DATEDIFF(ShippedDate,OrderDate)) DESC;
		
#7. What is the value of orders shipped in August 2004? (Hint)
SELECT 
	SUM(COALESCE(od.QuantityOrdered * od.PriceEach,0)) AS 'TotalValueForAugust2004ShippedGoods'
FROM
	classicmodels.orders AS o 
	INNER JOIN classicmodels.Orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
WHERE
	MONTH(o.ShippedDAte) = 8
	AND YEAR(o.ShippedDate) = 2004;
	
/*8. Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received 
2004. Only report those customers where the absolute value of the difference is greater than $100. (Hint: Create views for the total paid and total ordered).
 and payments received in 2004. Only report those customers where the absolute value of the difference is greater than $100. (Hint: Create views for the total paid and total ordered).*/
	
 WITH pay2004 AS
 (SELECT   
 	c2.CustomerName,
 	SUM(p.Amount) AS 'TotalPayment'
  FROM 
  	classicmodels.Customers AS c2
  	INNER JOIN classicmodels.Payments As p
  	ON c2.CustomerNumber = p.CustomerNumber
  WHERE 
  	YEAR(p.PaymentDate) = 2004
  GROUP BY
  	c2.CustomerName
  ),
ord2004 AS 
(SELECT
	CustomerName,
	COALESCE(SUM(od.QuantityOrdered * od.PriceEach),0) AS 'TotalOrderValue'
 FROM
 	classicmodels.Customers AS c
 	INNER JOIN classicmodels.Orders AS o
 	ON c.CustomerNumber = o.CustomerNumber
 	INNER JOIN classicmodels.Orderdetails AS od
 	ON o.OrderNumber = od.OrderNumber
 WHERE 
 	YEAR(o.OrderDate) = 2004
 GROUP BY 
 	c.CustomerName
 )
SELECT
	pay.CustomerName,
	pay.TotalPayment,
	ord.TotalOrderValue,
	(pay.TotalPayment - ord.TotalOrderValue) AS Difference
FROM
	Ord2004 AS ord
	INNER JOIN pay2004 AS pay
	ON ord.CustomerName = pay.CustomerName
	AND ABS( pay.TotalPayment - ord.TotalOrderValue) > 100
;
 

/*9. List the employees who report to those employees who report to Diane Murphy.
 Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.*/

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'ReportsToDianeMurphy'
FROM
	classicmodels.Employees AS emp1
WHERE 
	emp1.EmployeeNumber IN (
						SELECT 
							emp.employeeNumber 
						FROM 
							classicmodels.Employees AS emp
							LEFT JOIN classicmodels.Employees AS Mgr
							ON emp.reportsTo = mgr.EmployeeNumber
						WHERE
							CONCAT(mgr.FirstName,' ',mgr.LastName) = 'Diane Murphy'	
						);
#10. What is the percentage value of each product in inventory sorted by the highest percentage first.
 
SELECT
	ProductName,
	ROUND(QuantityInStock * BuyPrice,0) AS 'Stock',
	ROUND(QuantityInStock * BuyPrice/(TotalValue) * 100,2) AS 'Percent'
FROM	
	classicmodels.Products,
	(SELECT 
		SUM(QuantityInStock * BuyPrice) AS 'TotalValue'
	 FROM classicmodels.Products) AS Tot
	ORDER BY
		QuantityInStock * BuyPrice/(TotalValue) * 100 DESC;
	
	
#11. What is the value of payments received in July 2004?
	
SELECT 
	SUM(Amount) AS 'ValueOfPayment'
FROM 
	classicmodels.Payments
WHERE	
	YEAR(PaymentDate) = 2004
	AND MONTH(PaymentDate) = 7;
	
/*12. What is the ratio of the value of payments made to orders received for each month of 2004? 
(i.e., divide the value of payments made by the orders received)?*/
	
WITH pay AS	
(SELECT 
	MONTH(PaymentDate) AS payMonth,
	SUM(Amount) AS AmountValue
 FROM 
 	classicmodels.Payments
 WHERE 
 	YEAR(PaymentDate) = 2004 
 GROUP BY
 	MONTH(PaymentDate)
 ORDER BY
 	MONTH(PaymentDate) ASC
),
Ord AS
(SELECT 
	MONTH(o.OrderDate) AS OrdMonth,
	SUM(od.QuantityOrdered * od.PriceEach) As OrdValue
 FROM 
 	classicmodels.Orders AS o
 	INNER JOIN classicmodels.Orderdetails AS od 
 	ON o.OrderNumber = od.OrderNumber
 WHERE YEAR(o.OrderDate)= 2004
 GROUP BY 
 	MONTH(o.OrderDate)
 ORDER BY
 	MONTH(o.OrderDate) ASC
 )
 	
 SELECT
 	ord.OrdMonth,
 	(pay.AmountValue/ord.OrdValue) 'RatioOfPaymentsToOrders'
 FROM 
 	Pay
 	INNER JOIN Ord
 	ON pay.Paymonth = ord.OrdMonth;
	
#13. What is the difference in the amount received for each month of 2004 compared to 2003?	
	
WITH pay2004 AS	
(SELECT 
	MONTH(PaymentDate) AS payMonth,
	SUM(Amount) AS AmountValue4
 FROM 
 	classicmodels.Payments
 WHERE 
 	YEAR(PaymentDate) = 2004 
 GROUP BY
 	MONTH(PaymentDate)
 ORDER BY
 	MONTH(PaymentDate) ASC
),
pay2003 AS	
(SELECT 
	MONTH(PaymentDate) AS payMonth,
	SUM(Amount) AS AmountValue3
 FROM 
 	classicmodels.Payments
 WHERE 
 	YEAR(PaymentDate) = 2003
 GROUP BY
 	MONTH(PaymentDate)
 ORDER BY
 	MONTH(PaymentDate) ASC
)

SELECT
	pay2003.PayMonth,
	ABS(Pay2004.AmountValue4 - pay2003.AmountValue3) AS 'PaymentDiffernce'
FROM	
	Pay2004
	INNER JOIN pay2003
	ON pay2004.paymonth = pay2003.paymonth;
	
	
	
/*14. Write a procedure to report the amount ordered in a specific month and year,
 for customers containing a specified character string in their name.*/	

DELIMITER //
CREATE PROCEDURE MyReportOrderValue(
IN inMonth INT,
IN inYear INT,
IN  inString VARCHAR(20))
LANGUAGE SQL
BEGIN
	SELECT 	
		CustomerNAme AS Customer,
		SUM(od.QuantityOrdered * PriceEach) 'Order Value'
	FROM
		OrderDetails AS od
		INNER JOIN Orders As o
		ON od.OrderNumber = o.OrderNumber
		INNER JOIN Customers AS c
		ON o.CustomerNumber = c.CustomerNumber
	WHERE 
		YEAR(OrderDAte) = inYear
		AND MONTH(OrderDAte) = inMonth
		AND CustomerNAme REGEXP inString
	GROUP BY
		c.CustomerName;
END //

	
/*15. Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn which products are often purchased together. 
 * Report the names of products that appear in the same order ten or more times.*/
WITH pro1 AS
(
SELECT 
	p.ProductCode ,
	p.Productname As product1,
	od.OrderNumber
FROM 
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode),
pro2 AS 
(SELECT 
	p.ProductCode ,
	p.Productname AS product2,
	od.OrderNumber
FROM 
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
)
SELECT
	Product1,
	product2,
	COUNT(*) As Frequency
FROM 
	pro1 INNER JOIN pro2
	ON pro1.OrderNumber = pro2.OrderNumber
WHERE 
	pro1.productcode > pro2.productcode
GROUP BY
	Product1,
	Product2
HAVING
	Frequency> 10
ORDER BY
	Frequency DESC,
	Product1,
	Product2;
	
	
/*16. reporting: Compute the revenue generated by each customer based on their orders.*/	
	
SELECT 
	c.CustomerName,
	SUM(od.QuantityOrdered * od.PriceEach) AS 'RevenuePerCustomer'
FROM 
	Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerNumber = o.CustomerNumber
	INNER JOIN OrderDetails AS od
	ON o.OrderNumber = od.OrderNumber
GROUP BY 
	c.CustomerName
ORDER BY
	c.CustomerName;
	
/*17. Compute the profit generated by each customer based on their orders.*/

WITH pp AS(SELECT 
	c.CustomerName,
	SUM(QuantityOrdered * (od.PriceEach - p.BuyPrice)) AS 'ProfitPerCustomer'
FROM 
	Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerNumber = o.CustomerNumber
	INNER JOIN OrderDetails AS od
	ON o.OrderNumber = od.OrderNumber
	INNER JOIN Products AS p
	ON od.ProductCode = p.ProductCode
GROUP BY	
	c.CustomerName)

	
/*18. Compute the revenue generated by each sales representative
 based on the orders from the customers they serve.*/
	
SELECT 	
	CONCAT(e.FirstName,' ',e.LastName) AS 'Employee',
	SUM(od.QuantityOrdered * od.PriceEach) AS 'RevenueGeneratedForEachCustomerServed'
FROM
	Employees AS e
	INNER JOIN Customers AS c
	ON e.EmployeeNumber = c.SalesRepEmployeeNumber
	INNER JOIN Orders AS o
	ON c.CustomerNumber = o.customerNumber 
	INNER JOIN OrderDetails AS od
	ON o.OrderNumber = od.OrderNumber
GROUP BY
	CONCAT(e.FirstName,' ',e.LastName)
ORDER BY
	SUM(od.QuantityOrdered * od.PriceEach) DESC;
	
#19. Compute the revenue generated by each product, sorted by product name.

SELECT 
	ProductName,
	SUM(od.QuantityOrdered * od.PriceEach) AS 'RevenuePerProduct'
FROM
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
GROUP BY
	p.ProductName
ORDER BY 
	p.ProductName
	
#20. Compute the profit generated by each product line, sorted by profit descending.	
	
SELECT 
	pl.ProductLine,
	SUM(od.QuantityOrdered * od.PriceEach) AS 'RevenuePerProductLine'
FROM
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
	INNER JOIN ProductLines AS pl
	ON p.ProductLine = pl.ProductLine
GROUP BY
	pl.ProductLine
ORDER BY 
	SUM(od.QuantityOrdered * od.PriceEach)	DESC;
	
#21. Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.

WITH sl2003 AS
(SELECT 
	p.ProductName AS product1,
	SUM(od.QuantityOrdered * od.PriceEach) AS sales2003
 FROM 
 	Products AS p
 	INNER JOIN OrderDetails AS od
 	ON p.ProductCode = od.ProductCode
 	INNER JOIN Orders AS o
 	ON od.OrderNumber = o.OrderNumber
 WHERE 	
 	YEAR(o.OrderDate) = 2003
 GROUP BY
 	p.ProductName
),
sl2004 AS
(SELECT 
	p.ProductName AS product2,
	SUM(od.QuantityOrdered * od.PriceEach) AS sales2004
 FROM 
 	Products AS p
 	INNER JOIN OrderDetails AS od
 	ON p.ProductCode = od.ProductCode
 	INNER JOIN Orders AS o
 	ON od.OrderNumber = o.OrderNumber
 WHERE 	
 	YEAR(o.OrderDate) = 2004
 GROUP BY
 	p.ProductName
)

SELECT
	sl2003.Product1,
	sl2003.sales2003,
	sl2004.sales2004,
	(sl2003.Sales2003/sl2004.sales2004) AS 'ProductRatio'
FROM
	sl2003 INNER JOIN sl2004 ON sl2003.Product1 = sl2004.Product2
ORDER BY
	(sl2003.Sales2003/sl2004.sales2004) DESC;
	
	
#22. Compute the ratio of payments for each customer for 2003 versus 2004.

WITH rat04 AS 
(
SELECT
	CustomerName AS Customer1,
	SUM(p.Amount) AS Amount2004
FROM 
	Customers AS c
	INNER JOIN Payments AS p
	ON c.CustomerNumber = p.CustomerNumber
WHERE 
	YEAR(PaymentDate) = 2004
GROUP BY
	c.CustomerName
),
rat03 AS
(
SELECT
	CustomerName AS Customer2,
	SUM(p.Amount) AS Amount2003
FROM 
	Customers AS c
	INNER JOIN Payments AS p
	ON c.CustomerNumber = p.CustomerNumber
WHERE 
	YEAR(PaymentDate) = 2003
GROUP BY
	c.CustomerName
)

SELECT
	rat04.Customer1 AS customer,
	rat03.Amount2003,
	rat04.Amount2004,
	ROUND((rat03.Amount2003/rat04.amount2004),2) AS PaymentRatio
FROM 
	rat03 INNER JOIN rat04
	ON rat03.customer2 = rat04.customer1;

	
#23. Find the products sold in 2003 but not 2004.	

SELECT 	
	p1.ProductName
FROM
	Products AS p1
	INNER JOIN OrderDetails AS od1
	ON p1.ProductCode = od1.ProductCode
	INNER JOIN Orders AS o1
	ON od1.OrderNumber = o1.OrderNumber
WHERE 
	YEAR(o1.OrderDate) = 2003
	AND p1.ProductCode NOT IN (
								SELECT 	
									DISTINCT p.ProductCode
								FROM
									Products AS p
									INNER JOIN OrderDetails AS od
									ON p.ProductCode = od.ProductCode
									INNER JOIN Orders AS o
									ON od.OrderNumber = o.OrderNumber
								WHERE 
									YEAR(OrderDate) = 2004
								);	

#Alternative using set operator
							
SELECT 	
p.ProductName
FROM
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
	INNER JOIN Orders AS o
	ON od.OrderNumber = o.OrderNumber
WHERE 
	YEAR(OrderDate) = 2003
EXCEPT	
(SELECT 	
	p.ProductName
FROM
	Products AS p
	INNER JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
	INNER JOIN Orders AS o
	ON od.OrderNumber = o.OrderNumber
WHERE 
	YEAR(OrderDate) = 2004)	
	
#24. Find the customers without payments in 2003.	
	
SELECT 	
	CustomerName
FROM 
	Customers 
WHERE 
	CustomerNumber NOT IN (
							SELECT
								CustomerNumber
							FROM Payments
							WHERE 
								YEAR(PaymentDate) = 2003
							);	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
