/*	U5 Tarea funciones	*/
USE Northwind
GO

/*
	1.-	FUNCION ESCALAR QUE RECIBA DOS CLAVES DE CLIENTES,UN AÑO Y UN MES, Y REGRESE EL NOMBRE DEL 
		CLIENTE QUE MAS HA VENDIDO PIEZAS DE LOS DOS EN ESE AÑO-MES Y EL TOTAL DE PIEZAS VENDIDAS. 
		POR EJEMPLO, DEBE REGRESAR: EL CLIENTE JUAN PEREZ VENDIO 450 PIEZAS.
*/
create or alter function dbo.fn_mejor_vendedor (@clave1 int, @clave2 int, @year int, @mes int)
returns nvarchar(50)
as
begin
	declare @mejorVendedor nvarchar(50), @totalPiezas1 int, @totalPiezas2 int, @resultado nvarchar(50)

	select @totalPiezas1 = sum(od.quantity) from [Order Details] od
	inner join Orders o on od.OrderID = o.OrderID
	inner join Employees e on e.EmployeeID = o.EmployeeID
	where datepart(yy,o.OrderDate) = @year 
	and datepart(mm,o.OrderDate) = @mes
	and e.EmployeeID = @clave1
	group by e.EmployeeID, datepart(yy,o.OrderDate), datepart(mm,o.OrderDate)

	select @totalPiezas2 = sum(od.quantity) from [Order Details] od
	inner join Orders o on od.OrderID = o.OrderID
	inner join Employees e on e.EmployeeID = o.EmployeeID
	where datepart(yy,o.OrderDate) = @year 
	and datepart(mm,o.OrderDate) = @mes
	and e.EmployeeID = @clave2
	group by e.EmployeeID, datepart(yy,o.OrderDate), datepart(mm,o.OrderDate)

	if (@totalPiezas2 > @totalPiezas1)
	begin
		select @mejorVendedor = Concat(FirstName,' ',LastName) from Employees where EmployeeID = @clave2
		select @resultado = 'El Empleado '+@mejorVendedor+' vendio '+convert(nvarchar, @totalPiezas2)
		return @resultado
	end

	select @mejorVendedor = Concat(FirstName,' ',LastName) from Employees where EmployeeID = @clave1
	select @resultado = 'El Empleado '+@mejorVendedor+' vendio '+convert(nvarchar, @totalPiezas1)+ ' piezas'
	return @resultado
end
go

--Ejecucion
select dbo.fn_mejor_vendedor(1,2,1996,7)

--Comprobacion
select e.FirstName, sum(od.quantity), DATEPART(yy, o.OrderDate), DATEPART(mm, o.OrderDate) from [Order Details] od
	inner join Orders o on od.OrderID = o.OrderID
	inner join Employees e on e.EmployeeID = o.EmployeeID
	where (DATEPART(yy, o.OrderDate) = 1996 and DATEPART(mm, o.OrderDate) = 7)
	and (e.EmployeeID = 1 or e.EmployeeID = 2)
	group by e.FirstName, DATEPART(yy, o.OrderDate), DATEPART(mm, o.OrderDate)
	order by DATEPART(yy, o.OrderDate), DATEPART(mm, o.OrderDate)
go


/*
	2.-	FUNCION ESCALAR QUE RECIBA LA CLAVE DEL TERRITORIO Y REGRESE UNA 
		CADENA CON LOS NOMBRES DE LOS EMPLEADOS QUE SURTEN DICHO TERRITORIO.
*/
create or alter function dbo.fn_empleados_territorios (@TerrID int)
returns nvarchar(50)
as
begin
	declare @empleados nvarchar(max)
	select @empleados = string_agg(CONCAT(e.FirstName, ' ', e.LastName), ', ') from Employees e
	inner join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
	where et.TerritoryID = @TerrID

	return @empleados
end
go

select dbo.fn_empleados_territorios(06897)
go


