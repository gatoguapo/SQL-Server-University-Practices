--Programacion con Transact-SQL

--Declaracion de variable
declare @nom_variable tipo_dato

--Tipo_dato : son tipos de datos valido en sql server:
bit, int, numeric, char, varchar, datetime, etc.

--Asignacion de variable
select @nom_variable = valor;
set @nom_variable = valor;

--Los valores de cadena de caracteres y fecha llevan comillas para su asignacion
select @nacimiento = '01_01_2007'
select @nombre = 'Juan Perez'

--Los valores numericos se asignan de manera normal
select @x = 12.1

--Impresion
print @nom_variable
select @nom_variable


--Ejemplo
declare @total numeric(7,3)-- -+ 9999.99
select @total
select @total = 9999.99
select @total
select @total = count(*) from employees
select @total
go

--Ejemplo
declare @total numeric(12,2), @min int
select @total = count(*), @min = min(employeeid) from employees
select @total, @min

--Ejemplo: No se debe asignar una lista de resultados a una variable
declare @total numeric(12,2)
select @total = employeeid from employees order by employeeid desc
select @total
--comentario en un renglon

/* segundo
sadsadsa
comentario */

--Variable de Sistema
--Son variables que utiliza SQL Server para administrar recursos. No se pueden modificar
--solamente leer o imprimr
select @@version : contiene la version de sql server
select @@FETCH_STATUS : se utiliza en cursores, indica la posicion del cursor
select @@ERROR : administra el tipo de error que ha ocurrido.
select @@CONNECTIONS : indica el numero de conexiones activas
select @@ROWCOUNT : indica los renglones afectados por la instruccion insert/update/delete/select
select @@IDENTITY : indica el ultimo valor obtenido en una tabla con la propiedad identity

