/*	U5 Tarea Procedimientos	*/
USE Northwind
GO

/*
	1.-	AGREGAR A LA TABLA PROVEEDORES EL CAMPO TOTALPIEZAS, EL CUAL REPRESENTARÁ EL 
		TOTAL DE PIEZAS VENDIDAS DE CADA PROVEEDOR. CREAR UN PROCEDIMIENTO ALMACENADO 
		QUE LLENE DICHO CAMPO
*/
ALTER TABLE Suppliers ADD TotalPiezas INT
GO

CREATE OR ALTER PROC SP_TotalPiezas AS
DECLARE @Piezas INT, @Min INT

SELECT @Min = MIN(SupplierID) FROM Suppliers
WHILE (@Min IS NOT NULL)
BEGIN
	SELECT @Piezas = SUM(Quantity) FROM [Order Details] od
	INNER JOIN Products p ON p.ProductID = od.ProductID
	WHERE @Min = SupplierID
	GROUP BY SupplierID
	UPDATE Suppliers SET TotalPiezas = @Piezas WHERE @Min = SupplierID

	SELECT @Min = MIN(SupplierID) FROM Suppliers WHERE SupplierID > @Min
END
GO

EXEC SP_TotalPiezas
SELECT SupplierID, TotalPiezas FROM Suppliers
GO


/*
	2.-	SP QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE POR RETORNO LA EDAD EXACTA DEL 
		EMPLEADO.
*/
CREATE OR ALTER PROC SP_RetornaEdad 
@EmpID INT, @Edad INT OUTPUT AS
DECLARE @Fecha DATETIME

BEGIN
	SELECT @Fecha = BirthDate FROM Employees WHERE EmployeeID = @EmpID
	SELECT @Edad = DATEDIFF(YY,@Fecha,GETDATE()) FROM Employees WHERE EmployeeID = @EmpID
	SELECT @Fecha = DATEADD(YY, @Edad, @Fecha)
	
	IF(@Fecha > GETDATE())
	BEGIN
		SELECT @Edad = @Edad - 1
	END

	RETURN @Edad
END
GO

DECLARE @EmpID INT
SELECT @EmpID = 1
DECLARE @Edad INT

EXEC SP_RetornaEdad @EmpID, @Edad OUTPUT
SELECT EmpID = @EmpID, Edad = @Edad
GO


/*
	3.-	PROCEDIMIENTO ALMACENADO QUE RECIBA COMO PARAMETRO UN AÑO Y REGRESE DOS 
		PARAMETROS: 
		-	UN PARAMETRO CON EL NOMBRE DE TODOS LOS CLIENTES QUE COMPRARON ESE AÑO.
		-	Y OTRO PARAMETRO CON LA LISTA DE LAS ORDENES REALIZADAS ESE AÑO.
*/
CREATE OR ALTER PROC SP_ClientesOrdenes @Año INT, @Clientes VARCHAR(MAX) OUTPUT, @Ordenes VARCHAR(MAX) OUTPUT AS
BEGIN
	SELECT @Clientes = STRING_AGG(c.CompanyName, ', ')
	FROM Customers c
	INNER JOIN Orders o ON o.CustomerID = c.CustomerID
	WHERE DATEPART(yy, OrderDate) = @Año

	SELECT @Ordenes = STRING_AGG(CONVERT(VARCHAR(10), OrderID), ', ')
	FROM Orders
	WHERE DATEPART(yy, OrderDate) = @Año
END
GO

DECLARE @Clientes VARCHAR(MAX), @Ordenes VARCHAR(MAX)
EXEC SP_ClientesOrdenes 1996, @Clientes OUTPUT, @Ordenes OUTPUT
SELECT 'Todos los Clientes' = @Clientes, 'Todos las Ordenes' = @Ordenes
GO


/*
	4.-	PROCEDIMIENTO ALMACENADO QUE REGRESE UNA TABLA CON LA FECHA Y LOS NOMBRES 
		DE LOS PRODUCTOS QUE SE COMPRARON ESE DÍA.
*/
CREATE OR ALTER PROC SP_TablaFechaProductos AS
DECLARE @Fecha DATETIME, @Productos VARCHAR(MAX)
CREATE TABLE #Tabla (Fecha DATETIME, Productos VARCHAR(MAX))
BEGIN
	SELECT  @Fecha = MIN(OrderDate) FROM Orders
	WHILE (@Fecha IS NOT NULL)
	BEGIN
		SELECT @Productos = STRING_AGG(p.ProductName, ', ')
		FROM Products p
		INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
		INNER JOIN Orders o ON o.OrderID = od.OrderID
		WHERE o.OrderDate = @Fecha

		INSERT #Tabla VALUES(@Fecha, @Productos)
		SELECT @Fecha = MIN(OrderDate) FROM Orders WHERE OrderDate > @Fecha
	END
	SELECT * FROM #Tabla
	DROP TABLE #Tabla
END
GO

