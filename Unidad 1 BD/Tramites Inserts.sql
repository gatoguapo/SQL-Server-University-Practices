--Inserts a las tablas de tramites
USE Tramites
GO
INSERT Estados VALUES (1,'Sinaloa')
INSERT Estados VALUES (2,'Chihuahua')
INSERT Estados VALUES (3,'Estado de México')
INSERT Estados VALUES (4,'Jalisco')
INSERT Estados VALUES (5,'Nuevo León')
GO
INSERT Municipios VALUES (1,'Culiacán',1)
INSERT Municipios VALUES (2,'Mazatlan',1)
INSERT Municipios VALUES (3,'Toluca de Lerdo',3)
INSERT Municipios VALUES (4,'Guadalajara',4)
INSERT Municipios VALUES (5,'Zapopan',4)
GO
INSERT Colonias VALUES (1,'Las Américas',1)
INSERT Colonias VALUES (2,'Alameda',2)
INSERT Colonias VALUES (3,'Bosques de San Mateo',3)
INSERT Colonias VALUES (4,'Atlas',4)
INSERT Colonias VALUES (5,'Bellavista',5)
GO
INSERT Usuarios VALUES (1,'Yahir','Ramirez','Sanchez', 'Domicilio1',6672382131,'100000000000000000','1000000000000','Correo1',1)
INSERT Usuarios VALUES (2,'Clemente','Garcia Gerardo','ApeMat2', 'Domicilio2',6676823841,'200000000000000000','2000000000000','Correo2',1)
INSERT Usuarios VALUES (3,'Victor','Grande','ApeMat3', 'Domicilio3',6674275934,'300000000000000000','3000000000000','Correo3',4)
INSERT Usuarios VALUES (4,'Jesus','Gastelum','ApeMat4', 'Domicilio4',6675482981,'400000000000000000','4000000000000','Correo4',5)
INSERT Usuarios VALUES (5,'Luis Orlando','Reza','ApeMat5', 'Domicilio5',6675728654,'500000000000000000','5000000000000','Correo5',3)
GO
INSERT Familias VALUES (1,'Familia1')
INSERT Familias VALUES (2,'Familia2')
INSERT Familias VALUES (3,'Familia3')
INSERT Familias VALUES (4,'Familia4')
INSERT Familias VALUES (5,'Familia5')
GO
INSERT Tramites VALUES (1,'Tramite1','Descripcion1',54234575.31,1)
INSERT Tramites VALUES (2,'Tramite2','Descripcion2',63354324.76,2)
INSERT Tramites VALUES (3,'Tramite3','Descripcion3',74241241.43,3)
INSERT Tramites VALUES (4,'Tramite4','Descripcion4',43643451.13,4)
INSERT Tramites VALUES (5,'Tramite5','Descripcion5',64523424.32,5)
GO
INSERT Dependencias VALUES (1,'Dependencia1', 'DenDomicilio1', 6673423114)
INSERT Dependencias VALUES (2,'Dependencia2', 'DenDomicilio2', 6673436532)
INSERT Dependencias VALUES (3,'Dependencia3', 'DenDomicilio3', 6674543211)
INSERT Dependencias VALUES (4,'Dependencia4', 'DenDomicilio4', 6674325213)
INSERT Dependencias VALUES (5,'Dependencia5', 'DenDomicilio5', 6677842663)
GO
INSERT Departamentos VALUES (1,'Departamento1','DepDomicilio1',6678328711,1)
INSERT Departamentos VALUES (2,'Departamento2','DepDomicilio2',6675435211,2)
INSERT Departamentos VALUES (3,'Departamento3','DepDomicilio3',6676541251,3)
INSERT Departamentos VALUES (4,'Departamento4','DepDomicilio4',6672845623,4)
INSERT Departamentos VALUES (5,'Departamento5','DepDomicilio5',6678352345,5)
GO
INSERT Empleados VALUES (1,'EmpNombre1','EmpApePat1','EmpApeMat1','EmpDomicilio1',6675433141,'100000000000000000','1000000000000','EmpCorreo1',1)
INSERT Empleados VALUES (2,'EmpNombre2','EmpApePat2','EmpApeMat2','EmpDomicilio2',6675436213,'200000000000000000','2000000000000','EmpCorreo2',2)
INSERT Empleados VALUES (3,'EmpNombre3','EmpApePat3','EmpApeMat3','EmpDomicilio3',6676542341,'300000000000000000','3000000000000','EmpCorreo3',3)
INSERT Empleados VALUES (4,'EmpNombre4','EmpApePat4','EmpApeMat4','EmpDomicilio4',6677412464,'400000000000000000','4000000000000','EmpCorreo4',4)
INSERT Empleados VALUES (5,'EmpNombre5','EmpApePat5','EmpApeMat5','EmpDomicilio5',6678553452,'500000000000000000','5000000000000','EmpCorreo5',5)
GO
INSERT Tipos VALUES (1,'Tipo1')
INSERT Tipos VALUES (2,'Tipo2')
INSERT Tipos VALUES (3,'Tipo3')
INSERT Tipos VALUES (4,'Tipo4')
INSERT Tipos VALUES (5,'Tipo5')
GO
INSERT Ventanillas VALUES (1,'Ventanilla1',1)
INSERT Ventanillas VALUES (2,'Ventanilla2',2)
INSERT Ventanillas VALUES (3,'Ventanilla3',3)
INSERT Ventanillas VALUES (4,'Ventanilla4',4)
INSERT Ventanillas VALUES (5,'Ventanilla5',5)
GO
INSERT Registro VALUES (1,'2021-02-15',1,1,1)
INSERT Registro VALUES (2,'2020-03-23',2,2,2)
INSERT Registro VALUES (3,'2021-04-07',3,3,3)
INSERT Registro VALUES (4,'2021-12-21',4,4,4)
INSERT Registro VALUES (5,'2022-07-05',5,5,5)
GO
INSERT TramitesxRegistros VALUES (1,1,'2021-04-07',63354324.76)
INSERT TramitesxRegistros VALUES (2,2,'2022-05-16',54243123.16)
INSERT TramitesxRegistros VALUES (3,3,'2021-04-23',42352123.12)
INSERT TramitesxRegistros VALUES (4,4,'2020-02-25',64334521.86)
INSERT TramitesxRegistros VALUES (5,5,'2023-02-01',54312234.54)
GO