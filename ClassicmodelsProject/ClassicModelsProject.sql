USE classicmodels
#1. Prepare a list of Offices sorted by country, State,City.

SELECT 
	OfficeCode,
	City,
	State,
	Country,
	Territory
FROM 
	classicmodels.Offices
ORDER BY
	Country,
	State,
	City;
	
#2.How many employees are there in the company?

SELECT 
	COUNT(*) As 'NumberOfEmployees'
FROM
	classicmodels.Employees;
	
#3. What is the total payment received?
	
SELECT 
	SUM(Amount) AS 'TotalPaymentReceived'
FROM
	classicmodels.Payments;
	
#4. List the product lines that contain 'Cars'.
	
SELECT 
	ProductLine,
	TextDescription
FROM 
	classicmodels.ProductLines
WHERE 
	Productline LIKE '%cars%';
	
#5. Report total payments fon october 28, 2004.

SELECT
	SUM(Amount) AS 'OctoberTotal'
FROM 
	classicmodels.Payments
WHERE
	PaymentDate = '2004-10-28';

#6.Report all payments above  $100000

SELECT
	CustomerNumber,
	CheckNumber,
	Amount
FROM 
	classicmodels.Payments
WHERE 
	Amount > 100000;
	
#7. List the products in each product line

SELECT 
	DISTINCT productLine,
	ProductName
FROM 
	classicmodels.Products
ORDER BY
	ProductLine;

#8. How many products are in each product line?

SELECT 
	Productline,
	COUNT(*) AS 'NumberOfProducts'
FROM
	Classicmodels.Products
GROUP BY
	Productline
ORDER BY 
	2 DESC;

#9. What is the minimum payment received?

SELECT 
	MIN(Amount) AS 'MinimumReceivedPayment'
FROM 
	classicmodels.Payments;

#10. List all payments greater than twice the average payment.
SELECT	
	CustomerNumber,
	CheckNumber,
	PaymentDate,
	Amount
FROM 
	classicmodels.payments 
WHERE 
	Amount >
(
SELECT
	AVG(Amount * 2)
FROM classicmodels.Payments
);

#11. What is is the average percantage markup of MSRP on buy price:

#12. How many distinct products does classic models sell?

SELECT
	COUNT(DISTINCT ProductName) AS 'NumberOfUniqueProducts'
FROM 
	Classicmodels.Products;

#13. Report the name and city of customers who dont have sales reperesentatives.

SELECT
	CustomerName,
    City
FROM 
	classicmodels.Customers
WHERE 
	SalesRepEmployeeNumber IS NULL;

#14. What are the na,mes of executives with VP or manager in yheir title,Return a sinbgle full name.alter

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'EmployeeName',
    JobTitle
FROM 
	classicmodels.Employees
WHERE
	JobTitle LIKE '%VP%'
    OR JobTitle LIKE '%manager%';

#15. Which orders have value greater than $5000?

   SELECT 
	OrderLineNumber,
    SUM(PriceEach) AS 'TotalPerOrder'
FROM 
	classicmodels.OrderDetails
GROUP BY
	OrderLineNumber
HAVING 
	SUM(PriceEach) > 5000
ORDER BY
	SUM(PriceEach) DESC;

#16. Report the account representative for each customer.

SELECT 
		CONCAT(e.FirstName,' ',e.LastName) AS 'Employee',
        c.CustomerName AS 'Customer'
FROM
	classicmodels.Employees AS e
    INNER JOIN classicmodels.Customers AS c
    ON e.EmployeeNumber = c.SalesRepEmployeeNumber
ORDER BY
	e.FirstName,
    e.Lastname;

#17. Report total payments for Atelier Graphique.

SELECT 
	SUM(p.Amount) AS 'AtelierGraphiqueTotalPayment'
FROM
	classicmodels.Customers AS c
    INNER JOIN classicmodels.Payments AS p
    ON c.CustomerNumber = p.CustomerNumber
WHERE 
	c.CustomerName = 'Atelier Graphique';

#18. Report Total payments by date.

SELECT
	PaymentDate,
    SUM(Amount) AS 'TotalForDate'
FROM classicmodels.Payments
GROUP BY
	PaymentDate
ORDER BY
	PaymentDate DESC;

#19. Report the products that have not been sold.

SELECT 
	p.ProductName,
    p.ProductLine,
    p.ProductVendor
FROM
	classicmodels.Products AS p
    LEFT JOIN classicmodels.Orderdetails AS od
    ON p.ProductCode = od.ProductCode