EXEC SP_TablaFechaProductos
GO


/*
	5.-	SP QUE RECIBA UN AÑO Y REGRESE COMO PARAMETRO DE SALIDA LA CLAVE DEL ARTICULO
		QUE MAS SE VENDIO ESE AÑO Y CANTIDAD DE PIEZAS VENDIDAS DE ESE PRODUCTO EN ESE
		AÑO.
*/
CREATE OR ALTER PROC SP_ClaveProductoMasVendido @Año INT, @ClaveProducto INT OUTPUT, @PiezasVendidas INT OUTPUT AS
BEGIN
    SELECT TOP 1 @ClaveProducto = od.ProductID, @PiezasVendidas = SUM(od.Quantity)
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE DATEPART(YEAR, o.OrderDate) = @Año
    GROUP BY od.ProductID
    ORDER BY SUM(od.Quantity) DESC

    IF (@ClaveProducto IS NULL)
    BEGIN
        SET @PiezasVendidas = 0
    END
END
GO

DECLARE @Año INT
SELECT @Año = 1996
DECLARE @ClaveProducto INT, @PiezasVendidas INT
EXEC SP_ClaveProductoMasVendido 1997, @ClaveProducto OUTPUT, @PiezasVendidas OUTPUT
SELECT Año = @Año, 'Clave del Articulo más vendido' = @ClaveProducto, 'Piezas Vendidas' = @PiezasVendidas
GO

/*
	6.-	FUNCION DE TABLA DE MULTISENTENCIA QUE RECIBA UN AÑO COMO PARAMETRO DE
		ENTRADA, QUE REGRESE UNA TABLA CON DOS COLUMNAS: MES, FOLIOS QUE SE VENDIERON
		ESE MES. NOTA: MOSTRAR TODOS LOS MESES.
*/
CREATE OR ALTER FUNCTION dbo.VentasMeses (@Año INT)
RETURNS @VentasMeses TABLE (Mes NVARCHAR(50), Folios VARCHAR(MAX))
AS
BEGIN
    DECLARE @Mes INT = 1
	DECLARE @MesNom VARCHAR(50)
	DECLARE @Ordenes NVARCHAR(MAX)
    
    WHILE (@Mes <= 12)
    BEGIN
		SELECT @MesNom = DATENAME(mm, DATEFROMPARTS(@Año, @Mes, 1))
		SELECT @Ordenes = STRING_AGG(CONVERT(VARCHAR(10), OrderID), ', ')
		FROM Orders
		WHERE DATEPART(YY, OrderDate) = @Año AND DATEPART(MM, OrderDate) = @Mes

		INSERT INTO @VentasMeses(Mes, Folios)
		VALUES(@MesNom, @Ordenes)
        
        SET @Mes += 1
    END

    RETURN
END
GO

SELECT * FROM dbo.VentasMeses (1996)
GO


 /*
	7.-	SP QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE COMO PARAMETRO DE SALIDA TODOS
		LOS NOMBRES DE LOS TERRITORIOS QUE ATIENDEN EL EMPLEADO.
 */
CREATE OR ALTER PROC SP_EmpleadoTerritorios @EmpID INT, @Territorios VARCHAR(MAX) OUTPUT AS
BEGIN
	--	Se utiliza el RTRIM para eliminar un espacio grande que deja al utilizar el STRING_AGG
	SELECT @Territorios = STRING_AGG(RTRIM(t.TerritoryDescription), ', ')
    FROM Territories t
    INNER JOIN EmployeeTerritories et ON et.TerritoryID = t.TerritoryID
    WHERE et.EmployeeID = @EmpID
END
GO

DECLARE @EmpID INT
SELECT @EmpID = 1
DECLARE @Territorios VARCHAR(MAX)
EXEC SP_EmpleadoTerritorios @EmpID, @Territorios OUTPUT
SELECT Empleado = @EmpID, 'Terriotorios que atiende' = @Territorios
GO


/*
	8.-	SP QUE REALICE UN PROCESO DONDE REGRESE LA SIGUIENTE TABLA:
		"NOMBRE DE JEFES" SERÁ LA CADENA CON TODOS LOS NOMBRE DE LOS JEFES QUE TIENE EL
		EMPLEADO. “Jefe Superior” ES EL JEFE QUE SE ENCUENTRA EN LA RAIZ DEL ARBOL DE
		EMPLEADOS.
*/
CREATE OR ALTER PROC SP_EmpJefeJefeSup AS
DECLARE @EmpID INT, @EmpNom NVARCHAR(50), @JefeID INT, @JefeNom NVARCHAR(50), @Jefes NVARCHAR(MAX), @JefeSup NVARCHAR(50)
CREATE TABLE #Tabla (Empleado NVARCHAR(50), Jefes NVARCHAR(MAX), JefeSuperior NVARCHAR(50))
BEGIN
	SELECT @EmpID = MIN(EmployeeID) FROM Employees
	WHILE @EmpID IS NOT NULL
	BEGIN
		SELECT @EmpNom = FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = @EmpID
		SELECT @Jefes = ''
		SELECT @JefeID = ReportsTo FROM Employees WHERE EmployeeID = @EmpID

		WHILE @JefeID IS NOT NULL
		BEGIN
			SELECT @JefeNom = FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = @JefeID
			SELECT @Jefes = @Jefes + @JefeNom + ', '
			SELECT @JefeID = ReportsTo FROM Employees WHERE EmployeeID = @JefeID
			SELECT @JefeSup = @JefeNom
		END
       
		IF LEN(@Jefes) > 0
		BEGIN
			SET @Jefes = SUBSTRING(@Jefes, 1, LEN(@Jefes) - 1)
		END

		INSERT #Tabla VALUES(@EmpNom, @Jefes, @JefeSup)
		SELECT @EmpID = MIN(EmployeeID) FROM Employees WHERE EmployeeID > @EmpID
	END
