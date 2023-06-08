use Northwind
go

create proc sp_empleados_jefes as
	create table #TablaEmpleadosJefes(Empleado nvarchar(50), Jefe nvarchar(max))
begin
declare @emp int, @jefe int, @nombreEmpleado nvarchar(50), @jefeNombre nvarchar(50), @jefesNombres nvarchar(max)

select @emp = min(employeeid) from Employees

	while @emp is not null
	begin
		select @nombreEmpleado = firstname + space(1) + lastname from Employees where EmployeeID = @emp
	
		select @jefesNombres = ''
		select @jefe = ReportsTo from Employees where EmployeeID = @emp
		
		while @jefe is not null
		begin
			select @jefeNombre = firstname + space(1) + lastname from Employees where EmployeeID = @jefe
			select @jefesNombres = @jefesNombres + @jefeNombre + ', '
			select @jefe = reportsto from Employees where EmployeeID = @jefe 
		end
	
		if len(@jefesnombres) > 0
		begin
			select @jefesNombres = SUBSTRING(@jefesNombres, 1, len(@jefesnombres) - 1)
		end

		insert #TablaEmpleadosJefes values (@nombreEmpleado, @jefesNombres)
	
		select @emp = min(employeeid) from Employees where EmployeeID > @emp
	end
	select *
	from #TablaEmpleadosJefes
	order by Empleado
end

exec sp_empleados_jefes