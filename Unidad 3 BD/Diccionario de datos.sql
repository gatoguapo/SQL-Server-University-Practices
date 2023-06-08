Diccionario de datos
Es la referencia con la que cuenta el servidor para guardar la estructura de las 
tablas, vistas y sp. Esta informacion esta contenida en tablas de sistema, las cuales
guardan la informacion de las tablas de usuario
--Tabla de sistema

--Tabla SYSOBJECTS:
--Contiene toda la informacion referente a las tablas, vistas, SP, funciones y demas objetos de la BD.
select * from sysobjects
select * from INFORMATION_SCHEMA.TABLES
xtype:
t: tablas
p: sp
v: vistas
fn,tf: funciones

--tablas de usuario de la base de datos
select id, name, xtype
from sysobjects where xtype='p'
order by id

funciones utilizadas:
object_id('Nombre Tabla'):
funcion que recibe el nombre de un objeto y regresa el identificador de dicho objeto.
select OBJECT_ID=('categories')

object_name(identificador):
Funcion que recibe el identificador de un objeto y regresa el nombre de dicho objeto.
select object_name(21575115)

--Tabla SYSCOLUMNS:
--Contiene el nombre de columnas de tablas y vistas, tambien el nombre de los parametros de los 
--procedimientos almacenados
select id, colid, colorder, name, xtype, length, prec, scale, isnullable
from syscolumns where object_id('products') = id

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME like 'products'

--Tabla SYSTYPES:
--Contiene los tipos de datos asociados a columnas de tablas y vistas,
--Tambien incluye los tipos de datos asociados a los parametros de los proc alm,
select xtype, name from systypes

--consulta el nombre de las columnas y tipos de datos
select c.colid, c.colorder, c.name, tipo = t.name, c.prec, c.scale, isnullable
from syscolumns c
inner join systypes t on c.xtype = t.xtype
where c.id = OBJECT_ID('prueba') and t.name not like 'sysname'
order by c.colorder

sp_columnas_select usuarios, 'u.'

select u.usuario, u.ventanilla, u.nombre, u.apepat, u.apemat, u.status, u.password,
u.titulo, u.cambiarecha, u.tipo, u.jefe, u.fechaingreso, u.

--proc alm que reciba el nombre de una tabla y regrese el select compelto con el nombre de todos los
--campos usando un alias
--sp04 T SYS.doc diagrama 1