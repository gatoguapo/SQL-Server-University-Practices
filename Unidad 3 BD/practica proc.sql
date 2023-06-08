use Northwind
go
-- 1- AGREGAR A LA TABLA PROVEEDORES EL CAMPO TOTALPIEZAS, EL CUAL REPRESENTARÁ EL TOTAL DE PIEZAS VENDIDAS DE CADA PROVEEDOR. 
--CREAR UN PROCEDIMIENTO ALMACENADO QUE LLENE DICHO CAMPO.
ALTER TABLE Suppliers ADD TOTALPIEZAS2 INT
go
create or alter proc sp_totalpiezas as
declare @TotalPiezas int, @SupplierID int

select @supplierid = min(supplierid) from Suppliers

while @SupplierID is not null
begin
	select @TotalPiezas = 0
	select @TotalPiezas = sum(od.quantity) from [Order Details] od
	inner join Products p on od.ProductID = p.ProductID
	inner join Suppliers s on s.SupplierID = p.SupplierID
	where s.SupplierID = @SupplierID

	update Suppliers set TOTALPIEZAS2 = @TotalPiezas where SupplierID = @SupplierID 

	select @SupplierID = min(supplierid) from Suppliers where SupplierID > @SupplierID
end
go

exec sp_totalpiezas
select supplierid, TOTALPIEZAS2 from Suppliers
select supplierid, TotalPiezas from Suppliers
go
--2.- SP QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE POR RETORNO LA EDAD EXACTA DEL EMPLEADO.
create or alter proc sp_edad_emp @claveEmp int, @edad int output as
declare @fecha date

select @fecha = BirthDate from Employees where EmployeeID = @claveEmp

select @edad = DATEDIFF(yy, @fecha, GETDATE())

select @fecha = DATEADD(yy, @edad, @fecha)

if @fecha > GETDATE()
	select @edad = @edad - 1
go

declare @edad int
exec sp_edad_emp 2, @edad output
select @edad
go
/*3.- PROCEDIMIENTO ALMACENADO QUE RECIBA COMO PARAMETRO UN AÑO Y REGRESE DOS PARAMETROS: 
•	UN PARAMETRO CON EL NOMBRE DE TODOS LOS CLIENTES QUE COMPRARON ESE AÑO
•	Y OTRO PARAMETRO CON LA LISTA DE LAS ORDENES REALIZADAS ESE AÑO. */
create or alter proc sp_clientes_ordenes @year int, @nombresClientes nvarchar(max) output, @listaOrdenes nvarchar(max) output as

select @nombresClientes = string_agg(c.ContactName, ', ') from Customers c
inner join Orders o on c.CustomerID = o.CustomerID where Year(o.OrderDate) = @year
group by ContactName

select @listaOrdenes = STRING_AGG(o.OrderId, ', ') from Orders o where year(o.OrderDate) = @year
group by OrderID
go

declare @nombresClientes nvarchar(max), @listaOrdenes nvarchar(max)
exec sp_clientes_ordenes 1996, @nombresClientes output, @listaOrdenes output
select @nombresClientes, @listaOrdenes

select year(orderdate) from Orders
go
--4.- PROCEDIMIENTO ALMACENADO QUE REGRESE UNA TABLA CON LA FECHA Y LOS NOMBRES DE LOS PRODUCTOS QUE SE COMPRARON ESE DÍA.'
create or alter proc sp_fecha_productos as
begin
	declare @fecha datetime, @nombreProductos nvarchar(max)
	select @fecha = min(orderdate) from Orders

	create table #tabla_fecha_productos(Fecha datetime, NombreProductos nvarchar(max))

	while @fecha < getDate()
	begin
		select @nombreProductos = ''
		select @nombreProductos = string_agg(p.ProductName, ', ') from Products p 
		inner join [Order Details] od on p.ProductID = od.ProductID
		inner join Orders o on od.OrderID = o.OrderID
		where OrderDate = @fecha

		insert #tabla_fecha_productos values(@fecha, @nombreProductos)

		select @fecha = min(orderdate) from Orders where OrderDate > @fecha
	end
	select * from #tabla_fecha_productos
	drop table #tabla_fecha_productos
end

exec sp_fecha_productos
go
/*
5.- SP QUE RECIBA UN AÑO Y REGRESE COMO PARAMETRO DE SALIDA LA CLAVE DEL ARTICULO QUE MAS SE VENDIO ESE AÑO Y CANTIDAD DE PIEZAS VENDIDAS DE ESE PRODUCTO EN ESE AÑO.
*/
create or alter proc sp_articulo_mas_vendido @year int, @claveArt int output, @cantidadPiezas int output 
as
begin
	select top 1  @claveArt = p.productid, @cantidadPiezas = sum(od.quantity) from Products p
	inner join [Order Details] od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID = o.OrderID
	where year(o.OrderDate) = @year
	group by p.ProductID
	order by sum(od.quantity) desc
end
go

declare @claveArt int, @cantidadPiezas int
exec sp_articulo_mas_vendido 1997, @claveArt output, @cantidadPiezas output
select @claveArt, @cantidadPiezas
go

--6.- FUNCION DE TABLA DE MULTISENTENCIA QUE RECIBA UN AÑO COMO PARAMETRO DE ENTRADA, 
--QUE REGRESE UNA TABLA CON DOS COLUMNAS: MES, FOLIOS QUE SE VENDIERON ESE MES. NOTA: MOSTRAR TODOS LOS MESES.

create or alter function dbo.Ventas_Meses (@year int)
returns @VentasMeses Table (Mes int, FoliosVendidos nvarchar(max))
as
begin
	declare @Meses int, @Mes nvarchar(20) ,@Folios nvarchar(max)
	select @Meses = Min(MONTH(OrderDate)) from Orders where DATEPART(yy, OrderDate) = @year

	while @meses is not null 
	begin
		select @Folios = string_agg(OrderId, ', '), @Mes = DATEPART(mm, OrderDate) from Orders 
		where DATEPART(mm, OrderDate) = @Meses and DATEPART(YY, OrderDate) = @Year
		group by DATEPART(mm, OrderDate)

		insert @VentasMeses values(@Mes, @Folios)

		select @Meses = min(Month(OrderDate)) from Orders where DATEPART(mm, OrderDate) > @Meses
	end
	return
end
go

create table #Meses (Clave int, MesNombre nvarchar(20))
insert #Meses values (1, 'Enero')
insert #Meses values (2, 'Febrero')
insert #Meses values (3, 'Marzo')
insert #Meses values (4, 'Abril')
insert #Meses values (5, 'Mayo')
insert #Meses values (6, 'Junio')
insert #Meses values (7, 'Julio')
insert #Meses values (8, 'Agosto')
insert #Meses values (9, 'Septiembre')
insert #Meses values (10, 'Octubre')
insert #Meses values (11, 'Noviembre')
insert #Meses values (12, 'Diciembre')

SELECT a.MesNombre, m.FoliosVendidos FROM dbo.Ventas_Meses (1996) m
right outer join #Meses a on m.Mes = a.Clave
GO