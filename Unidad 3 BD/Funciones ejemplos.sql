use Northwind
go
--funcion multisentencia que reciba un año, regresa el nombre del empleado y el total de ventas de los
--empleados de ese año. Mostrar todos los empleados aunque no hayan realizado ordenes
alter function fn_ventas (@año int)
returns @ventas table(nomemp varchar(100), total numeric(12,2))
as 
begin
	insert @ventas
	select e.firstname + '' + e.lastname, total = isnull(sum(quantity*unitprice),0)
	from orders o
	right outer join [order details] d on o.orderid = d.orderid and year(o.orderdate) = @año
	right outer join employees e on e.employeeid = o.employeeid
	group by e.firstname, e.lastname
return 
end
go
--ejecucion
select * from fn_ventas(2000)
go
--consulta con el nombre del empleado y el importe de venta en 1994, 1996 y 1999
select a.nomemp, T94=isnull(a.TOTAL, 0), T96=isnull(b.total, 0), T99 = isnull(c.total, 0)
from fn_ventas(1994) A
inner join fn_ventas(1996) B on b.nomemp = a.nomemp
inner join fn_ventas(1999) C on c.nomemp = a.nomemp

go

--funcion de tabla multisentencia que regrese la clave del empleado y el total de dias trabajados
--descontando sabados, domingos
create function dbo.fn_diastrabajados()
returns @resp table(emp int, dias int) as
begin
	declare @empid int, @dias int, @fechainicio datetime, @contador int

	select @empid = min(employeeid) from employees
	while @empid is not null
	begin
		select @fechainicio = hiredate from Employees where employeeid = @empid
		select @contador = 0

		while @fechainicio <= getdate()
		begin 
			if (datepart(dw, @fechainicio) not in (1,7))
				select @contador = @contador + 1

			select @fechainicio = dateadd(dd, 1, @fechainicio)
		end
		insert @resp values(@empid, @contador)
		select @empid = min(employeeid) from employees where EmployeeID > @empid
	end
	return
end
go

--Ejecucion
select e.firstname + ' ' + e.lastname, d.dias
from dbo.fn_diastrabajados()d
inner join Employees e on e.EmployeeID = d.emp