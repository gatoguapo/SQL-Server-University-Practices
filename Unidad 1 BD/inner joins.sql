USE Northwind
GO

--	1.-
SELECT o.OrderID, o.OrderDate, c.CompanyName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE DATEPART(yy, OrderDate) %3 = 0 AND DATENAME(mm, OrderDate) LIKE '%r%'

--	2.- 
SELECT o.OrderID, o.OrderDate, c.ContactName , DATENAME(dw, OrderDate), c.Address
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE DATEPART(dw, OrderDate) IN (2, 4, 6) AND Address LIKE 'Av%'

-- 3.- 
SELECT TOP 10 o.OrderID, o.OrderDate, e.EmployeeID, Nombre = e.FirstName + ' ' + e.Lastname, e.BirthDate
FROM Orders o
INNER JOIN Employees e On e.EmployeeID = o.EmployeeID
WHERE DATEPART(yy, o.OrderDate) = 1997 AND (DATEPART(yy, e.BirthDate) >= 1960 AND DATEPART(yy,e.BirthDate) <= 1969)
ORDER BY OrderDate DESC

--	4.-
SELECT	Empleado = e.FirstName + ' ' + e.LastName, Jefe = j.FirstName + ' ' + j.LastName
FROM Employees e
INNER JOIN Employees j ON e.ReportsTo = j.EmployeeID
WHERE e.FirstName LIKE '[aeiou]%' AND e.Region IS NOT NULL

--	5.-
SELECT p.ProductName, s.CompanyName, s.Phone, s.HomePage, c.CategoryName
FROM Products p
INNER JOIN Suppliers s On s.SupplierID = p.SupplierID
INNER JOIN Categories c On c.CategoryID = p.CategoryID
WHERE s.Phone LIKE '[045]%' AND s.HomePage IS NULL

--	6.- 
SELECT Empleado = e.FirstName + ' ' + e.LastName, t.TerritoryDescription
FROM Employees e
INNER JOIN EmployeeTerritories et ON et.EmployeeID = e.EmployeeID
INNER JOIN Territories t ON t.TerritoryID = et.TerritoryID
WHERE e.FirstName LIKE '[aeiou]$[aeiou]' AND t.TerritoryDescription LIKE '[aeiou]$[aeiou]'