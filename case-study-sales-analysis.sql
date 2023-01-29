--Trend of Sales July 1996 - May 1998
SELECT
	YEAR(o.OrderDate) AS Year,
	MONTH(o.OrderDate) AS Month,
	COUNT(DISTINCT d.OrderID) AS Sum_of_Customer,
	SUM(d.Quantity) AS Sum_of_Quantity,
	SUM(ROUND(d.UnitPrice * d.Quantity * (1-d.Discount),2)) AS Sales
FROM [Order Details] AS d
JOIN Orders AS o ON d.OrderID = o.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)

