--1.- Utilizando trigger, validar que solo se vendan ordenes de lunes a viernes.
create trigger tr_ejercicio1 
on Orders
for insert as
declare @dia int 

select @dia = DATEPART(dw,OrderDate) from inserted
begin
		if @dia in (1,7)
		rollback tran
		raiserror('Error, no puedes ingresar ventas los dias sabado y domingo',16,1)
end
go
--2.- Validar que no se vendan mas de 20 ordenes por empleado en una semana.
create or alter trigger tr_ejercicio2
on Orders
for insert as
declare @Ordenes int, @EmpId int, @Fecha datetime
select @EmpId = Employeeid from inserted
select @Fecha = OrderDate from inserted
select @Ordenes = Count(OrderId) from Orders where EmployeeID = @EmpId and datepart(ww, OrderDate) = datepart(ww,@Fecha)
if @Ordenes > 20
begin
	rollback tran
	raiserror('Error, no puedes ingresar mas de 20 ordenes por empleado en una misma semana',16,1)
end
go

--3.- Validar que el campo firstname en la tabla employees solamente tenga nombres que inicien con vocal.
create or alter trigger tr_ejercicio3
on Employees
for insert as
declare @firstname nvarchar(30)
select @firstname = FirstName from inserted
if @firstname like '[AEIOU]%'
begin
	rollback tran
	raiserror('Error, solo puedes ingresar nombres que empiecen con vocal',16,1)
end
go

select FirstName from Employees where FirstName not like '%[AEIOU]' and FirstName not like '[AEIOU]%'
go
--4.- validar que el importe de venta de cada orden no sea mayor a $10,000.
create or alter trigger tr_ejercicio4
on [Order Details]
for insert as
declare @importe int
select @importe = Quantity * UnitPrice from inserted
if @importe > 10000
begin
	rollback tran
	raiserror('No puedes ingresar un importe mayor a 10000',16,1)
end
go

--5.- validar que no se puedan eliminar ordenes que se hicieron los lunes.
create or alter trigger tr_ejercicio5
on Orders
for delete as
declare @dia int
select @dia = DatePart(dw, OrderDate) from deleted
if @dia = 2
begin
	rollback tran
	raiserror('No puedes borrar registros de ordenes realizadas en lunes',16,1)
end
go

--6.- Validar que no se realicen inserciones masivas en la tabla products.
create or alter trigger tr_ejercicio6
on Products
for insert as
declare @count int
select @count = Count(*) from inserted
if (@count > 1)
begin
	rollback tran
	raiserror('No se permiten inserciones masivas',16,1)
end
go

--7.- Validar que no se pueda modificar el campo unitprice de la tabla [order details].
create trigger tr_ejercicio7
on [Order Details]
for update as

if update(unitprice)
begin
	rollback tran
	raiserror('Error, no puedes modificar este campo',16,1)
end

--8.- Validar que solo se pueda actualizar una sola vez el nombre del cliente.
Alter Table Customers add nombreAct int
update Customers set nombreAct = 0
go

create or alter trigger tr_ejercicio8
on Customers
for update as
declare @clave int, @conta int
select @clave = CustomerID, @conta = isnull(nombreAct, 0) from inserted
if update(ContactName)
begin
	if @conta > 1
	begin 
		rollback tran
		raiserror('Error, no se puede actualizar',16,1)
	end
	else 
	begin
		update Customers set nombreAct = @conta + 1 where CustomerID = @clave
	end
end
go

--9.- Validar que no se puedan eliminar categorías que tengan una clave impar.
create or alter trigger tr_ejercicio9
on Categories
for delete as
declare @clave int
select @clave = CategoryId from deleted
begin
	if (@clave % 2 != 0) 
	begin
		rollback tran
		raiserror ('Error, no puedes borrar claves impares',16,1)
	end
end
go

--10.- Validar que no se puedan insertar ordenes que se realicen en domingo.
create or alter trigger tr_ejercicio10
on Orders
for insert as
declare @dia int 
select @dia = datepart(dw, OrderDate) from inserted
if @dia = 1
begin
	rollback tran
	raiserror('Error, no puedes insertar ordenes en domingo',16,1)
end