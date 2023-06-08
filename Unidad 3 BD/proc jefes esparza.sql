create or alter proc sp_reportejefes_sup as
declare @emp int, @jefesup int, @todosjefes varchar(1000), @nom varchar(100)
create table #T(emp int, nombrejefes varchar (1000))

select @emp = min(employeeid) from employees
while @emp is not null
begin
	select @todosjefes=''
	select @jefesup = reportsto from employees where employeeid=@emp

	while @jefesup is not null
	begin
		select @nom = firstname +' '+lastname from employees where employeeid = @emp
		select @todosjefes = @todosjefes + @nom + ', '

		select @jefesup = reportsto from employees where employeeid = @jefesup
	end
	insert #T values(@emp, @todosjefes)

	select @emp = min(employeeid) from employees where employeeid > @emp
end
select empleado = e.firstname+''+e.lastname, t.nombrejefes
from #T t
inner join employees e on e.employeeid = t.emp

exec sp_reportejefes_sup