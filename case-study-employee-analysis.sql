use Northwind

WITH employee_order AS (
SELECT  CONCAT(e.FirstName, ' ',e.LastName) AS employee_name,
		e.Title AS employee_title,
		COUNT(DISTINCT d.OrderID) AS total_orders,
		SUM(ROUND(d.UnitPrice * d.Quantity * (1-d.Discount),2)) AS total_amount
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] AS d ON o.OrderID = d.OrderID
GROUP BY CONCAT(e.FirstName, ' ',e.LastName), e.Title
)
SELECT  *, 
		100 * total_amount / (SELECT SUM(total_amount) FROM employee_order) AS '%_total_amount'
FROM employee_order
ORDER BY total_amount DESC