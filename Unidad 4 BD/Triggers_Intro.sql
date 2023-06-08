--TRIGGER, DISPARADORES, GATILLOS
Son procedimientos almacenados especiales que se ejecutan solamente cuando 
se insertan, actualizan o eliminan registros de la tabla.
Dentro de un trigger se pueden realizar:
1.- Declarar variables.
2.- Usar cursores.
3.- Modificar datos de otras tablas.
4.- Deshacer la transaccion explicita con ROLLBACK TRAN.
--CREACION
CREATE TRIGGER nombre_trigger
ON Nombre_tabla
[WITH ENCRYPTION]
FOR {[DELETE][,][INSERT][,][UPDATE]}
AS
sentencias_SQL
--MODIFICACION
ALTER TRIGGER nombre_trigger
ON Nombre_tabla
FOR {[DELETE][,][INSERT][,][UPDATE]}
AS
sentencias_SQL
--ELIMINACION
DROP TRIGGER nombre_trigger
--TABLAS VIRTUALES QUE SE GENERAM
INSTRUCCION INSERT:
Se genera la tabla INSERTED y contiene el nuevo registro que se esta insertando.

INSTRUCCION DELETE:
Se genera la tabla DELETED y contiene el registro qye se esta eliminando.

INSTRUCCION UPDATE:
Se genera la tabla INSERTED con los nuevos datos actualizados,
tambien se genera la tabla DELETED con los viejos datos que se sobreescribieron.

--ejemplo: crear un trigger de insercion en la tabla materiales
create table Materiales
(Clave int primary key, nombre char(50), precio numeric(12,2))
go
create trigger TR_Materiales_Ins
on Materiales for insert as
	select 'se ejecuto el trigger al insertar'
	select * from Inserted
go
--Ejecucion
insert materiales values(1,'lapiz',9)
insert materiales values(2,'bota',9)
--Ejecucion
insert materiales
select productid, productname, unitprice from Products
where productid > 2

select * from materiales

--SINTAXIS: Valida que no se modifique un campo dentro de un trigger
if update(nombreColumna) and | or update (nombreColumna)
begin
	sentencias_select
end
else
begin
	sentencias_select
end
go
--Validad que el nombre de los materias no se actualice
Create or alter trigger tr_materialesins3
on Materiales for Update as

if update(Nombre)
begin
	Rollback Tran
	Raiserror('No se puede actualizar el nombre del material', 16, 1)
end

--no se actualiza el nombre
update materiales set nombre = 'Queso Cab' where clave = 46
update materiales set nombre = 'Queso Cab', precio = 200 where clave = 46
--si se actualiza el precio
Update materiales set precio = 200 where clave = 46

select * from materiales where clave = 46

--se elimina para no tener conflictos posteriores
drop trigger tr_materialesins3

--metodo 1
--Permitir actualizar solo una vez el campo nombre de la tabla materiales

--eliminamos primero el trigger anterior
drop trigger tr_materiales_ins3
drop trigger TR_MAT_UPD --No permite actualizaciones masivas
drop trigger TR_MATERIALES_UP --No permite actualizaciones masivas

--agregamos el campo contador para llevar el numero de actualizaciones
alter table materiales add contador int
update materiales set contador = 0
alter table materiales add constraint df_mat_contador default(0) for contador

go
create trigger tr_materiales_conta
on materiales for update as
declare @clave int, @conta int

select @clave = clave, @conta = isnull(contador, 0) from inserted

if update(nombre)
begin
	if @conta > 0
	begin
		rollback tran
		raiserror('No se puede actualizar mas de una vez el nombre', 16, 1)
	end
	else
		update materiales set contador = @conta+1 where clave = @clave
end
go

insert Materiales(clave, nombre, precio) values (108, 'pintura', 180)
select * from Materiales where clave = 108

--Actualizamos l precio y verificamos que el campo conta no aumenta
update materiales set precio = precio + 2 where clave = 108
--si se puede
update materiales set nombre = 'Bolsa negra' where clave = 108
--ya no permite actualizar una segunda vez
update materiales set nombre = 'Bolsa roja' where clave = 108

drop trigger tr_materiales_conta

--metodo 2
-- con configuracion
-- permitir actualizar solo una vez el campo nombre de la tabla materiales
create table configuracion (contador int)
insert configuracion values(1)

go
create trigger tr_materiales_conta
on materiales for update
as
declare @clave int, @conta int, @contaconfig int

select @clave = clave, @conta = isnull(contador, 0) from inserted
select @contaconfig = contador from configuracion
if update (nombre)
begin
	if @conta = @contaconfig
	begin 
		rollback tran
		raiserror('No se puede actualizar mas de una vez el nombre', 16, 1)
	end
	else
		update materiales set contador = @conta + 1 where clave = @clave
	end
go
		insert materiales (clave, nombre, precio) values (109, 'pintura', 55)
--si se puede
update materiales set nombre = 'pintura negra' where clave = 109
--no se puede
update materiales set nombre = 'pintura roja' where clave = 109 

update configuracion set contador = 2

select * from materiales where clave = 109
GO

create or alter trigger tr_orderdetail_totalpiezas
on [Order Details] for insert, update, delete as
declare @prod int, @sup int, @piezas int

--1-buscar la clave del producto en la tabla inserted/deleted 
IF (SELECT COUNT (*) FROM INSERTED) = 0
	select @prod = Productid from deleted
else
	select @prod = productid from inserted

--2.- Buscar la clave de la categoria del producto encontrado en el punto 1
select @sup = supplierid from products where ProductID = @prod

--3.- Calcula el total de piezas en la tabla ORDER DETAILS, donde se sumen los productos del proveedor
select @piezas = sum(d.quantity)
from [Order Details] d
inner join Products p on d.ProductID = p.ProductID
where p.SupplierID = @sup

--4.- Actualizo el campo totalpiezas con el calculo del punto 3 en la tabla suppliers
update Suppliers set totalpiezas = @piezas
where SupplierID = @sup
go