USE Northwind
GO

--1 Mostrar el nombre completo del empleado imprimiendo el nombre en un renglon y el apellido en otro
SELECT FirstName, LastName
FROM Employees

--2 Mostrar los empleados que entraron a trabajar cuando tenían entre 30 y 50 años
SELECT  Edad = DATEDIFF(yy,BirthDate,HireDate), *
FROM Employees
WHERE DATEDIFF(yy,BirthDate,HireDate) BETWEEN 30 AND 50

--3 Consulta con el nombre del empleado un texto de la siguiente forma cada empleado:
SELECT FirstName + CHAR(32) + SPACE(1) + LastName + ' entro a trabajar un ' + 
DATENAME(dw,HireDate) + ' ' +DATENAME(dd,HireDate) + ' de ' +
DATENAME(mm,HireDate) + ' de ' + CONVERT(CHAR(4),DATEPART(yy,HireDate)) + ' con una edad de ' +
CONVERT(CHAR(2),DATEDIFF(yy,BirthDate,HireDate)) + ' años'
FROM Employees

--4 Consulta con la clave y fecha de la orden que se hayan realizado los días lunes del primer semestre de todos los años.
SELECT Clave = EmployeeID, (DATENAME(dw,ORDERDATE) + SPACE(1) + DATENAME(dd,ORDERDATE) + SPACE(1) + 
DATENAME(mm,ORDERDATE) + SPACE(1) + DATENAME(yy,ORDERDATE)) as [Fecha de la orden]
FROM Orders
WHERE DATENAME(dw,ORDERDATE) LIKE 'Monday' AND (DATEPART(mm,ORDERDATE) <= 6)

--5 Consulta con las clave de la orden y fecha de la orden. mostrar solamente las ordenes que se hayan realizadas los días viernes por los empleados 1,3 y 5.
SELECT OrderID, OrderDate
FROM Orders
WHERE DATENAME(dw,OrderDate) LIKE 'Friday' and EmployeeID IN (1,3,5)

--6 Mostrar en una sola columna la siguiente información de cada orden : 'la orden 1 fue realizada por el cliente ANTON y atendida por el empleado 1’
SELECT 'La orden '+CONVERT(nvarchar,O.OrderID)+ SPACE(2) + 'fue realizada por el cliente '+ C.ContactName + ' y atendida por el empleado ' + CONVERT(nvarchar,O.EmployeeID)
FROM Customers C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID

--7 consulta con los clientes cuyo nombre empiece con consonante y sea mayor a 10 caracteres.
SELECT ContactName
FROM Customers
WHERE ContactName LIKE '[^aeiou]%' AND LEN(ContactName) >= 10
--8 consulta con los productos que su nombre empiece con A,B, N y termine con N
SELECT ProductName
FROM Products
WHERE ProductName LIKE '[ABN]%N'

--9 consulta con los empleados que su nombre y apellido termine con consonante.
SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE '%[^AEIOU]' AND LastName LIKE '%[^AEIOU]'

--10 consulta con todas las ordenes que se hayan realizado en los meses que inician con vocal.
SELECT *
FROM Orders
WHERE DATENAME(mm,OrderDate) LIKE '[AEIOU]%'

--11 consulta con los nombres de producto que tengan solamente 3 vocales.
SELECT ProductName
FROM Products
WHERE LEN(ProductName) - LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ProductName,'a',''),'e',''),'i',''),'o',''),'u','')) = 3

--12 consulta con las fechas de las ordenes cuyo año sea multiplo de 3.
SELECT OrderDate
FROM Orders
WHERE DATEPART(yy,OrderDate)%3 = 0

--13 consulta con las ordenes que se hayan realizado en sábado y domingo, y que hayan sido realizadas por los empleados 1,2 y 5.
SELECT OrderID, 'Day' = DAY(OrderDate), EmployeeID
FROM Orders
WHERE DATEPART(dw,OrderDate) IN (1,7) AND EmployeeID IN (1,2,5)

--14 consulta con las ordenes que no tengan compañía de envío o que se hayan realizado en el mes de enero.
SELECT O.OrderID, C.CompanyName, MONTH(O.OrderDate) AS [Month]
FROM Orders O
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE C.CompanyName IS NULL OR MONTH(O.OrderDate) = 1

--15 consulta con las 10 últimas ordenes de 1997.
SELECT TOP 10 OrderID, 'Year' = YEAR(OrderDate)
FROM Orders
WHERE YEAR(OrderDate) = 1997
ORDER BY OrderDate DESC

--16 consulta con los 10 productos más caros del proveedor 1, 2 y 5.
SELECT TOP 10 UnitPrice, SupplierID
FROM Products
WHERE SupplierID IN (1,2,5)
ORDER BY UnitPrice DESC

--17 consulta con los 4 empleados con mas antigüedad.
SELECT TOP 4 EmployeeID, FirstName, LastName, 'Antiguedad' = HireDate
FROM Employees
ORDER BY DATEDIFF(yy,HireDate,GETDATE()) DESC

--18 consulta con empleado con una antigüedad de 10,20 o 30 años y con una edad mayor a 30, o con los empleados que vivan en un blvd y no tengan una región asignada.
SELECT EmployeeID, FirstName, LastName, Antiguedad = DATEDIFF(yy,HireDate,GETDATE()), Edad = DATEDIFF(yy,BirthDate,HireDate), Address, Region
FROM Employees
WHERE (DATEDIFF(yy,HireDate,GETDATE()) IN (10,20,30) AND DATEDIFF(yy,BirthDate,HireDate) > 30) OR (Address IS NOT NULL AND Region IS NULL)

--19 consulta con las ordenes el código postal de envío tenga solamente letras.
SELECT OrderID, ShipPostalCode
FROM Orders
WHERE ShipPostalCode NOT LIKE '%[0,1,2,3,4,5,6,7,8,9,-]%'

--20 consulta con las ordenes que se hayan realizado en 1996 y en los meses que contengan la letra R.
SELECT OrderID, Year = YEAR(OrderDate), Months = DATENAME(mm,OrderDate)
FROM Orders
WHERE YEAR(OrderDate) = 1996 AND DATENAME(mm,OrderDate) LIKE '%R%'