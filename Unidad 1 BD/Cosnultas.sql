--	1.-  
SELECT Nombre = FirstName, Apellido = LastName
FROM Employees

--	2.-
SELECT * 
FROM Employees
WHERE DATEDIFF(yy, BirthDate, HireDate) BETWEEN 30 AND 50 

--	3.- 
SELECT	FirstName + CHAR(32) + LastName + ' entro a trabajar un ' + DATENAME(dd, HireDate) +
		' de ' + DATENAME(mm, HireDate) + ' de ' + CONVERT(CHAR(4), DATENAME(yy, HireDate)) + 
		' con una edad de ' + CONVERT(CHAR(4), DATEDIFF(yy, BirthDate, HireDate)) + ' años.'
FROM Employees

--	4.- 
SELECT Clave = OrderID, Fecha = OrderDate, Dia = DATENAME(dw, OrderDate)
FROM Orders 
WHERE DATEPART(dw, OrderDate) = 2 AND DATEPART(mm, OrderDate) <= 6

-- 5.-
SELECT	Clave = OrderID, Fecha = OrderDate, Dia = DATENAME(dw, OrderDate),
		Empleado = EmployeeID
FROM Orders
WHERE DATEPART(dw, OrderDate) = 6 AND EmployeeID IN (1, 3, 5)

-- 6.- 
SELECT	'La orden ' + CONVERT(CHAR(5), o.OrderID) + ' fue realizado por el cliente ' +
		c.ContactName + ' y atendido por el empleado ' + CONVERT(CHAR(1), o.EmployeeID)
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID

--	7.- 
SELECT ContactName
FROM Customers
WHERE ContactName NOT LIKE '[aeiou]%' AND LEN(ContactName) > 10

--	8.- 
SELECT ProductName
FROM Products
WHERE ProductName LIKE '[ABN]%N'

--	9.-
SELECT FirstName, LastName
FROM Employees
WHERE FirstName NOT LIKE '%[aeiou]' AND LastName NOT LIKE '%[aeiou]'

-- 10.- 
SELECT Mes = DATENAME(mm, OrderDate), *
FROM Orders
WHERE DATENAME(mm, OrderDate) LIKE '[aeiou]%'

-- 11.- 
SELECT ProductName
FROM Products
WHERE LEN(ProductName) - LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ProductName,'a',''),'e',''),'i',''),'o',''),'u','')) = 3

-- 12.- 
SELECT OrderDate
FROM Orders
WHERE DATEPART(yy, OrderDate) % 3 = 0

-- 13.-
SELECT *
FROM Orders
WHERE DATEPART(dw, OrderDate) IN (7, 1) AND EmployeeID IN (1, 2, 5)

--	14.-
SELECT *
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.CompanyName IS NULL OR DATEPART(mm, o.OrderDate) = 1

--	15.-
SELECT TOP 10 *
FROM Orders
WHERE DATEPART(yy, OrderDate) = 1997
ORDER BY OrderDate DESC

-- 16.- 
SELECT TOP 10 *
FROM Products
WHERE SupplierID IN (1, 2, 5)
ORDER BY UnitPrice DESC

--	17.-
SELECT TOP 4 'Antiguedad' = DATEDIFF(yy, BirthDate, HireDate), *
FROM Employees
ORDER BY 'Antiguedad' DESC

--	18.-
SELECT Edad = DATEDIFF(yy, BirthDate, GETDATE()), *
FROM Employees
WHERE (DATEDIFF(yy, BirthDate, HireDate) IN (10, 20, 30) AND DATEDIFF(yy, BirthDate, HireDate) >= 30)
OR (Address LIKE '%[blvd]%' AND Region IS NULL)

--	19.-
SELECT ShipPostalCode
FROM Orders
WHERE ShipPostalCode NOT LIKE '%[0-9]%'

--	20.-
SELECT *
FROM Orders
WHERE DATEPART(yy, OrderDate) = 1996 AND DATENAME(mm, OrderDate) LIKE '%[Rr]%'