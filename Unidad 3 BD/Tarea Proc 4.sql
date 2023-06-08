use northwind
go

-- 1- AGREGAR A LA TABLA PROVEEDORES EL CAMPO TOTALPIEZAS, EL CUAL REPRESENTARÁ EL TOTAL DE PIEZAS VENDIDAS DE CADA PROVEEDOR. 
--CREAR UN PROCEDIMIENTO ALMACENADO QUE LLENE DICHO CAMPO.
ALTER TABLE Suppliers add TotalPiezas int
go
create or alter proc sp_llena_totalpiezas as
declare @supplierID int, @piezas int

select @supplierID = min(supplierid) from Products

while @supplierID is not null
begin
	select @piezas = 0
	select @piezas = sum(Quantity) from [Order Details] od
	inner join Products p on od.ProductID = p.ProductID where SupplierID = @supplierID
	update Suppliers set TotalPiezas = @piezas where SupplierID = @supplierID

	select @supplierID = min(supplierid) from Products where supplierid > @supplierID
end
go

exec sp_llena_totalpiezas 
Select SupplierID, TotalPiezas from Suppliers
go

--2.- SP QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE POR RETORNO LA EDAD EXACTA DEL EMPLEADO.
create or alter proc sp_edad_exacta @empid int, @edad int output as
declare @fechanac datetime

select @edad = datediff(yy, BirthDate, GETDATE()) from Employees where EmployeeID = @empid

select @fechanac = dateadd(yy, @edad, BirthDate) from Employees where EmployeeID = @empid
if @fechanac> GETDATE()
	select @edad = @edad-1
go

declare @edad int
exec sp_edad_exacta 1, @edad output
select Edad = @edad
go
/*3.- PROCEDIMIENTO ALMACENADO QUE RECIBA COMO PARAMETRO UN AÑO Y REGRESE DOS PARAMETROS: 
•	UN PARAMETRO CON EL NOMBRE DE TODOS LOS CLIENTES QUE COMPRARON ESE AÑO
•	Y OTRO PARAMETRO CON LA LISTA DE LAS ORDENES REALIZADAS ESE AÑO. */
create or alter proc sp_anio_clientes_ordenes @anio datetime, @clientes nvarchar(max) output, @ordenes nvarchar(max) output as
declare @ordenesID int

select @clientes = ''
select @ordenes = ''

select @ordenesID = min(orderid) from Orders

while @ordenesID is not null
begin
	select @clientes = concat(@clientes, ContactName + ', ') from 
	Customers c 
	inner join Orders o on c.CustomerID = o.CustomerID 
	where o.OrderID = @ordenesID and year(o.OrderDate) = @anio 
	group by ContactName

	select @ordenes = concat(@ordenes, convert(varchar(100),OrderID)+ ', ') from Orders
	where OrderID = @ordenesID and year(OrderDate) = @anio 
	group by OrderID

	select @ordenesID = min(orderid) from orders where orderid > @ordenesID
end
go

declare @clientes nvarchar(max), @ordenes nvarchar(max) 
exec sp_anio_clientes_ordenes 1996, @clientes output, @ordenes output
select 'Nombre de los clientes' = @clientes, Ordenes = @ordenes
go
--4.- PROCEDIMIENTO ALMACENADO QUE REGRESE UNA TABLA CON LA FECHA Y LOS NOMBRES DE LOS PRODUCTOS QUE SE COMPRARON ESE DÍA.'
create table #temp_productos_dias (fecha datetime, productos nvarchar(max))
go

CREATE OR ALTER PROC sp_tabla_dias_productos AS
BEGIN
	DECLARE @fecha DATETIME, @productos NVARCHAR(max)
	SELECT @fecha = MIN(orderdate) FROM Orders

	WHILE @fecha IS NOT NULL
	BEGIN
		
		SELECT @productos = STRING_AGG(p.ProductName, ', ')
		FROM Products p
		INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
		INNER JOIN Orders o on o.OrderID = od.OrderID
		WHERE o.OrderDate = @fecha

		INSERT #temp_productos_dias VALUES(@fecha, @productos)
		SELECT @fecha = MIN(orderdate) FROM Orders WHERE OrderDate > @fecha
	END
	
END
 
exec sp_tabla_dias_productos
select * from #temp_productos_dias
go
--5.- SP QUE RECIBA UN AÑO Y REGRESE COMO PARAMETRO DE SALIDA LA CLAVE DEL ARTICULO QUE MAS SE VENDIO ESE AÑO Y CANTIDAD DE PIEZAS VENDIDAS DE ESE PRODUCTO EN ESE AÑO.
create or alter proc sp_anio_claveArt_cantidadPiezas @anio datetime, @claveArt int output, @cantidadPiezas int output as
begin
	select top 1 @claveArt = p.ProductID, @cantidadPiezas = sum(od.Quantity)
	from [Order Details] od 
	inner join Products p on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID = o.OrderID 
	where YEAR(o.OrderDate) = @anio 
	group by p.ProductID, YEAR(o.OrderDate)
	order by count(p.ProductID) desc
end
go

declare @claveArt int, @cantidadPiezas int
exec sp_anio_claveArt_cantidadPiezas 1996, @claveArt output, @cantidadPiezas output
Select 'Claver Art mas vendido' = @claveArt, 'Cantidad de piezas' = @cantidadPiezas
go
--6.- FUNCION DE TABLA DE MULTISENTENCIA QUE RECIBA UN AÑO COMO PARAMETRO DE ENTRADA, 
--QUE REGRESE UNA TABLA CON DOS COLUMNAS: MES, FOLIOS QUE SE VENDIERON ESE MES. NOTA: MOSTRAR TODOS LOS MESES.
