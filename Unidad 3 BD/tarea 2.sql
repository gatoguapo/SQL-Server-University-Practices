use Northwind
go

create table #TablaEmpleadosJefes(empid nvarchar, jefeid nvarchar)
go

create proc sp_empleados_jefes as
begin
declare @emp int, @jefe int

select @emp = min(employeeid) from Employees
select @jefe = min(reportsto) from Employees

while @emp is not null
	begin
		select @emp = employeeid from Employees where EmployeeID = @emp
		while @jefe IS NOT NULL
		begin
			select @jefe = ReportsTo from Employees where EmployeeID = @emp
			insert #TablaEmpleadosJefes values(@emp, @jefe)

			select @jefe = min(ReportsTo) from Employees where EmployeeID > @jefe
		end
		select @emp = min(employeeid) from Employees where EmployeeID > @emp
	end
	select Empleado = e.FirstName +  ' ' + e.LastName , Jefes = string_agg(j.FirstName +  ' ' + j.LastName,', ')
	from #TablaEmpleadosJefes t
	inner join Employees e on t.empid = e.EmployeeID
	inner join Employees j on t.jefeid = j.ReportsTo
	group by e.FirstName, e.LastName
end

exec sp_empleados_jefes