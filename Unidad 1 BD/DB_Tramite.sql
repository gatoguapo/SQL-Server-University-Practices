/* Creación de la Base de Datos */
CREATE DATABASE Tramite
GO
USE Tramite
GO

/* Creación de las tablas */
CREATE TABLE Tipos
(
	TipoID INT NOT NULL,
	TipoNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Ventanillas
(
	VenID INT NOT NULL,
	VenNombre NVARCHAR(50) NOT NULL,
	TipoID INT NOT NULL
)
GO

CREATE TABLE Estados
(
	EdoID INT NOT NULL,
	EdoNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Municipios
(
	MunID INT NOT NULL,
	MunNombre NVARCHAR(50) NOT NULL,
	EdoID INT NOT NULL
)
GO

CREATE TABLE Colonias
(
	ColID INT NOT NULL,
	ColNombre NVARCHAR(50),
	MunID INT NOT NULL
)
GO

CREATE TABLE Usuarios
(
	UsuID INT NOT NULL,
	UsuNombre NVARCHAR(50) NOT NULL,
	UsuApePat NVARCHAR(50) NOT NULL,
	UsuApeMat NVARCHAR(50) NULL,
	UsuDomicilio NVARCHAR(200) NULL,
	UsuTelefono NCHAR(10) NULL,
	UsuCURP NCHAR(18) NULL,
	UsuRFC NCHAR(13) NULL,
	UsuCorreo NVARCHAR(50) NULL,
	ColID INT NOT NULL
)
GO

CREATE TABLE Familias
(
	FamID INT NOT NULL,
	FamNombre NVARCHAR(50)
)
GO

CREATE TABLE Tramites
(
	TramID INT NOT NULL,
	TramNombre NVARCHAR(50) NOT NULL,
	TramDescripcion NVARCHAR(200) NOT NULL,
	TramCosto NUMERIC(10,2) NOT NULL,
	FamID INT NOT NULL
)
GO

CREATE TABLE Dependencias
(
	DenID INT NOT NULL,
	DenNombre NVARCHAR(50) NOT NULL,
	DenDomicilio NVARCHAR(200) NOT NULL,
	DenTelefono NCHAR(10) NOT NULL
)
GO

CREATE TABLE Departamentos
(
	DepID INT NOT NULL,
	DepNombre NVARCHAR(50),
	DepDomicilio NVARCHAR(200),
	DepTelefono NCHAR(10),
	DenID INT NOT NULL
)
GO

CREATE TABLE Empleados
(
	EmpID INT NOT NULL,
	EmpNombre NVARCHAR(50) NOT NULL,
	EmpApePat NVARCHAR(50) NOT NULL,
	EmpApeMat NVARCHAR(50) NULL,
	EmpDomicilio NVARCHAR(200) NULL,
	EmpTelefono NCHAR(50) NULL,
	EmpCURP NCHAR(18) NULL,
	EmpRFC NCHAR(13) NULL,
	EmpCorreo NVARCHAR(50) NULL,
	DepID INT NOT NULL
)
GO

CREATE TABLE Registro
(
	Folio INT NOT NULL,
	FechaCaptura DATETIME NOT NULL,
	VenID INT NOT NULL,
	EmpID INT NOT NULL,
	UsuID INT NOT NULL
)
GO

CREATE  TABLE TramitesXRegistro
(
	Folio INT NOT NULL,
	TramID INT NOT NULL,
	FechaFinal DATETIME NOT NULL,
	Costo NUMERIC(10,2) NOT NULL
)
GO



/*	Tipos, Ventanillas, Estados, Municipios, Colonias, Usuarios, Familias, Tramites, Dependencias, Departamentos,
	Empleados, Registro, TramitesXRegistro*/

/* Creación de las llaves primarias*/
ALTER TABLE Tipos ADD CONSTRAINT PK_Tipos PRIMARY KEY (TipoID)
GO
ALTER TABLE Ventanillas ADD CONSTRAINT PK_Ventanillas PRIMARY KEY (VenID)
GO
ALTER TABLE Estados ADD CONSTRAINT PK_Estados PRIMARY KEY (EdoID)
GO
ALTER TABLE Municipios ADD CONSTRAINT PK_Municipios PRIMARY KEY (MunID)
GO
ALTER TABLE Colonias ADD CONSTRAINT PK_Colonias PRIMARY KEY (ColID)
GO
ALTER TABLE Usuarios ADD CONSTRAINT PK_Usuarios PRIMARY KEY (UsuID)
GO
ALTER TABLE Familias ADD CONSTRAINT PK_Familias PRIMARY KEY (FamID)
GO
ALTER TABLE Tramites ADD CONSTRAINT PK_Tramites PRIMARY KEY (TramID)
GO
ALTER TABLE Dependencias ADD CONSTRAINT PK_Dependencias PRIMARY KEY (DenID)
GO
ALTER TABLE Departamentos ADD CONSTRAINT PK_Departamentos PRIMARY KEY (DepID)
GO
ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados PRIMARY KEY (EmpID)
GO
ALTER TABLE Registro ADD CONSTRAINT PK_Registros PRIMARY KEY (Folio)
GO
ALTER TABLE TramitesXRegistro ADD CONSTRAINT PK_TramitesXRegistro PRIMARY KEY (Folio,TramID)
GO



/*	Ventanillas-Tipos, Municipios-Estados, Colonias-Municipios, Usuarios-Colonias, Tramites-Familias,
	Departamentos-Dependencias, Empleados-Departamentos, Registro-Ventanillas, Registro-Empleados, Registro-Usuarios,
	TramitesXRegistro-Registro, TramitesXRegistro-Tramites */

/* Creación de las llaves foráneas */
ALTER TABLE Ventanillas ADD CONSTRAINT PK_Ventanillas_Tipos
	FOREIGN KEY (TipoID) REFERENCES Tipos(TipoID)
GO

ALTER TABLE Municipios ADD CONSTRAINT PK_Municipios_Estados
	FOREIGN KEY (EdoID) REFERENCES Estados(EdoID)
GO

ALTER TABLE Colonias ADD CONSTRAINT PK_Colonias_Municipios
	FOREIGN KEY (MunID) REFERENCES Municipios(MunID)
GO

ALTER TABLE Usuarios ADD CONSTRAINT PK_Usuarios_Colonias
	FOREIGN KEY (ColID) REFERENCES Colonias(ColID)
GO

ALTER TABLE Tramites ADD CONSTRAINT PK_Tramites_Familias
	FOREIGN KEY (FamID) REFERENCES Familias(FamID)
GO

ALTER TABLE Departamentos ADD CONSTRAINT PK_Departamentos_Dependencias
	FOREIGN KEY (DenID) REFERENCES Dependencias(DenID)
GO

ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados_Departamentos
	FOREIGN KEY (DepID) REFERENCES Departamentos(DepID)
GO

ALTER TABLE Registro ADD CONSTRAINT PK_Registro_Ventanillas
	FOREIGN KEY (VenID) REFERENCES Ventanillas(VenID)
GO
ALTER TABLE Registro ADD CONSTRAINT PK_Registro_Empleados
	FOREIGN KEY (EmpID) REFERENCES Empleados(EmpID)
GO
ALTER TABLE Registro ADD CONSTRAINT PK_Registro_Usuario
	FOREIGN KEY (UsuID) REFERENCES Usuarios(UsuID)
GO

ALTER TABLE TramitesXRegistro ADD CONSTRAINT PK_TramitesXRegistro_Registro
	FOREIGN KEY (Folio) REFERENCES Registro(Folio)
GO
ALTER TABLE TramitesXRegistro ADD CONSTRAINT PK_TramitesXRegistro_Tramites
	FOREIGN KEY (TramID) REFERENCES Tramites(TramID)
GO



/* Usuarios-UsuCURP, Usuarios-UsuRFC, Empleados-EmpCURP, Empleados-EmpRFC */

/* Creación de llaves Únicas*/ 
ALTER TABLE Usuarios ADD CONSTRAINT UC_Usuarios_CURP UNIQUE (UsuCURP)
GO
ALTER TABLE Usuarios ADD CONSTRAINT UC_Usuarios_RFC UNIQUE (UsuRFC)
GO

ALTER TABLE Empleados ADD CONSTRAINT UC_Empleados_CURP UNIQUE (EmpCURP)
GO
ALTER TABLE Empleados ADD CONSTRAINT UC_Empleados_RFC UNIQUE (EmpRFC)
GO



/*	Usuarios-UsuApeMat, Usuarios-UsuDomicilio, Usuarios-UsuTelefono, Usuarios-UsuCorreo
	Empleados-EmpApeMat, Empleados-EmpDomicilio, Empleados-EmpTelefono, Empleados-EmpCorreo */

/* Creación de llaves predeterminadas */
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_UsuApeMat DEFAULT ('Sin Apellido Materno') FOR UsuApeMat
GO
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_UsuDomicilio DEFAULT ('Sin Domicilio') FOR UsuDomicilio
GO
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_UsuTelefono DEFAULT ('Sin Telefono') FOR UsuTelefono
GO
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_UsuCorreo DEFAULT ('Sin Correo') FOR UsuCorreo
GO

ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpApeMat DEFAULT ('Sin Apellido Materno') FOR EmpApeMat
GO
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpDomicilio DEFAULT ('Sin Domicilio') FOR EmpDomicilio
GO
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpTelefono DEFAULT ('Sin Telefono') FOR EmpTelefono
GO
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpCorreo DEFAULT ('Sin Correo') FOR EmpCorreo
GO



/* Usuario - UsuCURP<>UsuRFC,  Empleados - EmpCURP<>EmpRFC*/

/* Creación de las restricciones de comprobacion */
ALTER TABLE Usuarios ADD CONSTRAINT CC_Usuarios_CURP_RFC CHECK (UsuCURP<>UsuRFC)
GO

ALTER TABLE Empleados ADD CONSTRAINT CC_Empleados_CURP_RFC CHECK (EmpCURP<>EmpRFC)
GO

ALTER TABLE Registro ADD CONSTRAINT CC_Registro_FechaCaputra CHECK (FechaCaptura > '1-1-2018')
GO

ALTER TABLE Tramites ADD CONSTRAINT CC_Tramites_TramCosto CHECK (TramCosto > 0)
GO

ALTER TABLE TramitesXRegistro ADD CONSTRAINT CC_TramitesXRegistro CHECK (Costo > 0)
GO



/* Inserciones a las tablas */
USE Tramite
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
INSERT TramitesxRegistro VALUES (1,1,'2021-04-07',63354324.76)
INSERT TramitesxRegistro VALUES (2,2,'2022-05-16',54243123.16)
INSERT TramitesxRegistro VALUES (3,3,'2021-04-23',42352123.12)
INSERT TramitesxRegistro VALUES (4,4,'2020-02-25',64334521.86)
INSERT TramitesxRegistro VALUES (5,5,'2023-02-01',54312234.54)
GO