WHERE
	od.ProductCode IS NULL;
    
#20. List the amout paid by each customer

SELECT 
	c.CustomerName,
    SUM(p.Amount) AS 'TotalAmpuntPerCustomer'
 FROM
	classicmodels.Customers AS c
    INNER JOIN classicmodels.Payments AS p
    ON c.CustomerNumber = p.CustomerNumber
GROUP BY
	c.CustomerName;

#21. How many Orders have been placed by Hekku Gifts?

SELECT 
	COUNT(o.OrderNumber) AS 'NumberOfOrders'
FROM
	classicmodels.Customers AS c
    INNER JOIN classicmodels.Orders AS o
    ON c.CustomerNumber = o.CustomerNumber
WHERE 
	c.CustomerName = 'Herkku Gifts';

#22. Who are the employees in Boston

SELECT 
	e.EmployeeNumber,
    CONCAT(e.FirstName,' ',e.LastName) AS 'EmployeeName'
FROM
	classicmodels.Employees AS e
    INNER JOIN classicmodels.Offices AS o
    ON e.OfficeCode = o.OfficeCode
WHERE
	o.City = 'Boston';

#23. Report those payments greater than $100000. Sort the report so that the customer who made the highes payment apperas first.

SELECT 
	c.CustomerName,
    p.Amount
FROM 
	classicmodels.Customers AS c
    INNER JOIN classicmodels.Payments AS p
    On c.CustomerNumber = p.CustomerNumber
WHERE
	p.Amount > 100000
ORDER BY
	Amount DESC;
    
#24. List the Value of 'On Hold Orders'.

SELECT 
	SUM(PriceEach * QuantityOrdered) AS 'ValueOfOrdersOnHold'
FROM
	classicmodels.Orders AS o
    INNER JOIN classicmodels.OrderDetails AS od
    ON o.OrderNumber = od.OrderNumber
WHERE
	o.Status = 'On hold';
    
#25. Report the numbers of orders 'On hold' for each customer

SELECT 
	c.CustomerName,
    COUNT(o.OrderNumber) AS 'NumberOfOrdersOnHold'
FROM
	classicmodels.Customers AS c
    LEFT JOIN classicmodels.Orders AS o
    ON c.CustomerNumber = o.CustomerNumber
WHERE
	o.Status = 'On Hold'
GROUP BY
	c.CustomerName;



#26. List products sold by orderdate.

SELECT 
	o.OrderDate,
	p.ProductName,
	p.BuyPrice
FROM
	classicmodels.Products AS p
	INNER JOIN classicmodels.Orderdetails AS od
	ON p.productCode = od.ProductCode 
	INNER JOIN classicmodels.Orders AS o
	ON od.OrderNumber = o.OrderNumber
ORDER BY
	OrderDate DESC;

#27. List the order dates in descending order for orders for the 1940 Ford Pickup Truck

SELECT 
	o.OrderDate
FROM
	classicmodels.Products AS p
	INNER JOIN classicmodels.Orderdetails AS od
	ON p.productCode = od.ProductCode 
	INNER JOIN classicmodels.Orders AS o
	ON od.OrderNumber = o.OrderNumber
WHERE
	p.ProductName = '1940 Ford Pickup Truck'
ORDER BY
	OrderDate DESC

#28. List the names of customers and their corresponding order number where a particular order from that Customer has aa value greater than $25000

SELECT 
	c.CustomerName,
	o.OrderNumber
FROM
	classicmodels.Customers AS c
	INNER JOIN classicmodels.Orders AS o
	ON c.CustomerNumber = o.CustomerNumber
	INNER JOIN classicmodels.Payments AS p
	ON c.CustomerNumber = p.CustomerNumber
WHERE
	p.Amount > 25000
	
#29. Are there products that appear on all orders?

SELECT
	o.OrderNumber,
	p.ProductName
FROM
	classicmodels.Orders AS o
	INNER JOIN classicmodels.Orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
	LEFT JOIN classicmodels.Products AS p
	ON od.ProductCode = p.ProductCode
GROUP BY
	OrderNumber,
	ProductName
ORDER BY
	OrderNumber,
	ProductName;


#30. List the names of the products sold at les than 80% of the MSRP



#31.Report those products that have been sold with markup of 100% or more

SELECT
	p.ProductName,
	o.OrderNumber
FROM
	classicmodels.Orders AS o
	INNER JOIN classicmodels.Orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
	INNER JOIN classicmodels.Products AS p
	ON od.ProductCode = p.ProductCode

