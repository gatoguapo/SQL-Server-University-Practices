CREATE DATABASE PRUEBA
GO
USE PRUEBA
GO

CREATE TABLE Estados
(
	EdoID INT NOT NULL,
	EdoNombre CHAR(50) NOT NULL
)
GO

CREATE TABLE Municipios
(
	MunID INT NOT NULL,
	MunNombre CHAR(50) NOT NULL,
	EdoID INT NOT NULL
)
GO

ALTER TABLE Estados ADD CONSTRAINT PK_Estados PRIMARY KEY(EdoID)
ALTER TABLE Municipios ADD CONSTRAINT PK_Municipios PRIMARY KEY (MunID)
GO
ALTER TABLE Municipios ADD CONSTRAINT FK_Municipios_Estados
	FOREIGN KEY (EdoID) REFERENCES Estados(EdoID)
GO

INSERT Estados VALUES(1, 'Sinaloa')
INSERT Estados VALUES(2, 'Sonora')
INSERT Estados VALUES(3, 'Colima')
INSERT Estados VALUES(4, 'Jalisco')
GO
INSERT Municipios VALUES(100, 'Culiacan', 1)
INSERT Municipios VALUES(101, 'Obregon', 2)
INSERT Municipios VALUES(102, 'Toluca', null)
INSERT Municipios VALUES(103, 'Tepic', null)
GO



/* Combinacion interna */
-- Muestras los registros que existen en las 2 tablas
SELECT m.MunID, m.MunNombre, m.EdoID, e. EdoID, e.EdoNombre
FROM Estados e
INNER JOIN Municipios m on e.EdoID = m.EdoID

SELECT m.MunID, m.MunNombre, m.EdoID, e. EdoID, e.EdoNombre
FROM Municipios m
INNER JOIN Estados e on e.EdoID = m.EdoID

/* Combinacion externa */
-- Muestra todos los municipios aunque no tengan asignado un estado
SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Municipios m 
LEFT OUTER JOIN Estados e ON e.EdoID = m.EdoID

SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Estados e
RIGHT OUTER JOIN Municipios m ON e.EdoID = m.EdoID

/* Full OUTER JOIN*/
SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Municipios m 
FULL OUTER JOIN Estados e ON e.EdoID = m.EdoID



/* Consulta con los estados que no tienen asignado un municipio */
SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Municipios m 
LEFT OUTER JOIN Estados e ON e.EdoID = m.EdoID
WHERE m.MunNombre IS NULL

SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Estados e
RIGHT OUTER JOIN Municipios m ON e.EdoID = m.EdoID
WHERE m.MunNombre IS NULL

/* Consulta con los municipios que no tienen aisgnado un estado */
SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Municipios m 
LEFT OUTER JOIN Estados e ON e.EdoID = m.EdoID
WHERE e.EdoNombre IS NULL

SELECT m.MunID, m.MunNombre, m.EdoID, e.EdoID, e.EdoNombre
FROM Estados e
RIGHT OUTER JOIN Municipios m ON e.EdoID = m.EdoID
WHERE e.EdoNombre IS NULL