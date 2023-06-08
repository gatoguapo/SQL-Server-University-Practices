USE Northwind
GO

--1 CONSULTA CON EL FOLIO, FECHA DE LA ORDEN, NOMBRE DE LA COMPAÑÍA DE ENVIO, MOSTRAR LOS REGISTROS CUYO AÑO SEA MULTIPLO DE 3 Y EL MES CONTENGA LA LETRA R.
SELECT Folio = OrderID, 'Fecha de la orden' = OrderDate, CompanyName AS [Nombre Compañia], Registros = DATEPART(YY,OrderDate)
FROM Orders O 
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE DATEPART(YY,OrderDate)%3 = 0 AND DATENAME(mm,OrderDate) LIKE '%R%'

--2 CONSULTA CON EL FOLIO DE LA ORDEN, FECHA Y NOMBRE DEL CLIENTE QUE SE HAYAN REALIZADO LOS DIAS LUNES, MIÉRCOLES Y VIERNES Y QUE EL CLIENTE VIVA EN UN AVENIDA.
SELECT Folio = OrderID, Fecha = OrderDate, ContactName AS 'Nombre Cliente', Dia = DATENAME(dw,OrderDate), Avenida = Address
FROM Orders O
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE DATENAME(dw,OrderDate) IN ('Monday','Wednesday','Friday') AND Address LIKE '%AV%'

--3 CONSULTA CON LAS PRIMERAS 10 ORDENES DE 1997 DEL EMPLEADO QUE NACIERON EN LA DECADA DE 1960.
SELECT TOP 10 Ordenes = OrderID, Year = DATEPART(yy,OrderDate), 'Empleado nacio en' = DATEPART(yy,BirthDate)
FROM Orders O
INNER JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE DATEPART(yy,OrderDate) = 1997 AND DATEPART(yy,BirthDate) = 1960
ORDER BY DATEPART(yy,OrderDate) DESC

--4 CONSULTA CON EL NOMBRE DEL EMPLEADOS Y NOMBRE DE SU JEFE, MOSTRAR LOS EMPLEADOS QUE SU NOMBRE INICIE CON VOCAL Y TENGAN UNA REGION ASIGNADA.
SELECT 'Nombre empleado' = (E.FirstName + ' ' + E.LastName), Jefe = (J.FirstName + ' ' + J.LastName), Region = E.Region
FROM Employees E
INNER JOIN Employees J
ON E.ReportsTo = J.EmployeeID
WHERE E.FirstName LIKE '[AEIOU]%' AND E.Region IS NOT NULL

--5 CONSULTA CON EL NOMBRE DEL PRODUCTO, NOMBRE DEL PROVEEDOR Y NOMBRE DE LA CATEGORIA. MOSTRAR SOLO LOS PROVEEDORES QUE SU TELEFONO INICIE CON 0,4 O 5 Y QUE NO TENGAN HOMEPAGE.
SELECT 'Nombre del producto' = P.ProductName, 'Nombre del proveedor' = S.ContactName, 
'Nombre de la categoria' = S.ContactTitle, 'Telefono proveedor' = S.Phone, HomePage = S.HomePage
FROM Products P
INNER JOIN Suppliers S
ON P.SupplierID = S.SupplierID
WHERE S.Phone LIKE '[0,4,5]%' AND S.HomePage IS NULL

--6 CONSULTA CON EL NOMBRE DEL EMPLEADO Y NOMBRE DEL TERRITORIO QUE ATIENDE. MOSTRAR SOLO LOS NOMBRE DE EMPLEADO Y TERRITORIOS QUE EMPIECEN Y TERMINEN CON VOCAL.
SELECT 'Nombre Empleado' = E.FirstName, 'Nombre Territorio' = T.TerritoryDescription
FROM Employees E
INNER JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories T
ON T.TerritoryID = ET.TerritoryID
WHERE (E.FirstName LIKE '%[AEIOU]' AND  E.FirstName LIKE '[AEIOU]%') AND (RTRIM(T.TerritoryDescription) LIKE '%[AEIOU]' AND RTRIM(T.TerritoryDescription) LIKE '[AEIOU]%')

--7 CONSULTA CON EL FOLIO DE LA ORDEN, MESES TRANSCURRIDOS DE LA ORDEN, NOMBRE DEL EMPLEADO QUE HIZO LA ORDEN. MOSTRAR SOLO LAS ORDENES DE LOS EMPLEADOS QUE VIVAN EN EL PAIS 
--“USA” Y QUE EL CODIGO POSTAL CONTENGA UN 2.
SELECT Folio = O.OrderID, CONVERT(nvarchar,DATEDIFF(mm,O.OrderDate,GETDATE())) AS [Meses transcurrido de la orden], 
CONVERT(nvarchar,E.FirstName + SPACE(1) + E.Lastname) AS [Nombre del empleado que hizo la orden]
FROM Employees E INNER JOIN Orders O
ON E.EmployeeID = O.EmployeeID
WHERE E.Country LIKE 'USA' AND E.PostalCode LIKE '%2%'

--8 CONSULTA CON EL FOLIO DE LA ORDEN, NOMBRE DEL PRODUCTO E IMPORTE DE VENTA. MOSTRAR SOLO LAS ORDENES DE LOS 
--PRODUCTOS CUYA CATEGERIA CONTENGA DOS VOCALES SEGUIDAS O QUE SU PENULTIMA LETRA SEA CONSONANTE.
SELECT Folio = O.OrderID, 'Nombre Producto' = P.ProductName, 'Importe de Venta' = OD.Quantity*OD.UnitPrice,
'Categorias' = C.CategoryName
FROM Orders O
INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
INNER JOIN Products P
ON P.ProductID = OD.ProductID
INNER JOIN Categories C
ON C.CategoryID = P.CategoryID
WHERE C.CategoryName LIKE '%[aeiou][aeiou]%' OR C.CategoryName LIKE '%[aeiou]_'

--9 CONSULTA CON EL NOMBRE DEL EMPLEADO, NOMBRE DEL TERRITORIO QUE ATIENDE. MOSTRAS SOLO LOS EMPLEADOS QUE EL TERRITORIO ESTE EN UNA REGION SU SEGUNDA LETRA SEA LA LETRA O.
SELECT 'Nombre Empleado' = E.FirstName, Territorio = T.TerritoryDescription, Regio = RegionDescription
FROM Employees E
INNER JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories T
ON ET.TerritoryID = T.TerritoryID
INNER JOIN Region R
ON R.RegionID = T.RegionID
WHERE R.RegionDescription LIKE '_o%'

--10 CONSULTA CON EL FOLIO DE LA ORDEN, FECHA DE LA ORDEN, NOMBRE DEL EMPLEADO, EDAD QUE TENIA EL EMPLEADO CUANDO HIZO LA ORDEN.
SELECT Folio = O.OrderID, Fecha = O.OrderDate, 'Nombre Empleado' = E.FirstName, 'Edad del Empleado cuando realizo la orden' = DATEDIFF(yy,E.BirthDate,O.OrderDate)
FROM Orders O
INNER JOIN Employees E
ON O.EmployeeID = E.EmployeeID