/*	GROUP BY	*/
USE Northwind
GO

--	GROUP BY
SELECT ProductName, CategoryName, CompanyName
FROM vw_products
GROUP BY CompanyName
GO

--	Primero agrupamos por nombre del proveedor
SELECT CompanyName
FROM VW_Products
GROUP BY CompanyName	--	Busca los proveedores distintos
GO

SELECT ProductName, CategoryName, CompanyName
FROM vw_products
GROUP BY CategoryName
GO

SELECT CategoryName
FROM VW_Products
GROUP BY CategoryName	--	Busca las categorias distintas
GO



SELECT * FROM VW_Products
GO

--	Total de productos
SELECT COUNT(*) FROM VW_Products

--	Suma de todos los precios de los productos
SELECT SUM(Unitprice) FROM Products
SELECT UnitPrice FROM Products

--	Clave maxima de productos
SELECT MAX(ProductID) FROM VW_Products

--	Clave minima de productos
SELECT MIN(ProductID) FROM VW_Products

--	Fecha mas grande de ordenes
SELECT MAX(OrderDate) FROM Orders

--	Fecha mas pequeña de ordenes
SELECT MIN(OrderDate) FROM Orders



--	Consulta con el nombre del proveedor 
SELECT ProductName, CategoryName, CompanyName
FROM VW_Products
ORDER BY CompanyName
GO

--	Primero agrupamos por nombre el proveedor
SELECT CompanyName
FROM VW_Products
ORDER BY CompanyName	--	Busca los proveedores distintos
GO

--	Ahora se aplica la funcion count sobre el group by
SELECT CompanyName, Total = COUNT(*)
FROM VW_Products
GROUP BY CompanyName
GO

--	Consulta con el nombre de la categoria y cuantos productos contiene
SELECT ProductName, CategoryName, CompanyName
FROM vw_products
ORDER BY categoryname
GO

SELECT CategoryName
FROM vw_products
GROUP BY categoryname
GO

SELECT categoryname, total = COUNT(*)
FROM vw_products
GROUP BY categoryname
GO



--	Consulta con el nombre del producto y total de piezas vendidas
SELECT orderid, productname, quantity, od_unitprice
FROM vw_orderdetails
ORDER BY productname
GO

-- Muestra los productos distintos
SELECT productname, Piezas = SUM(quantity)
FROM vw_orderdetails
GROUP BY productname
GO



--	Consulta con el folio de la orden y el importe total de la venta
SELECT OrderID, ProductName, Quantity, od_unitprice
FROM vw_orderdetails
GO

--	Muestra las ordenes distintas 
SELECT OrderID
FROM vw_orderdetails
GROUP BY OrderID
GO

SELECT OrderID, Importe = SUM(Quantity * od_unitprice)
FROM vw_orderdetails
GROUP BY OrderID	--	Muestra las ordenes distintas
GO



--	Consulta con el nombre de la categoria y total de productos que surte
--	Mostrar solo las categorias que tengan menos de 10 productos

--	Marca Error, no se permiten funciones de agregado en el WHERE
SELECT CategoryName, Total = COUNT(*)
FROM vw_products
WHERE COUNT(*)<10
GROUP BY CategoryName
GO

--	Es necesario incluir la funcion de agregado en la clausula HAVING
SELECT CategoryName, Total = COUNT(*)
FROM vw_products
GROUP BY categoryname
HAVING COUNT(*)<10
GO



--	Consulta con el nombre del proveedor y total de productos que surte.
--	Mostrar solo los proveedores que su nombre empiece con m, n,
--	Y que surtan entre 1 y 3 products
SELECT CompanyName , Total = COUNT(*)
FROM vw_products
WHERE companyname LIKE '[mn]%'
GROUP BY companyname
HAVING COUNT(*) BETWEEN 1 AND 3
ORDER BY COUNT(*) ASC
GO


--	Consulta con el nombre del cliente, total de ordenes realizadas e importe total de ventas,
--	Mostrar solo los clientes con un importe mayor a 10,000
SELECT orderid, nomcliente = cusContactName, productname, quantity, od_unitprice
FROM vw_orderdetails
ORDER BY nomcliente

SELECT nomcliente = cusContactName, mal = COUNT(*), correcto = COUNT(DISTINCT OrderID)
FROM vw_orderdetails
GROUP BY cusContactName 
GO

SELECT cusContactName, mal = COUNT(*), correcto = COUNT(DISTINCT OrderID), imp = sum(quantity+od_unitprice)
FROM vw_orderdetails
GROUP BY cusContactName
HAVING SUM(quantity * od_unitprice) > 10000
ORDER BY SUM(quantity * od_unitprice) DESC
GO



--	Consulta con el nombre del cliente, el importe total de ventas,
--	importe de 1996, importe 1997 e importe 1998
SELECT cusContactName, total = sum(quantity * od_unitprice)
FROM vw_orderdetails
GROUP BY cusContactName
GO

