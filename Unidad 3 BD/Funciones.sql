/* Tipos de funciones definidas por los usuarios
SQL utiliza tres tipos de funciones:
1.-las funciones escalares,
2.-tabla en linea,
3.-funciones de tabla de multi sentencias

Los tres tipos de funciones aceptan parametros de cualquier tipo excepto el rowversion.
Las funciones escalares devuelven un solo valor, tabla en linea y Multisentencias devuelven 
un tipo de dato tabla.

Limitaciones
Las funciones definidas por el usuario tienen algunas restricciones. No todas las sentencias SQL son 
validas dentro de una funcion

Invalidas:
-Sentencias de modificaciones o actualizacion de tablas o vistas sobre tablas de usaurio
(update,delete,insert)
-Operaciones CURSOR FETCH que devuelven datos del cliente.
-No se pueden utilizar procedimientos almacenados dentro de la funcion
-No se pueden utilizar tablas temporales.

Valido:
-Las sentencias de asignacion.
-Las sentencias de Control de Flujo while, if.
-Sentencias SELECT y modificacion de variables locales
-Operaciones de cursores sobre variables locales
-Sentencias INSERT, UPDATE, DELETE con variables Locales tipo Tabla

1.-Funciones Escalares
Las funciones escalares devuelven un tipo de los datos tal como int, money, varchar, real, etc.
Pueden ser utilizadas en cualquier lugar incluso incorporada dentro de sentencias SQL.

La sintaxis para una funcion escalar es la siguiente:

CREATE FUNCTION [NombrePropietario.]NombreFuncion
(@nombreParametro TipoDato[= default],...)
RETURNS TipoDatoRetorno
AS 
BEGIN
	CuerpoFuncion

	RETURN ValorRetorno
END

-funcion que calcula el cubo de un numero */
CREATE FUNCTION dbo.Cubo(@num numeric(12,2))
RETURNS numeric (12,2)
AS
BEGIN
	RETURN (@num*@num*@num)
END
go
--ejecucion
select dbo.cubo(3)

declare @R numeric (12,2)
select @R = dbo.cubo(3)
select @R 

--nombre y precio del producto al cubo
select productname, 'precio cubo' = dbo.cubo (unitprice) from products