/*
	3.-	FUNCION DE TABLA EN LINEA QUE RECIBA LA CLAVE DE UN PROVEEDOR Y REGRESEUNA 
		TABLA CON EL NOMBRE DE TODOS LOS PRODUCTOS QUE HA VENDIDO ESE PROVEEDOR,
		EL TOTAL DE PRODUCTOS VENDIDOS Y EL TOTAL DE ORDENES EN LAS QUE SE HAN VENDIDO.
*/
create or alter function dbo.fn_proveedor_total_productos_ordenes (@clave int)
returns table
as
return 
(
	select Producto = P.ProductName, TotalVendidos = sum(od.Quantity), TotalOrdenes = count(distinct o.OrderID) from Suppliers s	
	inner join Products p on p.SupplierID = s.SupplierID
	inner join [Order Details] od on od.ProductID = p.ProductID
	inner join Orders o on o.OrderID = od.OrderID 
	where s.SupplierID = @clave
	group by p.ProductName
)	
go

select * from dbo.fn_proveedor_total_productos_ordenes(20)
go


/*
	4.- FUNCION DE TABLA EN LINEA QUE RECIBA LA CLAVE DEL EMPLEADO, AÑO Y MES, 
	REGRESE EN UNA CONSULTA EL NOMBRE DEL PRODUCTO Y TOTAL DE PRODUCTOS VENDIDOS 
	POR ESE EMPLEADO Y ESE AÑO-MES.
*/
create or alter function dbo.fn_ProductosVendidosPorEmpleado(@clave int, @year int, @mes int)
returns table
as
return 
(
	select NombreProducto = p.productname, TotalProductos = sum(od.quantity) from Products p
	inner join [Order Details] od on od.ProductID = p.ProductID
	inner join Orders o on od.OrderID = o.OrderID
	inner join Employees e on e.EmployeeID = o.EmployeeID
	where (DATEPART(yy, o.OrderDate) = @year and Datepart(mm, o.OrderDate) = @mes and e.EmployeeID = @clave)
	group by p.ProductName
)
go

select * from dbo.fn_ProductosVendidosPorEmpleado(1,1997,1)
go

/*
	5.-	UTILIZANDO LA FUNCION ANTERIOR MOSTRAR UNA CONSULTA SIGUIENTE:
*/
select p3.NombreProducto , 
Producto1996 = isnull(p1.TotalProductos, 0), 
Producto1997 = isnull(p2.TotalProductos, 0), 
Producto1998 = isnull(p3.TotalProductos, 0)
from dbo.fn_ProductosVendidosPorEmpleado(1,1996,1) p1
right join dbo.fn_ProductosVendidosPorEmpleado(1,1998,1) p3 on p3.NombreProducto = p1.NombreProducto
left join dbo.fn_ProductosVendidosPorEmpleado(1,1997,1) p2 on p2.NombreProducto = p3.NombreProducto
go


/*
	6.-	FUNCION DE TABLA DE MULTISENTENCIA (NO LLEVA PARAMETROS DE ENTRADA) QUE REGRESE UNA TABLA CON EL NOMBRE DE LA CATEGORIA 
		Y LOS NOMBRES DE LOS PRODUCTOS QUE PERTENECEN A LA CATEGORIA Y EL TOTAL DE PIEZAS QUE SE HAN VENDIDO DE ESA CATEGORIA
*/
CREATE OR ALTER FUNCTION dbo.TablaCatergoriaProducto()
RETURNS @Tabla TABLE(NombreCategoria VARCHAR(50), Productos VARCHAR(MAX), TotalPiezas INT) AS
BEGIN
	DECLARE @CatID INT, @CatNom VARCHAR(50), @Productos VARCHAR(MAX), @TotalPiezas INT

	SELECT @CatID = MIN(CategoryID) FROM Categories
	WHILE @CatID IS NOT NULL
	BEGIN
		SELECT @CatNom = CategoryName FROM Categories 
		WHERE CategoryID = @CatID

		SELECT @Productos = STRING_AGG(p.ProductName, ', ') 
		FROM Products p
		INNER JOIN Categories c ON p.CategoryID = c.CategoryID
		WHERE p.CategoryID = @CatID

		SELECT @TotalPiezas = SUM(od.Quantity) 
		FROM [Order Details] od
		INNER JOIN Products p on od.ProductID = p.ProductID
		INNER JOIN Categories c ON p.CategoryID = c.CategoryID
		WHERE c.CategoryID = @CatID

		INSERT @Tabla VALUES(@CatNom, @Productos, @TotalPiezas)

		SELECT @CatID = MIN(CategoryID) FROM Categories WHERE CategoryID > @CatID
	END
	RETURN
END
GO

--	Ejecucion
SELECT * FROM dbo.TablaCatergoriaProducto()
GO