WHERE
	od.PriceEach >= p.BuyPrice * 2


#32. List Products ordered on Monday

SELECT
	p.ProductName,
	o.OrderNumber,
	o.orderdate
FROM
	classicmodels.Orders AS o
	INNER JOIN classicmodels.Orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
	INNER JOIN classicmodels.Products AS p
	ON od.ProductCode = p.ProductCode

WHERE
	DAYOFWEEK(o.Orderdate) = 1;

#33. What is the quantity on hand for products listed on 'On Hold' orders?

SELECT
	SUM(p.QuantityInStock - od.QuantityOrdered) AS 'OnHoldQuantityInStock'
FROM
	classicmodels.Orders AS o
	INNER JOIN classicmodels.Orderdetails AS od
	ON o.OrderNumber = od.OrderNumber
	INNER JOIN classicmodels.Products AS p
	ON od.ProductCode = p.ProductCode
WHERE
	o.Status = 'On Hold';


#34. Find Products containing the name 'Ford'.

SELECT *
FROM
	classicmodels.Products
WHERE
	ProductName LIKE '%Ford%';

#35. List products ending in 'ship'.

SELECT *
FROM 
	classicmodels.products 
WHERE 
	ProductName LIKE '%ship';


#36. Report the number of customers in Denmark, Norway, and Sweden.

SELECT 
	COUNT(*) AS 'CustomersFromNorwayDenmarkSweeden'
FROM 
	classicmodels.Customers
WHERE
	Country IN('Denmark', 'Norway', 'Sweeden');

#36. What are the products with a product code in the range S700_1000 to S700_1499?

SELECT 
	ProductCode
	ProductName,
	ProductLine,
	ProductDescription,
	QuantityInStock,
	BuyPrice
FROM
	classicmodels.Products
WHERE
	ProductCode BETWEEN 'S700_1000' AND 'S700_1499';
	
#37. Which customers have a digit in their name?

SELECT 
	CustomerNumber,
	CustomerName
FROM
	classicmodels.Customers
WHERE 
	CustomerName REGEXP'[0-9]';

#38. List the names of employees called Dianne or Diane

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'EmployeeName'
FROM
	classicmodels.Employees
WHERE
	FirstName REGEXP 'Dianne|Diane'
	OR LastName REGEXP 'Dianne|Diane';

#39. List the products containing ship or boat in their product name.

	SELECT 
		ProductCode,
		ProductName
	FROM 
		classicmodels.Products
	WHERE 
		ProductName REGEXP 'ship|boat';

#40. List the products with a product code beginning with S700.
	
SELECT 
	ProductCode,
	ProductName
FROM
	classicmodels.Products
WHERE 
	ProductCode REGEXP 'S700?';


#41. List Names of employees called Larry or Barry.

SELECT 
	CONCAT(FirstName,' ',LastName) AS 'EmployeeName'
FROM
	classicmodels.Employees
WHERE
	FirstName REGEXP 'Larry|Barry'
	OR LastName REGEXP 'Larry|Barry';

#42. List the names of employees with non-alphabetic characters in their names.

SELECT
	CONCAT(FirstName,' ',LastName) AS 'EmployeeName'
FROM 
	classicmodels.Employees
WHERE
	CONCAT(FirstName,' ',LastName) REGEXP '[0-9%@]'


#43. List the vendors whose name ends in Diecast.

SELECT
	ProductVendor
FROM
	classicmodels.Products
WHERE
	ProductVendor REGEXP 'Diecast$';
































































































































































































































































































































































































































































































































































































































































































































































































































































































































































#Find the products sold in 2003 but not 2004.

SELECT 
	DISTINCT p.ProductName,
	p.BuyPrice
FROM 
	classicmodels.Products AS p
	INNER JOIN classicmodels.orderdetails AS od
	ON p.ProductCode = od.ProductCode
	INNER JOIN classicmodels.Orders AS o
	ON od.orderNumber = o.orderNumber 
WHERE
	YEAR(OrderDate) = 2003
	AND p.ProductCode  IN
							(
								SELECT 
									DISTINCT p2.ProductCode
								FROM 
									classicmodels.Products AS p2
									INNER JOIN classicmodels.orderdetails AS od2
									ON p2.ProductCode = od2.ProductCode
									INNER JOIN classicmodels.Orders AS o2
									ON od2.orderNumber = o2.orderNumber
								WHERE
									YEAR(o2.OrderDate) <> 2004
							);




























































































