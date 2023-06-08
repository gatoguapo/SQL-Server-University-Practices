--Modificacion de datos mediante vistas
--Para modificar datos desde vistas creadas, es necesario tomar en cuenta las siguientes reglas:

--Regla 1:
--Las modificaciones no pueden afectar a mas de una tabla subyacente.
--Si una vista une informacion de dos o mas tablas, solo se puede modificar datos en una de las tablas base
use Northwind
go
create view vw_productos_cat as
select
p.productid, p.productname, p.unitprice, c.categoryid, c.categoryname
from products p
inner join Categories c on p.CategoryID = c.CategoryID
go
--No se puede actualizar el nombre del producto y de la categoria con el mismo update
update vw_productos_cat
set ProductName = 'Leche descremada', CategoryName = 'Lacteos'
where ProductID = 1

--se tienen que hace 2 updates por separado
update vw_productos_cat set CategoryName = 'Lacteos' where ProductID = 1
update vw_productos_cat set ProductName = 'Leche descremada' where ProductID = 1

--Insertar un registro en la tabla productos con la vista vw_productos_cat
insert vw_productos_cat (ProductName) values ('Leche descremada')

select * from Products
--La eliminacion no es posible porque afecta a dos tablas
delete vw_productos_cat where ProductID in (78)

--Se tiene que hacer directo con la tabla
delete Products where ProductID = 78

--Regla 2:
--Solo se pueden modificar datos de columnas directas en una tabla base, asu que no es posible alterar
--columnas calculadas, columnas con dunciones de agregado y columnas con funciones de cadena, fecha
go
create view vw_detalle as
select orderid, productid, unitprice,quantity, total = unitprice*quantity
from [Order Details]

--No se puede actualizar el campo total
update vw_detalle set total = total*1.3 where productid = 1

--Si se puede actualizar cualquier otro campo directo
update vw_detalle set UnitPrice = UnitPrice*1.3 where ProductID = 1

--Regla 3:
--Las columnas con la propiedad "not null" definidas en la tabla base, porque no forman parte de la vista,
--deben tener asignados valores predeterminados para cuando se insertan
--nuevas filas por medio de la vista
go
--El campo TIPO no acepta valores nulos
create table grupos(clave int primary key, nombre char(10)not null,ripo int not null,)
go
--Une vista sobre la tabla grupos y no se incluye el campo tipo
create view vw_grupos as
select clave, nombre 
from grupos
go
--no se puede insertar datos desde la vista
insert vw_grupos (clave, nombre) values (1,'casa')

--Crear un valor predeterminado sobre el campo tipo para que
--inserte el valor 5 en el campo TIPO, ya es posible insertar utilizando la vista
alter table grupos add constraint dc_grupos_tipo default (5) from TIPO

select*from grupos

go
--Regla 4
--Al crear una vista con la opcion with check option, todos los datos
--que se deseen insertar o actualizar deberan apegarse a la condicion
--incluida en la instruccion select de vista
create view vw_prod as
select*from Products where ProductName like 'm%'
with check option
go

--SOLAMENTE SE PUEDEN MODIFICAR O INSERTAR DATOS QUE EMPIEZAN CON M
--MARCA ERROR
insert vw_prod (ProductName) values('Desarmador')
--si se puede insertar
insert vw_prod (ProductName) values('Madera')
