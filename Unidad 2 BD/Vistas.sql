Unidad 2: Vistas
Son objetos contenidos dentro de cada BD y son Consultas precompiladas
que funcionan como tablas virtuales. Debido a que son consultas precompiladas,
cuando se ejecutan, son mas rapidas que la consulta que contiene.

use Northwind
go

--1.-Creacion
create view nom_vista [with encryption] as
instruccion_select
go
--2.-Manipulacion
select * from nom_vista
insert/update/delete nom_vista
go
--3.-Modificacion
alter view nom_vista as
instruccion_select
go
--4.-Eliminacion
drop view nom_vista
go
--vista con la clave, el nombre y precio del producto
create view vw_productos as
select productid, productname, unitprice from products
go
--ultilizar vista 
select * 
from vw_productos

--Con una combinacion
select *
from vw_productos p
inner join [Order Details] d 
on d.ProductID = p.ProductID

--para la modificacion de un registro
update vw_productos set UnitPrice = UnitPrice + 1 
where ProductID = 2

--se consulta los datos sobre la tabla
select productname, Unitprice from Products 
where ProductID = 2
go

--con este procedimiento almacenado se ve el contenido de la vista si no esta encriptada.
sp_helptext vw_products

--eliminacion de una vista
drop view vw_productos
go

--ahora la vista creada y encriptada
create view vw_productos with encryption as
select productid, productname, unitprice, costo = UnitPrice*0.2 
from Products
go

--no se puede mostrar el contenido de la vista
sp_helptext vw_productos