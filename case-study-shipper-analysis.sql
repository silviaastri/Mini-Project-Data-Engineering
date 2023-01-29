WITH send_order (Month, ProductName, CompanyName, Total_Orders, Sales) AS(
SELECT  MONTH(o.ShippedDate),
		p.ProductName,
		sh.CompanyName,
		COUNT(DISTINCT o.OrderID),
		SUM(d.Quantity * d.UnitPrice)
FROM orders AS o
JOIN Shippers AS sh ON o.ShipVia = sh.ShipperID
JOIN [Order Details] AS d ON  o.OrderID = d.OrderID 
JOIN Products AS p ON d.ProductID = p.ProductID
GROUP BY MONTH(o.ShippedDate), p.ProductName, sh.CompanyName
)
SELECT CompanyName, SUM(Total_Orders) AS Total_Orders, SUM(Sales) AS Sum_of_Sales
FROM send_order
GROUP BY CompanyName
ORDER BY SUM(Total_Orders) DESC, SUM(Sales)