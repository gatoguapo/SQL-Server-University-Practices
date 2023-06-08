/* Creación de la Base de Datos */
CREATE DATABASE Ferreteria
GO
USE Ferreteria
GO

/* Creación de las tablas */
CREATE TABLE Zonas 
(
	ZonaID INT NOT NULL,
	ZonaNombre NVARCHAR(50) NOT NULL,
	ZonaDescripcion NVARCHAR(200) NOT NULL
)
GO

CREATE TABLE Empleados
(
	EmpID INT NOT NULL,
	EmpNombre NVARCHAR(50) NOT NULL,
	EmpApePat NVARCHAR(50) NOT NULL,
	EmpApeMat NVARCHAR(50) NULL,
	EmpDomicilio NVARCHAR(200) NOT NULL,
	EmpTelefono NCHAR(10) NULL,
	EmpCelular NCHAR(10) NULL,
	EmpRFC NCHAR(13) NULL,
	EmpCURP NCHAR(18)NULL,
	EmpFechaIngreso DATETIME NOT NULL,
	EmpFechaNacimiento DATETIME NOT NULL,
	ZonaID INT NOT NULL,
	JefeID INT NULL
)
GO

CREATE  TABLE Municipios
(
	MunID INT NOT NULL,
	MunNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Colonias
(
	ColID INT NOT NULL,
	ColNombre NVARCHAR(50) NOT NULL,
	ColCP NCHAR(5) NOT NULL,
	MunID INT NOT NULL
)
GO

CREATE TABLE Clientes
(
	CteID INT NOT NULL,
	CteNombre NVARCHAR(50) NOT NULL,
	CteApePat NVARCHAR(50) NOT NULL,
	CteApeMat NVARCHAR(50) NULL,
	CteDomicilio NVARCHAR(200) NOT NULL,
	CteTelefono NCHAR (10) NULL,
	CteCelular NCHAR(10) NULL,
	CteRFC NCHAR(13) NULL,
	CteCURP NCHAR(18) NULL,
	CteFechaNacimiento DATETIME NOT NULL,
	CteSexo NCHAR(1) NOT NULL,
	ColID INT NOT NULL
)
GO
CREATE TABLE Familias
(
	FamID INT NOT NULL,
	FamNombre NVARCHAR(50) NOT NULL,
	FamDescripcion NVARCHAR(200) NOT NULL
)
GO

CREATE TABLE Articulos
(
	ArtID INT NOT NULL,
	ArtNombre NVARCHAR(50) NOT NULL,
	ArtDescription NVARCHAR(200) NOT NULL,
	Precio NUMERIC(10,2) NOT NULL,
	FamID INT NOT NULL
)
GO

CREATE TABLE Ferreterias
(
	FerrID INT NOT NULL,
	FerrNombre NVARCHAR(50) NOT NULL,
	FerrDomicilio NVARCHAR(200) NOT NULL,
	FerrTelefono NCHAR(10) NOT NULL,
)
GO

CREATE TABLE Ventas
(
	Folio INT NOT NULL,
	Fecha DATETIME NOT NULL,
	CteID INT NOT NULL,
	EmpID INT NOT NULL,
	FerrID INT NOT NULL
)
GO

CREATE TABLE Detalle
(
	Folio INT NOT NULL,
	ArtID INT NOT NULL,
	Cantidad NCHAR(5) NOT NULL,
	Precio NUMERIC(10,2) NOT NULL
)
GO



/* Zonas, Empleados, Municipios, Colonias, Clientes, Familias, Articulos, Ferraterias, Ventas, Detalle */

/* Creación de las llaves primarias*/
ALTER TABLE Zonas ADD CONSTRAINT PK_Zonas PRIMARY KEY (ZonaID)
GO
ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados PRIMARY KEY (EmpID)
GO
ALTER TABLE Municipios ADD CONSTRAINT PK_Municipios PRIMARY KEY (MunID)
GO
ALTER TABLE Colonias ADD CONSTRAINT PK_Colonias PRIMARY KEY (ColID)
GO
ALTER TABLE Clientes ADD CONSTRAINT PK_Clientes PRIMARY KEY (CteID)
GO
ALTER TABLE Familias ADD CONSTRAINT PK_Familias PRIMARY KEY (FamID)
GO
ALTER TABLE Articulos ADD CONSTRAINT PK_Articulos PRIMARY KEY (ArtID)
GO
ALTER TABLE Ferreterias ADD CONSTRAINT PK_Ferreterias PRIMARY KEY (FerrID)
GO
ALTER TABLE Ventas ADD CONSTRAINT PK_Ventas PRIMARY KEY (Folio)
GO
ALTER TABLE Detalle ADD CONSTRAINT PK_Detalle PRIMARY KEY (Folio, ArtID)
GO



/*	Empleados-Zonas,  Empleados-JefeID, Colonias-Municipios, Clientes-Colonias, Articulos-Familias,
	Ventas-Clientes, Ventas-Empleados, Ventas-Ferreterias, Detalle-Articulos, Detalle-Ventas */

/* Creación de las llaves foráneas */
ALTER TABLE Empleados ADD CONSTRAINT FK_Empleados_Zonas
	FOREIGN KEY (ZonaID) REFERENCES Zonas(ZonaID)
GO
ALTER TABLE Empleados ADD CONSTRAINT FK_Empleados_JefeID
	FOREIGN KEY (JefeID) REFERENCES Empleados(EmpID)
GO

ALTER TABLE Colonias ADD CONSTRAINT FK_Colonias_Municipios
	FOREIGN KEY (MunID) REFERENCES Municipios(MunID)
GO

ALTER TABLE Clientes ADD CONSTRAINT FK_Clientes_Colonias
	FOREIGN KEY (ColID) REFERENCES Colonias(ColID)
GO

ALTER TABLE Articulos ADD CONSTRAINT FK_Articulos_Familias
	FOREIGN KEY (FamID) REFERENCES Familias(FamID)
GO

ALTER TABLE Ventas ADD CONSTRAINT FK_Ventas_Clientes
	FOREIGN KEY (CteID) REFERENCES Clientes(CteID)
GO
ALTER TABLE Ventas ADD CONSTRAINT FK_Ventas_Empleados
	FOREIGN KEY (EmpID) REFERENCES Empleados(EmpID)
GO
ALTER TABLE Ventas ADD CONSTRAINT FK_Ventas_Ferreterias
	FOREIGN KEY (FerrID) REFERENCES Ferreterias(FerrID)
GO

ALTER TABLE Detalle ADD CONSTRAINT FK_Detalle_Ventas
	FOREIGN KEY (Folio) REFERENCES Ventas(Folio)
GO
ALTER TABLE Detalle ADD CONSTRAINT FK_Detalle_Articulos
	FOREIGN KEY (ArtID) REFERENCES Articulos(ArtID)
GO


/* Clientes-CteCURP, Clientes-CteRFC, Empleados-EmpCURP, Empleados-EmpRFC */

/* Creación de las llaves únicas */
ALTER TABLE Clientes ADD CONSTRAINT UC_Clientes_CURP UNIQUE (CteCURP)
GO
ALTER TABLE Clientes ADD CONSTRAINT UC_Clientes_RFC UNIQUE (CteRFC)
GO

ALTER TABLE Empleados ADD CONSTRAINT UC_Empleados_CURP UNIQUE (EmpCURP)
GO
ALTER TABLE Empleados ADD CONSTRAINT UC_Empleados_RFC UNIQUE (EmpRFC)
GO



/* Empleados-EmpDomicilio, Empleados-EmpTelefono, Clientes-CteDomicilio, Clientes-CteTelefono */

/* Creación de las llaves predeterminadas */
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpDomicilio DEFAULT ('Sin Domicilio') FOR EmpDomicilio
GO
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_EmpTelefono DEFAULT ('Sin Telefono') FOR EmpTelefono
GO

ALTER TABLE Clientes ADD CONSTRAINT DC_Clientes_CteDomicilio DEFAULT ('Sin Domicilio') FOR CteDomicilio
GO
ALTER TABLE Clientes ADD CONSTRAINT DC_Clientes_CteTelefono DEFAULT ('Sin Telefono') FOR CteTelefono
GO

ALTER TABLE Articulos ADD CONSTRAINT DC_Articulos_ArtDescription DEFAULT ('Sin Descripcion') FOR ArtDescription

/* Clientes-CteSexo, Clientes-CteCURP<>CteRFC, Articulos-ArtPrecio, Ventas-Fecha, Detalle-Precio, Detalle-Cantidad */

/* Creación de las restricciones de comprobación */
ALTER TABLE Clientes ADD CONSTRAINT CC_Clientes_CteSexo CHECK (CteSexo IN ('M','F')) 
GO
ALTER TABLE Clientes ADD CONSTRAINT CC_Clientes_CURP_RFC CHECK (CteCURP <> CteRFC)
GO

ALTER TABLE Articulos ADD CONSTRAINT CC_Articulos_ArtPrecio CHECK (Precio > 0)
GO

ALTER TABLE Ventas ADD CONSTRAINT CC_Ventas_Fecha CHECK (Fecha > '1-1-2018')
GO

ALTER TABLE Detalle ADD CONSTRAINT CC_Detalle_Precio CHECK (Precio > 0)
GO
ALTER TABLE Detalle ADD CONSTRAINT CC_Detalle_Cantidad CHECK (Cantidad > 0)
GO



/* Inserciones a las tablas */
INSERT Zonas VALUES (1,'Norte', 'Zona Norte')
INSERT Zonas VALUES (2,'Sur', 'Zona Sur')
INSERT Zonas VALUES (3,'Oeste', 'Zona Oeste')
INSERT Zonas VALUES (4,'Este', 'Zona Este')
INSERT Zonas VALUES (5,'Centro', 'Zona Centro')
GO

INSERT Empleados VALUES (1, 'Claudio', 'Rodriguez', 'Ochoa','Lazaro Cardenas',
6677427110, 6653615173, 'ROOC3742745NR', 'ROOC001217ASSZOYA2', '01-01-2020','12-17-2000',1, 1)
INSERT Empleados VALUES (2, 'Victor', 'Grande', 'Vega','Col. obregon',
6674467912, 6673415273, 'GRVV3642445FN', 'GRVV010411ASSZOYA2', '08-10-2021','11-04-2001',1, 1)
INSERT Empleados VALUES (3, 'Pepe', 'Perez', 'Rocha','Antonio Rosales',
6673457972, 6671414279, 'PERP364F445GQ', 'PERP010411XSGZOYA3', '05-12-2019','07-27-2000',1, 1)
INSERT Empleados VALUES (4, 'Elias', 'Grande', 'Orozco','Guadalupe',
6671657572, 6672027631, 'GAOJ020213', 'GAOJ020213HSLRRSA8', '01-02-2022','01-02-2002',1, 1)
INSERT Empleados VALUES (5, 'Alexsandra', 'Velazquez', 'Anaya','5 de mayo',
6674782093, 6672219031, 'VEAA020213', 'VEAA020924HSLRRSA8', '02-04-2022','01-09-2002',1, 1)
GO

INSERT Municipios VALUES (1, 'Culiacán')
INSERT Municipios VALUES (2, 'Mazatlán')
INSERT Municipios VALUES (3, 'Concordia')
INSERT Municipios VALUES (4, 'Mocorito')
INSERT Municipios VALUES (5, 'Badiraguato')
GO

INSERT Colonias values( 1, 'Col. Obregon' , 80295, 1 )
INSERT Colonias VALUES (2, 'Lazaro Cardenas', 80290, 1)
INSERT Colonias VALUES (3, 'Antonio Rosales', 80220, 1)
INSERT Colonias VALUES (4, 'Guadalupe', 80230, 1)
INSERT Colonias VALUES (5, '5 de mayo', 80230, 1)
GO

INSERT Clientes VALUES (1, 'Alan', 'Meza', 'Valenzuela', 'Lazaro Cardenas', 
6675447918, 6644665183, 'MEVA5732545JF', 'MEVA020915HSLZLLA2', '09-09-2002','M',2)
INSERT Clientes VALUES (2, 'Rogelio Samuel', 'Moreno', 'Corrales', 'Col. Obregon', 
6675982918, 6674685193, 'MOCO5732545JF', 'MOCO020823HSLZHYA2', '10-08-2002','M',1)
INSERT Clientes VALUES (3, 'Maia Paulina', 'Ruelas', 'Gutierrez', 'Antonio Rosales', 
6675382217, 6674285297, 'RUGM5732543JF', 'RUGM020315HSSZHTA2', '07-03-2002','F',3)
INSERT Clientes VALUES (4, 'Luis Orlando', 'Reza', 'Arzola', 'Guadalupe', 
6675485517, 6671294290, 'REAL5732543AL', 'REAL011110HUSZHTA1', '10-11-2001','M',4)
INSERT Clientes VALUES (5, 'Carlos Alfonso', 'Higuera', 'Rocha', '5 de mayo', 
6677684517, 6679298290, 'HIRC5982543AL', 'HIRC020731HUSZHTA1', '05-07-2002','M',5)
GO

INSERT Familias VALUES (1, 'Agricultura','')
INSERT Familias VALUES (2, 'Carpinteria','')
INSERT Familias VALUES (3, 'Plomeria','')
INSERT Familias VALUES (4, 'Construcción','')
INSERT Familias VALUES (5, 'Casa','')
GO

INSERT Articulos VALUES (1, 'Martillo', '', 50, 2)
INSERT Articulos VALUES (2, 'Destornillador', '', 30, 5)
INSERT Articulos VALUES (3, 'Serrucho', '', 100, 2)
INSERT Articulos VALUES (4, 'Tornillo 1mm', '', 1, 4)
INSERT Articulos VALUES (5, 'Pala', '', 70, 5)
GO
INSERT Ferreterias VALUES (1, 'Ferreteria norte', 'Col. obregon', '6677239845')
INSERT Ferreterias VALUES (2, 'Ferreteria sur', 'Antonio Rosales', '6677256828')
INSERT Ferreterias VALUES (3, 'Ferreteria este', '5 de mayo', '6671256824')
INSERT Ferreterias VALUES (4, 'Ferreteria oeste', 'Guadalupe', '6672256824')
INSERT Ferreterias VALUES (5, 'Ferreteria norte 2', 'Lazaro Cardenas', '6677296824')
GO