--	Estructure de CASE WHEN
CASE WHEN Condicion THEN "Verdadero" ELSE "Falso" END

CASE WHEN Condicion THEN
	"Verdadero"
ELSE
	"Falso"
END
GO

SELECT cusContactName,
TOTAL = SUM (Quantity * od_unitprice),
TOTAL96 = SUM(CASE WHEN YEAR(OrderDate) = 1996 THEN quantity * od_unitprice ELSE 0 END),
TOTAL97 = SUM(CASE WHEN YEAR(OrderDate) = 1997 THEN quantity * od_unitprice ELSE 0 END),
TOTAL98 = SUM(CASE WHEN YEAR(OrderDate) = 1998 THEN quantity * od_unitprice ELSE 0 END)
FROM VW_Orderdetails
GROUP BY cusContactName
GO

SELECT * FROM Customers
GO

--	La consulta anteorior no meustra todo los clientes, modificar la consulta para que los muestre
SELECT c.ContactName, ImporteTotal =  ISNULL(sum(quantity*od_unitprice),0),
TOTAL = SUM (Quantity * od_unitprice),
TOTAL96 = SUM(CASE WHEN YEAR(OrderDate) = 1996 THEN quantity * od_unitprice ELSE 0 END),
TOTAL97 = SUM(CASE WHEN YEAR(OrderDate) = 1997 THEN quantity * od_unitprice ELSE 0 END),
TOTAL98 = SUM(CASE WHEN YEAR(OrderDate) = 1998 THEN quantity * od_unitprice ELSE 0 END)
FROM Customers c
LEFT OUTER JOIN vw_orderdetails d ON c.CustomerID = d.CustomerID
GROUP BY c.ContactName
GO



--	Consulta con el nombre del cliente, el importe total de ventas, importe de 1996 e importe 1998

--	Metodo 2, Con vistas
CREATE VIEW VW_cte96 AS
SELECT FirstName, T96 = SUM(Quantity * od_unitprice)
FROM vw_orderdetails
WHERE YEAR(OrderDate) = 1996
GROUP BY FirstName
GO

CREATE VIEW VW_cte97 AS
SELECT FirstName, T97 = SUM(Quantity * od_unitprice)
FROM vw_orderdetails
WHERE YEAR(OrderDate) = 1997
GROUP BY FirstName
GO

CREATE VIEW VW_cte98 AS
SELECT FirstName, T98 = SUM(Quantity * od_unitprice)
FROM vw_orderdetails
WHERE YEAR(OrderDate) = 1998
GROUP BY FirstName
GO

--	No muestra todos los clientes
SELECT a.firstname, a.T96, b.t97, c.t98
FROM VW_cte96
INNER JOIN VW_cte97 b ON b.FirstName = a.firstname
INNER JOIN VW_cte98 c ON c.FirstName = a.firstname

--	Muestra todos los clientes
SELECT c.companyname, t96 = ISNULL(A.t96, 0), t97 = ISNULL(b.t97, 0), t98 = ISNULL(d.t98, 0)
FROM Customers c
LEFT OUTER JOIN VW_cte96 a ON a.FirstName = c.CompanyName
LEFT OUTER JOIN VW_cte97 b ON b.FirstName = c.CompanyName
LEFT OUTER JOIN VW_cte98 d ON d.FirstName = c.CompanyName
GO

--	Consulta con el año, importe total de ventas, importe total de ventas por dia de la semana
SELECT	Año			= YEAR(orderdate), imp = sum(quantity * od_unitprice),
		Lunes		= SUM(CASE WHEN DATEPART(dw, OrderDate) = 2 THEN quantity * od_unitprice END),
		Martes		= SUM(CASE WHEN DATEPART(dw, OrderDate) = 3 THEN quantity * od_unitprice END),
		Miercoles	= SUM(CASE WHEN DATEPART(dw, OrderDate) = 4 THEN quantity * od_unitprice END),
		Jueves		= SUM(CASE WHEN DATEPART(dw, OrderDate) = 5 THEN quantity * od_unitprice END),
		Viernes		= SUM(CASE WHEN DATEPART(dw, OrderDate) = 6 THEN quantity * od_unitprice END)
FROM vw_orderdetails
GROUP BY YEAR(orderdate)
GO

--	Realizar la traspuesta de la consulta anterior
SELECT	Dia = DATENAME(dw, orderdate),
T96 = SUM(CASE WHEN YEAR(OrderDate) = 1996 THEN quantity * od_unitprice END),
T97 = SUM(CASE WHEN YEAR(OrderDate) = 1996 THEN quantity * od_unitprice END),
T98 = SUM(CASE WHEN YEAR(OrderDate) = 1996 THEN quantity * od_unitprice END)
FROM vw_orderdetails
GROUP BY DATENAME(dw, OrderDate)
GO