END

SELECT * FROM #Tabla
DROP TABLE #Tabla
GO

EXEC SP_EmpJefeJefeSup
GO


/*
	9.-	PROCEDIMIENTO ALMACENADO QUE RECIBA EL NOMBRE DE UNA TABLA Y QUE EL
		PROCEDIMIENTO IMPRIMA EL CODIGO DE CREACIÓN DE DICHA TABLA.
*/
CREATE OR ALTER PROC SP_CodigoTabla @Tabla varchar(50) AS
BEGIN
    DECLARE @Query varchar(max) = 'CREATE TABLE ' + @Tabla + ' (' + CHAR(13)
    
    SELECT @Query += col.name + ' ' + typ.name + 
        (CASE WHEN typ.name IN ('NVARCHAR', 'VARCHAR', 'CHAR') THEN '(' + CONVERT(varchar, col.length) + ')'
			  WHEN typ.name = 'NUMERIC' THEN '(' + CONVERT(varchar, col.prec) + ',' + CONVERT(varchar, col.scale) + ')' 
			  ELSE '' END) +
        (CASE WHEN col.isnullable = 0 THEN ' NOT NULL' ELSE '' END) + ',' + CHAR(13)
    FROM SYSCOLUMNS col
    INNER JOIN SYSTYPES typ ON col.xtype = typ.xtype
    WHERE col.id = OBJECT_ID(@Tabla)
    AND typ.name NOT LIKE 'SYSNAME'
    ORDER BY col.id
    
    SELECT @Query = LEFT(@Query, LEN(@Query) - 2) + CHAR(13) + ')'
    
    PRINT @Query
END
GO

EXEC sp_CodigoTabla 'Employees'
GO


/*
	10.-	PROCEDIMIENTO ALMACENADO QUE AUMENTE EL PRECIO DE LOS PRODUCTOS UN 10% SI
			SE HAN VENDIDO MENOS DE UN IMPORTE DE $2,000, 25% ENTRE $2,001 Y $3,000, 30% MAS DE UN
			IMPORTE DE $3,000.
*/
CREATE OR ALTER PROC SP_AumentaPrecio AS
DECLARE @VentaTotal Numeric(10,2)
BEGIN
	SELECT p.ProductID, p.ProductName, Precio = p.UnitPrice, VentaTotal = SUM(od.Quantity * p.UnitPrice)
	INTO #VentasPorProducto
	FROM Products p
	INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
	GROUP BY p.ProductID, p.ProductName, p.UnitPrice

	SELECT @VentaTotal = VentaTotal FROM #VentasPorProducto

	IF(@VentaTotal < 2000)
	BEGIN
		UPDATE Products
		SET UnitPrice = UnitPrice * 1.1
		FROM #VentasPorProducto
		WHERE VentaTotal < 2000 AND Products.ProductID = #VentasPorProducto.ProductID
	PRINT 'Se aumento un 10%'
	END

	IF(@VentaTotal > 2000 AND @VentaTotal <= 3000)
	BEGIN
		UPDATE Products
		SET UnitPrice = UnitPrice * 1.25
		FROM #VentasPorProducto
		WHERE VentaTotal >= 2001 AND VentaTotal <= 3000 AND Products.ProductID = #VentasPorProducto.ProductID
		PRINT 'Se aumento un 25%'
	END

	IF(@VentaTotal > 3000)
	BEGIN
		UPDATE Products
		SET UnitPrice = UnitPrice * 1.3
		FROM #VentasPorProducto
		WHERE VentaTotal > 3000 AND Products.ProductID = #VentasPorProducto.ProductID
		PRINT 'Se aumento un 30%'
	END

	SELECT * FROM #VentasPorProducto
	ORDER BY ProductID
    DROP TABLE #VentasPorProducto
END
GO

SELECT p.ProductID, p.ProductName, Precio = p.UnitPrice, VentaTotal = SUM(od.Quantity * p.UnitPrice)
FROM Products p
INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.UnitPrice

EXEC SP_AumentaPrecio
GO