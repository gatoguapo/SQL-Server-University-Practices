--RESTRICCIONES DE VISTAS
use Northwind
go
--1.- Debe especificar en una vista los nombres de todas las columnas derivadas,
--ademas los nombres de las columnas no se deben repetir.
create view vw_productoprecio as
select productname, Precio = UnitPrice*1.4
from Products
go
--2.-Las instrucciones CREATE VIEW no pueden combinarse con ninguna otra 
--instruccion de SQL en un lote. Un lote es un conjunto de instrucciones separadas por la palabra GO
create view vw_productos2 as
select * 
from Products
go
create view vw_producto3 as
select *
from Products
go
--3.-Todos los objetos de BD a los que se haga referencia en la vista, se verifican al momento de crearla.

--marca error, el campo gasto no existe en la tabla productos
create view vw_productos4 as
select gasto
from Products
go
--4.- No se puede incluir la clausulas order by en la instruccion select
--dentro de una vista
create view vw_productos6 as
select *
from Products
order by productname
go
--5.- Si se eliminan objetos a los que hace referencia dentro de una vista, la vista permanece,
--la siguiente vez que intente usar esta vista recibira un mensaje de error.
create view vw_productos7 as
select * 
from vw_productos6
go
drop view vw_productos6

-- la vista 7 ya no se ejecuta, la vista 6 fue eliminada previamente
select *
from vw_productos7 order by productid

--No se puede hacer refencia a tablas temporales en una vista.
--Tampoco puede utilizar la clausula select into en una vista.

--Tabla temporal local
create table #Local(col1 int, col2 int)
--Tabla temporal global
create table ##Global(col1 int, col2 int)

select*from #Local
select*from ##Global
go
--Marca error
create view vw_productos5 as
select*
from #local
go
--Select into, copia la estructura de una tabla y la llena de datos
select*
into copiaprod
from products
go
select * from copiaprod

drop table copiaprod
go
--Marca error
Create view vw_productos5 as
select*
into tabla4
from products
go
--7.- Si la vista emplea el asterisco * en la instruccion select y la tabla base
--a la que hace referencia se le agregan nuevas columnas,
--estas no se mostraran en la vista
create table tabla1 (conl1 int, col2 int) 
go
create view vw_tablaA as
select * from tabla1
go
alter table tabla1 add col3 int
go
select*from vw_tablaA
go
--es necesesario utilizar el comando alter view para actualizar los campos en la vista
alter view vw_tablaA as
select*from tabla1
go
--al eliminar una columna de tabla1, la vista marcara error al ejecutarse
alter table tabla1 drop column col1
--marca error
go
select*from vw_tablaA
--se corrige ejecutando alter view