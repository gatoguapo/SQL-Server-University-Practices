--PROCEDIMIENTOS ALMACENADOS
Un procedimiento almacenado (stored procedure en ingles) es un programa (o procedimineto)
almacenado fisicamente en una base de datos. La ventaja de un procedimiento almacenado es que 
al ser ejecutado, en respuesta a una peticion de usuario, es ejecutado directamente en el motor
de base de datos, el cual usualmente corre en un servidor separado.
Como tal posee acceso directo a los datos que necesita manipular y solo necesita enviar sus 
resultados de regreso al usuario, deshaciendose de la sobrecarga resultante de comunicar grandes
cantidades de datos salientes y entrantes.

--CREACION
CREATE PROC[EDURE] NOMBRE_PROC
@Parameter tipodato [=default] [output]
[with {recompile|encryption|recompile, encryption]}
as
	sentencias_sql

--Modificacion
ALTER PROC MOBRE_PROC AS
SENTENCIAS_SQL

--ELIMINACION
DROP PROC NOMBRE_PROC

--EJECUCION
[EXECUTE] NOM_PROC LISTA_PARAMETROS

--Para ejecutar instrucciones dinamicas
exec[ute] ('Instruccion_sql'/nombre_variable)

--ejecutar una consulta mediante una cadena de caracteres.
--debe ejecutar una sentencia select
declare @nom char(50)
select @nom = 'employees'
exec ('select*from ' + @nom)

--sentencia raiserror: se utiliza para mandar mensajes de error a una aplicacion
--o una ventana de resultados
raiserror('mensaje', severidad, estado)

--ejemplo
insert products values('casa',3)

if @@error <> 0
	raiserror('error al insertar en la tabla products', 16, 1)

--BEGIN TRY
begin try
	declare @valor1 numeric(9,2),@valor2 numeric(9,2), @division numeric (9,2)
	set @valor1 = 100
	set @valor2 = 0
	set @division = @valor1/valor2
	print 'La division no reporta error'
end try
begin catch
	select @@error as 'error', error_number() as 'n° de error', error_severity() as 'Severidad',
	error_state() as 'Estado', error_procedure() as 'Procedimiento', error_line() as 'N°Linea',
	error_message() as 'Mensaje'
end catch

--tipos de procedimientos almacenados (stored )

--1.- procedimientos almacenados que regresan una consulta
--sp que reciva la clave de un empleado y regrese las ordenes realizadas
create proc sp_regreso @emp int as

select orderid, orderdate from orders where employeeid = @emp
go
--ejecucion
exec sp_regreso 1
go
--creamos una tabla temporal para insertar el resultado de un proc almacenado que regrese una consulta
create table #res (folio int, fecha datetime)

--ejecutamos el proc y se inserta automaticamente en las tabla #res
insert #res
exec sp_regreso 2

--verificamos el contenido de la tabla
select *from #res

insert #res
select orderid, orderdate from orders where employeeid = 1
go
--sp que regresa una tabla con el nombre del empleado y los dias trabajados por el empleado
create proc sp_diastrabajados as
declare @emp int, @dia int, @conta int, @fecha datetime
create table #tabla(emp int, dias int)

select @emp = min(employeeid) from employees
while @emp is not null
begin
	select @fecha = hiredate from Employees where employeeid = @emp
	select @conta = 0

	while @fecha <= getdate()
	begin
		select @dia = datepart(dw, @fecha)
		if @dia not in (1, 7)
			select @conta = @conta + 1

		select @fecha = dateadd(dd, 1, @fecha)
	end
	insert #tabla values(@emp, @conta)
	select @emp = min(employeeid) from employees where employeeid>@emp
end
select nombre = e.firstname + '' + e.lastname, dias_trabajados = T.dias
from #tabla T
inner join employees e on e.EmployeeID = t.emp

exec sp_diastrabajados
go
--2 Sin parametros
--procedimiento que actualice el precio de todos los productos y aumente el 10%
create proc sp_aumento as
update products set unitprice=unitprice*1.1
go
--ejecucion
exec sp_aumento
--validar el producto 1
select productid, unitprice from Products where productid = 1
go
--3.- SP con parametros de entrada
--sp que reciba 4 calificaciones imprimir el promedio
create proc sp_calificaciones
@cal1 int, @cal2 int, @cal3 int, @cal4 int as
declare @prom numeric (12,2)

select @prom = (@cal1 + @cal2 + @cal3 + @cal4)/4

select @prom
go
--ejecucion
exec sp_calificaciones 34,56,79,80

--se puede cambiar el orden de los parametros indicando el nombre antes del valor
exec sp_calificaciones @cal2 = 56, @cal3 = 79, @cal4 = 89, @cal1 = 34

--4 con parametro de salida ramire

--sp que reciba 4 calificaciones y regrese como parametro de salida el promedio 
--y si fue aprobado
go
create proc sp_calificaciones_sal
@cal1 int, @cal2 int, @cal3 int, @cal4 int, 
@prom numeric(12,3) output, @tipo char(20) output as

select @prom = (@cal1+@cal2+@cal3+@cal4)/4.0

if @prom >=70
	select @tipo = 'Aprobado'
else 
	select @tipo = 'Reprobado'
go
--ejecutarlo
declare @a numeric (12,3), @b char(20)
select @a, @b
exec sp_calificaciones_sal 70,80,60,70, @a output, @b output
select calificacion = @a, resultado = @b

--5 por valor por retorno

--valor por retorno utiliza la palabra reservada return y
--regresa solo valores enteros
go
create proc SP_CALIFICACIONESReturn
@cal1 int, @cal2 int, @cal3 int, @cal4 int as

declare @prom int
select @prom =(@cal1+@cal2+@cal3+@cal4)/4.0

return @prom
go
--ejecucion
declare @a integer
select @a
exec @a = SP_CALIFICACIONESReturn 60,80,98,70
select @a

--6 con valores predefinidos

--procedimiento que recibe parametros y tiene valores predefinidos

--declaracion
go
create proc sp_recibir_default
@val1 int, @val2 int,
@val3 int = 20, @val4 int = 30 as

declare @total int
select @total = @val1+@val2+@val3+@val4
select @total
go
--ejecucion 
exec sp_recibir_default 2,4,5,6
--se puede omitir los 2 ultimos valores
exec sp_recibir_default 2,4

exec sp_recibir_default 2, 4, @val4 = 6

--sp que recibe la fecha de nacimiento y regrese por parametro de salida la edad exacta
go
create proc sp_edad @fecha datetime, @edad int output as

select @edad = DATEDIFF(yy, @fecha, GETDATE())

select @fecha = dateadd(yy, @edad, @fecha)

if @fecha> GETDATE()
	select @edad = @edad-1
go

--ejecucion
declare @r int
exec sp_edad '10-11-2000', @r output
select @r

--sp que imprima una tabla con el nombre del empleado y su edad exacta
go
create proc sp_edad_todos as
declare @emp int, @edadexacta int, @fechanac datetime
create table #aux (emp int, edadexacta int)

select @emp=min(employeeid) from employees
while @emp is not null
begin 
	select @fechanac = birthdate from employees where EmployeeID = @emp
	exec sp_edad @fechanac, @edadexacta output

	insert into #aux values (@emp, @edadexacta)

	select @emp=min(employeeid) from employees where EmployeeID > @emp
end
select nombre = e.firstname + ' ' +e.lastname, e.birthdate, edadExacta = @edadexacta
from #aux a
inner join employees e on e.EmployeeID = a.emp
go
--ejecucion
exec sp_edad_todos