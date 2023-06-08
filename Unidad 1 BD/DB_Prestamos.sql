CREATE DATABASE PRESTAMOS
GO
USE PRESTAMOS
GO

CREATE TABLE Sucursales (
	SucId INT NOT NULL,
	SucNombre NVARCHAR(50) NOT NULL,
	SucDominio NVARCHAR(200) NOT NULL,
	SucTelefono NCHAR(10) NULL
)
GO

CREATE TABLE Empleados (
	EmpID INT NOT NULL,
	EmpNombre NVARCHAR(50) NOT NULL,
	EmpApellidos NVARCHAR(50) NOT NULL,
	EmpTelefono NCHAR(10) NULL,
	EmpCorreo Nvarchar(50) NULL --CHECAR SI ESTA BIEN O NO
)
GO

CREATE TABLE Estados (
	EdoID INT NOT NULL,
	EdoNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Municipios (
	MunID INT NOT NULL,
	MunNombre NVARCHAR(50) NOT NULL,
	EdoID INT NOT NULL
)
GO

CREATE TABLE Colonias (
	ColID INT NOT NULL,
	ColNombre NVARCHAR(50) NOT NULL,
	MunID INT NOT NULL
)
GO

CREATE TABLE Usuarios (
	UsuID INT NOT NULL,
	UsuNombre NVARCHAR(50) NOT NULL,
	UsuApellidos NVARCHAR(50) NOT NULL,
	UsuDomicilio NVARCHAR(200) NOT NULL,
	UsuTelefono NCHAR(10) NULL,
	UsuCorreo NVARCHAR(50) NULL,
	ColID INT NOT NULL
)
GO

CREATE TABLE Tamanios (
	TamID INT NOT NULL,
	TamNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Tipos (
	TipoID INT NOT NULL,
	TipoNombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE Piezas (
	PieID INT NOT NULL,
	PieNombre NVARCHAR(50) NOT NULL,
	PieDescripcion NVARCHAR(200) NOT NULL,
	PieValor NUMERIC(10,2) NOT NULL, 
	TamID INT NOT NULL,
	TipoID INT NOT NULL
)
GO

CREATE TABLE Prestamos (
	Folio INT NOT NULL,
	FechaCaptura DATETIME NOT NULL,
	Monto NUMERIC(10, 2),
	Mensualidad NUMERIC(10, 2) NOT NULL, 
	SucID INT NOT NULL,
	UsuID INT NOT NULL,
	EmpRealizo INT NOT NULL,
	EmpEvaluo INT NOT NULL,
	PieID INT NOT NULL
)
GO



/* Creacion de llaves primarias */
ALTER TABLE Sucursales ADD CONSTRAINT PK_Sucursales PRIMARY KEY (SucID)
GO
ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados PRIMARY KEY (EmpID)
GO
ALTER TABLE Estados ADD CONSTRAINT PK_Estados PRIMARY KEY (EdoID)
GO
ALTER TABLE Municipios ADD CONSTRAINT PK_Municipios PRIMARY KEY (MunID)
GO
ALTER TABLE Colonias ADD CONSTRAINT PK_Colonias PRIMARY KEY (ColID)
GO
ALTER TABLE Usuarios ADD CONSTRAINT PK_Usuarios PRIMARY KEY (UsuID)
GO
ALTER TABLE Tamanios ADD CONSTRAINT PK_Tamanios PRIMARY KEY (TamID)
GO
ALTER TABLE Tipos ADD CONSTRAINT PK_Tipos PRIMARY KEY (TipoID)
GO
ALTER TABLE Piezas ADD CONSTRAINT PK_Piezas PRIMARY KEY (PieID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT PK_Prestamos PRIMARY KEY (Folio)
GO



/* Creacion de llaves foráneas */
ALTER TABLE Municipios ADD CONSTRAINT FK_Municipios_Estados
	FOREIGN KEY (EdoID) REFERENCES Estados (EdoID)
GO
ALTER TABLE Colonias ADD CONSTRAINT FK_Colonias_Municipios
	FOREIGN KEY (MunID) REFERENCES Municipios (MunID)
GO
ALTER TABLE Usuarios ADD CONSTRAINT FK_Usuarios_Colonias
	FOREIGN KEY (ColID) REFERENCES Colonias (ColID)
GO
ALTER TABLE Piezas ADD CONSTRAINT FK_Piezas_Tamanios
	FOREIGN KEY (TamID) REFERENCES Tamanios(TamID)
GO
ALTER TABLE Piezas ADD CONSTRAINT FK_Piezas_Tipos
	FOREIGN KEY (TipoID) REFERENCES Tipos (TipoID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT FK_Prestamos_Sucursales
	FOREIGN KEY (SucID) REFERENCES Sucursales (SucID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT FK_Prestamos_Usuarios
	FOREIGN KEY (UsuID) REFERENCES Usuarios (UsuID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT FK_Prestamos_EmpleadoRealizo
	FOREIGN KEY (EmpRealizo) REFERENCES Empleados (EmpID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT FK_Prestamos_EmpleadoEvaluo
	FOREIGN KEY (EmpEvaluo) REFERENCES Empleados (EmpID)
GO
ALTER TABLE Prestamos ADD CONSTRAINT FK_Prestamos_Piezas
	FOREIGN KEY (PieID) REFERENCES Piezas (PieID)
GO



/* Creacion de llaves unicas */
ALTER TABLE Prestamos ADD CONSTRAINT UC_Prestamos_PieID UNIQUE (PieID)
GO



/* Creacion de valores predeterminadas */
ALTER TABLE Sucursales ADD CONSTRAINT DC_Sucursales_Telefono
	DEFAULT ('Sin Telefono') FOR SucTelefono
GO
ALTER TABLE Empleados ADD CONSTRAINT DC_Empleados_Telefono
	DEFAULT ('Sin Telefono') FOR EmpTelefono
GO
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_Domicilio
	DEFAULT ('Sin Domicilio') FOR UsuDomicilio
GO
ALTER TABLE Usuarios ADD CONSTRAINT DC_Usuarios_Telefono
	DEFAULT ('Sin Telefono') FOR UsuTelefono
GO



/* Creacion de restricciones de comprobacion */
ALTER TABLE Piezas ADD CONSTRAINT CC_Piezas_Valor
	CHECK (PieValor > 0)
GO
ALTER TABLE Prestamos ADD CONSTRAINT CC_Prestamos_Fecha
	CHECK (FechaCaptura > '1-1-2018')
GO
ALTER TABLE Prestamos ADD CONSTRAINT CC_Prestamos_Monto
	CHECK (Monto > 0)
GO
ALTER TABLE Prestamos ADD CONSTRAINT CC_Prestamos_Mensualidades
	CHECK (Mensualidad > 0)
GO



/* Inserciones a las tablas */
INSERT Sucursales VALUES(1,'Sucursal 1','Dominio 1',6673454365)
INSERT Sucursales VALUES(2,'Sucursal 2','Dominio 2',6673454365)
INSERT Sucursales VALUES(3,'Sucursal 3','Dominio 3',6673454365)
INSERT Sucursales VALUES(4,'Sucursal 4','Dominio 4',6673454365)
INSERT Sucursales VALUES(5,'Sucursal 5','Dominio 5',6673454365)
GO
INSERT Empleados VALUES(1,'Empleado 1','EmpApellido 1',6673472432,'Correo 1')
INSERT Empleados VALUES(2,'Empleado 2','EmpApellido 2',6675587398,'Correo 2')
INSERT Empleados VALUES(3,'Empleado 3','EmpApellido 3',6671293871,'Correo 3')
INSERT Empleados VALUES(4,'Empleado 4','EmpApellido 4',6673912801,'Correo 4')
INSERT Empleados VALUES(5,'Empleado 5','EmpApellido 5',6673012892,'Correo 5')
GO
INSERT Estados VALUES(1,'Sinaloa')
INSERT Estados VALUES(2,'Chihuahua')
INSERT Estados VALUES(3,'Estado de México')
INSERT Estados VALUES(4,'Jalisco')
INSERT Estados VALUES(5,'Nuevo León')
GO
INSERT Municipios VALUES(1,'Culiacán',1)
INSERT Municipios VALUES(2,'Mazatlan',1)
INSERT Municipios VALUES(3,'Toluca de Lerdo',3)
INSERT Municipios VALUES(4,'Guadalajara',4)
INSERT Municipios VALUES(5,'Zapopan',4)
GO
INSERT Colonias VALUES(1,'Las Américas',1)
INSERT Colonias VALUES(2,'Alameda',2)
INSERT Colonias VALUES(3,'Bosques de San Mateo',3)
INSERT Colonias VALUES(4,'Atlas',4)
INSERT Colonias VALUES(5,'Bellavista',5)
GO
INSERT Usuarios VALUES(1,'Yahir','Ramirez Sanchez','Domicilio1',6672382131,'Correo 1',1)
INSERT Usuarios VALUES(2,'Clemente','Garcia Gerardo','Domicilio2',6676823841,'Correo 2',2)
INSERT Usuarios VALUES(3,'Victor','Grande Espinoza','Domicilio3',6674275934,'Correo 3',3)
INSERT Usuarios VALUES(4,'Jesus','Gastelum Chaparro','Domicilio4',6675482981,'Correo 4',4)
INSERT Usuarios VALUES(5,'Luis Orlando','Reza Arzola','Domicilio5',6675728654,'Correo 5',5)
GO
INSERT Tamanios VALUES(1,'Chico')
INSERT Tamanios VALUES(2,'Mediano')
INSERT Tamanios VALUES(3,'Chico')
INSERT Tamanios VALUES(4,'Grande')
INSERT Tamanios VALUES(5,'Grande')
GO
INSERT Tipos VALUES(1,'Computo')
INSERT Tipos VALUES(2,'Juguetes')
INSERT Tipos VALUES(3,'Herramienta')
INSERT Tipos VALUES(4,'Joyeria')
INSERT Tipos VALUES(5,'Ropa')
GO
INSERT Piezas VALUES(1,'Pieza 1','Descripcion 1',200,1,1)
INSERT Piezas VALUES(2,'Pieza 2','Descripcion 2',400,2,2)
INSERT Piezas VALUES(3,'Pieza 3','Descripcion 3',100,3,3)
INSERT Piezas VALUES(4,'Pieza 4','Descripcion 4',800,4,4)
INSERT Piezas VALUES(5,'Pieza 5','Descripcion 5',1000,5,5)
GO
INSERT Prestamos VALUES(1,'2021-02-15',54234575.31,21371812.21,1,1,1,1,1)
INSERT Prestamos VALUES(2,'2020-03-23',63354324.76,43872822.34,2,2,2,2,2)
INSERT Prestamos VALUES(3,'2021-04-07',74241241.43,48328671.46,3,3,3,3,3)
INSERT Prestamos VALUES(4,'2021-12-21',43643451.13,12348292.62,4,4,4,4,4)
INSERT Prestamos VALUES(5,'2022-07-05',64523424.32,63728773.21,5,5,5,5,5)