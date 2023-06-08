use Northwind
go

--Ciclo que imprima la clave del empleado (de mayor a menor) y clave de su jefe inmediato
declare @emp int, @jefe int
select @emp = max(employeeid)from Employees

while @emp is not null
begin
	select @jefe = reportsto from employees where EmployeeID = @emp

	print str(@emp)+','+str(isnull(@jefe, ''))

	select @emp = max(employeeid) from Employees where EmployeeID<@emp
end
print 'Fin del ciclo'

--Capturar una fecha de nacimiento, y mediante un proceso llenar una tabla temporal con 
--las fechas de cumpleaños y el dia de la semana que se festejó

--spAniverdarioDiaSemana.jpg
declare @fecha datetime, @dia varchar(50)

create table #T (fecha datetime, dia varchar(50))

select @fecha = '1-1-2000'

while (@fecha<=GETDATE())
begin
	select @dia =datename(dw,@fecha)
	insert #T values(@fecha,@dia)

	select @fecha=dateadd(yy,1,@fecha)
end
select*from #T
drop table #T
go
--Proceso que recibe la fecha en la que inicio a trabajar un empleado
--calcule los dias trabajados restar solo los sabados y domingos
declare @fecha datetime, @conta int = 0, @dia int
select @fecha = '1-1-2000'


while @fecha <= GETDATE()
begin
	select @dia = datepart(dw,@fecha)
	if @dia in (2,3,4,5,6)
	select @conta=@conta+1

	select @fecha=dateadd(yy,1,@fecha)
end
select 'Dias trabajados' = @conta
go
--Proceso para encontrar los dias trabajados por empleado descontando sabados y domingos
declare @clave int, @dia int, @conta int, @fecha datetime
create table #tabla(emp int, dias int)
select @clave = min(employeeid) from Employees

while @clave is not null
begin
	select @fecha = hiredate from employees where EmployeeID=@clave
	select @conta = 0

	while @fecha <= getdate()
	begin
		select @dia = datepart(dw,@fecha)
		if @dia in (2,3,4,5,6)
			select @conta = @conta + 1

		select @fecha = dateadd(dd,1,@fecha)
	end
	insert #tabla values(@clave,@conta)

	select @clave = min(employeeid) from Employees where EmployeeID>@clave
end

select e.firstname+' '+e.lastname, trabajados = t.dias, viejo=datediff(dd,e.hiredate,getdate())
from #tabla T
inner join employees e on e.EmployeeID = t.emp
go
--Proporcionar una fecha de nacimiento y calcular edad exacta

declare @edad int, @fecha datetime

select @fecha = '12-1-2000'
select @edad = datediff(yy,@fecha,getdate())
select @fecha = dateadd(yy,@edad,@fecha)

if @fecha > getdate()
	select @edad = @edad - 1

select @edad

--tabla con el nombre del empleado y la edad exacta de los empleados --spEdadExacta.jpg
go
create or alter proc sp_edades as
declare @emp int, @edad int, @fecha datetime
create table #tabla(emp int, edad int)

select @emp = min(employeeid) from employees
while @emp is not null
begin 
	select @fecha = birthdate from employees where EmployeeID = @emp
	select @edad = datediff(yy,@fecha, getdate())
	select @fecha = dateadd(yy,@edad, @fecha)

	if @fecha > getdate()
		select @edad = @edad-1

	insert #tabla values(@emp,@edad)

	select @emp = min(employeeid) from employees where EmployeeID > @emp
end
print 'fin del ciclo'

select e.firstname + ' ' + e.lastname, e.birthdate, t.edad, datediff(yy,e.birthdate,getdate())
from #tabla t
inner join employees e on e.employeeid = t.emp

exec sp_edades
drop table #tabla