--darle acceso al IS mario a la bd ventas
use ventas
create user mario

--ejemplo 2

create database envios
go
use Envios
go
create table Empleados(
cte int primary key, nombre varchar(50), domicilio varchar(50)
--activamos el usuario GUEST en la bd envios
--el IS Mario se puede conectar a la bd envios
use Envios
grant connect to guest

--desactivar el usuario GUEST en la bd envios
REVOKE CONNECT FROM GUEST

--ejemplo 3
sp_helplogins mario
--agregar al IS mario a la funcion SECURITYADMIN
--puede ejecutar el comando CREATE LOGIN
sp_addSRVRoleMember mario, SECURITYADMIN

--agregar al IS mario a la funcion DBCREATOR
--puede crear DB y ejecutar el comando RETSTORE DATABASE
sp_addSRVRoleMember mario, DBCREATOR

--agregar al IS mario a la funcion PROCESSADMIN
--para que elimine procesos con el comando KILL
sp_addSRVRoleMember mario, PROCESSADMIN

--agregar al IS mario a la funcion SERVERADMIN
--puede ejecutar el comando SHUTDOWN
sp_addSRVRoleMember mario, SERVERADMIN

--muestra las funciones y sus miembros
sp_helpsrvrolemember

