--(1) Write a query to get the number of customers per month who placed orders in 1997.
SELECT MONTH(OrderDate) AS month,
	   COUNT(CustomerID) AS count_customer   
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate)


--(2) Write a query to get the names of employees who are Sales Representatives.
SELECT CONCAT(FirstName, ' ',LastName) AS employee_name
FROM Employees 
WHERE Title = 'Sales Representative'


--(3) Write a query to get the top 5 product names whose quantity was ordered the most in January 1997
SELECT TOP 5 p.ProductName, 
	   SUM(od.Quantity) AS product_count
FROM Products AS p
JOIN [Order Details] AS od
  ON p.ProductID = od.ProductID
JOIN Orders AS o
  ON od.OrderID = o.OrderID
WHERE OrderDate BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY p.ProductName
ORDER BY SUM(od.Quantity) DESC


--(4) Write a query to get the name of the company that placed an order for Chai in June 1997
SELECT c.CompanyName AS Company_Name 
FROM Customers AS c
JOIN Orders AS o
  ON c.CustomerID = o.CustomerID
JOIN [Order Details] AS od
  ON o.OrderID = od.OrderID
JOIN Products AS p
  ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Chai' AND
	  OrderDate BETWEEN '1997-06-01' AND '1997-06-30'
ORDER BY c.CompanyName


--(5) Write a query to get the number of OrderIDs that have made purchases (unit_price times quantity) <=100, 100<x<=250, 250<x<=500, and >500.
WITH order_sales(OrderID, Sales) AS (
	SELECT OrderID,
		   SUM(UnitPrice* Quantity)
	FROM [Order Details]
	GROUP BY OrderID)
SELECT CASE WHEN Sales <= 100 THEN 'Sales <= 100'
			  WHEN Sales  BETWEEN 100 AND 250 THEN '100 < Sales <= 250'
			  WHEN Sales  BETWEEN 250 AND 500 THEN '250 < Sales <= 500'
			  WHEN Sales  >500 THEN 'Sales > 500'
		 END AS Category,
		 COUNT(OrderID) AS Count_Order
FROM order_sales
GROUP BY CASE WHEN Sales <= 100 THEN 'Sales <= 100'
			  WHEN Sales  BETWEEN 100 AND 250 THEN '100 < Sales <= 250'
			  WHEN Sales  BETWEEN 250 AND 500 THEN '250 < Sales <= 500'
			  WHEN Sales  >500 THEN 'Sales > 500'
		  END
ORDER BY COUNT(OrderID) DESC


--(6) Write a query to get the Company name in the customer table that made purchases above 500 in 1997
WITH customer_order_sales(OrderID, Sales) AS 
(
	 SELECT OrderID,
			SUM(UnitPrice * Quantity)
	 FROM [Order Details]
	 GROUP BY OrderID
)
SELECT DISTINCT CompanyName
FROM customer_order_sales AS  cs
JOIN Orders AS o ON cs.OrderID = o.OrderID
JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE (Sales>500) AND  YEAR(OrderDate) = 1997


--(7) Write a query to get the product name that is the Top 5 highest sales per month in 1997
WITH sales_product(Month, ProductName, Sales, Ranking) AS(
SELECT MONTH(o.OrderDate), 
	   p.ProductName,
	   SUM(od.Quantity * od.UnitPrice),
	   ROW_NUMBER() OVER (PARTITION by MONTH(o.OrderDate) ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) 
FROM [Order Details] AS od
JOIN Orders AS o 
  ON od.OrderID = o.OrderID
JOIN Products AS p
  ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY MONTH(o.OrderDate), p.ProductName 
)
SELECT *
FROM sales_product
WHERE Ranking <= 5
ORDER BY Month, Ranking


--(8) Create a view to view Order Details that contains OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Price after discount
CREATE VIEW Order_Details_Table (OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Discounted_Price)
AS 
	SELECT od.OrderID, 
		   od.ProductID, 
		   p.ProductName, 
		   od.UnitPrice,
		   od.Quantity, 
		   od.Discount, 
		   (1.0 - od.Discount) * od.UnitPrice
FROM [Order Details] AS od
JOIN Products AS p
ON od.ProductID = p.ProductID

--Checking the view
SELECT *
FROM Order_Details_Table


--(9) Create an Invoice procedure to call CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate if there is a specific CustomerID input
CREATE PROCEDURE GET_INVOICE(@CustomerID VARCHAR(10))
AS
BEGIN
	SELECT c.CustomerID, 
		   c.CompanyName, 
		   o.OrderID, 
		   o.OrderDate,
		   o.RequiredDate,
		   o.ShippedDate
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID = @CustomerID
END

-- Checking the procedure
EXECUTE GET_INVOICE FAMIA

EXECUTE GET_INVOICE WOLZA