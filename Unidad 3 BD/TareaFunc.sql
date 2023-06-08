--1.- FUNCION ESCALAR QUE RECIBA DOS CLAVES DE CLIENTES,UN AÑO Y UN MES, Y REGRESE EL NOMBRE DEL 
--CLIENTE QUE MAS HA VENDIDO PIEZAS DE LOS DOS EN ESE AÑO-MES Y EL TOTAL DE PIEZAS VENDIDAS. 
--POR EJEMPLO, DEBE REGRESAR: EL CLIENTE JUAN PEREZ VENDIO 450 PIEZAS.
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
--2.- FUNCION ESCALAR QUE RECIBA LA CLAVE DEL TERRITORIO
--Y REGRESE UNA CADENA CON LOS NOMBRES DE LOS EMPLEADOS QUE SURTEN DICHO TERRITORIO.
create or alter function dbo.fn_empleados_territorios (@clave int)
returns nvarchar(50)
as
begin
	declare @empleados nvarchar(max)
	select @empleados = string_agg(CONCAT(e.FirstName, ' ', e.LastName), ', ') from Employees e
	inner join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
	where et.TerritoryID = @clave

	return @empleados
end
go

select dbo.fn_empleados_territorios(06897)
go
--3.- FUNCION DE TABLA EN LINEA QUE RECIBA LA CLAVE DE UN PROVEEDOR Y REGRESE UNA TABLA CON EL NOMBRE DE TODOS LOS PRODUCTOS QUE HA VENDIDO ESE PROVEEDOR, 
--EL TOTAL DE PRODUCTOS VENDIDOS Y EL TOTAL DE ORDENES EN LAS QUE SE HAN VENDIDO.
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

select * from dbo.fn_proveedor_total_productos_ordenes(2)

go
--4.- FUNCION DE TABLA EN LINEA QUE RECIBA LA CLAVE DEL EMPLEADO, AÑO Y MES, 
--REGRESE EN UNA CONSULTA EL NOMBRE DEL PRODUCTO Y TOTAL DE PRODUCTOS VENDIDOS POR ESE EMPLEADO Y ESE AÑO-MES.
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

--5.- UTILIZANDO LA FUNCION ANTERIOR MOSTRAR UNA CONSULTA SIGUIENTE:

select p3.NombreProducto , Producto1996 = isnull(p1.TotalProductos, 0), Producto1997 = isnull(p2.TotalProductos, 0), Producto1998 = isnull(p3.TotalProductos, 0)
from dbo.fn_ProductosVendidosPorEmpleado(1,1996,1) p1
right join dbo.fn_ProductosVendidosPorEmpleado(1,1998,1) p3 on p3.NombreProducto = p1.NombreProducto
left join dbo.fn_ProductosVendidosPorEmpleado(1,1997,1) p2 on p2.NombreProducto = p3.NombreProducto
go
--6.- FUNCION DE TABLA DE MULTISENTENCIA (NO LLEVA PARAMETROS DE ENTRADA) QUE REGRESE UNA TABLA CON EL NOMBRE DE LA CATEGORIA 
--Y LOS NOMBRES DE LOS PRODUCTOS QUE PERTENECEN A LA CATEGORIA Y EL TOTAL DE PIEZAS QUE SE HAN VENDIDO DE ESA CATEGORIA
create or alter function dbo.fn_TablaCategorias ()
returns @TablaCategorias table(nombreCat nvarchar(50), nombresProductos nvarchar(50), totalPiezas int)
as
begin
	declare @claveCat int, @claveProd int, @nombreCat nvarchar(50), @nombresProductos nvarchar(50), @totalPiezas int
	select @claveCat = max(CategoryID) from Categories
	select @claveProd = min(ProductID) from Products where CategoryID = @claveCat

	while @claveCat != 1
	begin
		select @nombreCat = CategoryName from Categories where CategoryID = @claveCat
		while @claveProd is not null
		begin
			select @nombresProductos = ProductName from Products where CategoryID = @claveCat and ProductID = @claveProd
			select @totalPiezas = sum(Quantity) from [Order Details] where ProductID = @claveProd

			insert into @TablaCategorias values(@nombreCat, @nombresProductos, @totalPiezas)
			select @claveProd = min(ProductID) from Products where ProductID > @claveProd and CategoryID = @claveCat
		end
		select @claveCat = max(CategoryID) from Categories where CategoryID < @claveCat
	end
	return
end
go

select * from dbo.fn_TablaCategorias()

select c.CategoryID, c.CategoryName, p.ProductName from Categories c inner join Products p on c.CategoryID = p.CategoryID
order by c.CategoryID