/*
	7.-	FUNCION DE TABLA DE MULTISENTENCIA QUE RECIBA UN AÑO COMO PARAMETRO DE ENTRADA, 
	QUE REGRESE UNA TABLA CON DOS COLUMNAS: DIA DE LA SEMANA, FOLIOS QUE SE VENDIERON 
	ESE DÍA DE SEMANA. NOTA, DEBE MOSTRAR TODOS LOS DIAS DE LA SEMANA, AUNQUE NO SE HAYAN 
	REALIZADO ORDENES.
*/

--	Se crea funcion que retorna una tabla con los dias de la semana
CREATE OR ALTER FUNCTION dbo.FN_DiasSemanas()
RETURNS @Semana TABLE( Clave INT, Nombre VARCHAR(20) )
AS
BEGIN
	INSERT @Semana VALUES(1, 'Sunday')
	INSERT @Semana VALUES(2, 'Monday')
	INSERT @Semana VALUES(3, 'Tuesday')
	INSERT @Semana VALUES(4, 'Wednesday')
	INSERT @Semana VALUES(5, 'Thursday')
	INSERT @Semana VALUES(6, 'Friday')
	INSERT @Semana VALUES(7, 'Saturday')

	RETURN
END
GO

--	Se crea la funcion
CREATE OR ALTER FUNCTION dbo.FoliosDias (@Año INT)
RETURNS @FoliosDias TABLE (Dia NVARCHAR(20), Folios VARCHAR(MAX))
AS
BEGIN
    DECLARE @Dia INT = 1
	DECLARE @DiaNom VARCHAR(50)
	DECLARE @Folios NVARCHAR(MAX)
    
    WHILE (@Dia <= 7)
    BEGIN
		SELECT @DiaNom = Nombre FROM dbo.FN_DiasSemanas() WHERE Clave = @Dia
		SELECT @Folios = STRING_AGG(CONVERT(VARCHAR(10), OrderID), ', ')
		FROM Orders
		WHERE DATEPART(YY, OrderDate) = @Año AND DATEPART(dw, OrderDate) = @Dia

		IF @Folios IS NULL
		BEGIN
			SET @Folios = 'Sin Folios'
		END

		INSERT @FoliosDias VALUES(@DiaNom, @Folios)
        
        SET @Dia = @Dia + 1
    END

    RETURN
END
GO

--	Ejecucion
SELECT * FROM dbo.FoliosDias (1997)
GO


/*
	8.-	FUNCION DE TABLA DE MULTISENTENCIA QUE RECIBA LA CLAVE DE UN EMPLEADO Y REGRESE 
		UNA TABLA LOS DIAS DE LA SEMANA Y LOS CUMPLEAÑOS QUE SE HA FESTEJADO ESE DIA DE LA SEMANA
*/

--	Se crea funcion que retorna una tabla con los dias de la semana
CREATE OR ALTER FUNCTION dbo.FN_DiasFestejos(@Emp INT)
RETURNS @TablaFestejos TABLE ([Dia Semana] NVARCHAR(20), Festejos NVARCHAR(1000))
AS
BEGIN 
	DECLARE @Dia INT, @Festejo varchar(1000), @Fecha datetime, @Nom NVARCHAR(20)
	SELECT @Dia = MIN(Clave) from dbo.FN_DiasSemanas()
	WHILE @Dia is not null
	BEGIN
		SELECT @Festejo = ''
		SELECT @Fecha = BIRTHDATE FROM Employees WHERE EmployeeID = @Emp
		WHILE @Fecha <= GETDATE()
		BEGIN
			IF(DATEPART(DW, @Fecha) = @Dia)
				SELECT @Festejo = @Festejo + STR(YEAR(@Fecha)) + ', '

			SELECT @Fecha = DATEADD(YY, 1, @Fecha)
		END
		SELECT @Nom = Nombre FROM dbo.FN_DiasSemanas() WHERE Clave = @Dia
		SELECT @Festejo = SUBSTRING(@Festejo, 1, LEN(@Festejo) - 1)
		INSERT @TablaFestejos VALUES(@Nom, @Festejo)

		SELECT @Dia = MIN(Clave) from dbo.FN_DiasSemanas() WHERE Clave > @Dia
	END
	RETURN
END
GO

--EJECUCION
SELECT * FROM dbo.FN_DiasFestejos(5)