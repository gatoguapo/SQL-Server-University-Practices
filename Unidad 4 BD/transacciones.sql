begin tran
	update Categories set CategoryName = 'bolsa'
	--verificamos las transacciones abiertas
	SELECT @@TRANCOUNT
	--verificamos los cambios en la tabla categories
	select * from Categories

--deshacemos la transaccion
rollback tran

select @@trancount -- marca 0
begin tran T1
select @@TRANCOUNT -- marca 1

update Categories set CategoryName = 'verduras' where CategoryID = 1
update Employees set FirstName = 'Maria' where EmployeeID = 1

	save tran PUNTO1 --punto de almacenamiento

	insert Categories (CategoryName, Description) values('AAAAAA', 'AAAAA')

	select @@TRANCOUNT -- marca 1

	ROLLBACK TRAN PUNTO1 --deshace solamente la instruccion insert categories

	select @@TRANCOUNT -- marca 1

commit tran T1 -- aplica solamente el update categories y update employees

select @@TRANCOUNT --queda en 0
-- verificamos los cambios
select firstname from Employees where EmployeeID = 1
select categoryname from Categories where CategoryID = 1
select * from categories