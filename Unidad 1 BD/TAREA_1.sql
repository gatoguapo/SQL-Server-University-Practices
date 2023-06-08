GO
USE Northwind
-- 1 crear sucursales y agregar una sucural
GO
CREATE TABLE Sucursales (
    SucID INT NOT NULL,
    SucNombre VARCHAR(50) NOT NULL
)
GO
INSERT Sucursales VALUES (1,'FORUM')

GO
ALTER TABLE Sucursales 
ADD CONSTRAINT PK_Sucursales PRIMARY KEY(SucID)

-- 2.- quitar llaves foraneas
GO
ALTER TABLE "Order Details" 
DROP CONSTRAINT FK_Order_Details_Orders

-- Procesar tabla orders
-- 3.- quitar pk en orders
GO 
ALTER TABLE "Orders"
DROP CONSTRAINT PK_Orders

-- 4.- quitar identity en orders.orderid
GO 
SELECT * INTO #AUX_Orders FROM Orders

GO
DROP TABLE Orders 
-- 5.- agregar orders.sucid
GO
CREATE TABLE Orders (
	"SucID" int NULL,
	"OrderID" int NOT NULL ,
	"CustomerID" nchar (5) NULL ,
	"EmployeeID" int NULL ,
	"OrderDate" datetime NULL ,
	"RequiredDate" datetime NULL ,
	"ShippedDate" datetime NULL ,
	"ShipVia" int NULL ,
	"Freight" money NULL CONSTRAINT "DF_Orders_Freight" DEFAULT (0),
	"ShipName" nvarchar (40) NULL ,
	"ShipAddress" nvarchar (60) NULL ,
	"ShipCity" nvarchar (15) NULL ,
	"ShipRegion" nvarchar (15) NULL ,
	"ShipPostalCode" nvarchar (10) NULL ,
	"ShipCountry" nvarchar (15) NULL ,
)
-- 6.- actualizar orders.sucid con la clave sucid del punto 1
GO
INSERT Orders (OrderID,CustomerID,EmployeeID,
			   OrderDate,RequiredDate,ShippedDate,
			   ShipVia,Freight,ShipName,ShipAddress,
			   ShipCity,ShipRegion,ShipPostalCode,
			   ShipCountry)
SELECT * FROM #AUX_Orders

GO 
UPDATE Orders SET SucID=1
-- 7.- que no permita nulos orders.sucid
GO
ALTER TABLE Orders
ALTER COLUMN SucID INT NOT NULL
-- 8.- crear pk en orders ( sucid, orderid )
GO
ALTER TABLE Orders
ADD CONSTRAINT PK_ORDERS PRIMARY KEY(SucID,OrderID)
-- 9.- crear FK entre orders y sucursales
GO
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Sucursales FOREIGN KEY(SucID) REFERENCES Sucursales(SucID)

-- Procesar orderdetails
-- 10.- quitar pk en orderdetails
GO
ALTER TABLE "Order Details"
DROP CONSTRAINT PK_Order_Details

-- 11.- agregar orderdetails.sucid
GO
SELECT * INTO #AUX_Order_Details FROM [Order Details]

GO
DROP TABLE "Order Details"

GO
CREATE TABLE "Order Details" (
	"SucID" int NULL,
	"OrderID" int NOT NULL ,
	"ProductID" int NOT NULL ,
	"UnitPrice" money NOT NULL CONSTRAINT "DF_Order_Details_UnitPrice" DEFAULT (0),
	"Quantity" smallint NOT NULL CONSTRAINT "DF_Order_Details_Quantity" DEFAULT (1),
	"Discount" real NOT NULL CONSTRAINT "DF_Order_Details_Discount" DEFAULT (0),
)
-- 12.- actualizar orderdetails.sucid con la clave sucid del punto 1
GO
INSERT "Order Details" (OrderID,ProductID,UnitPrice,Quantity,Discount) 
SELECT * FROM #AUX_Order_Details

GO
UPDATE "Order Details" SET SucID=1
-- 13.- que no permita nulos orderdetails.sucid 
GO
ALTER TABLE "Order Details"
ALTER COLUMN SucID INT NOT NULL
-- 14.- crear pk en orderdetails( sucid, orderid , productid )
GO
ALTER TABLE "Order Details"
ADD CONSTRAINT PK_Order_Details PRIMARY KEY (SucID,OrderID,ProductID)
-- 15.- crear FK entre orderdetails y orders
GO
ALTER TABLE "Order Details"
ADD CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (SucID,OrderID) REFERENCES Orders(SucID,OrderID)

-- RELACIONAR CON LAS DEMAS TABLAS
-- Order Details
GO 
ALTER TABLE "Order Details"
ADD CONSTRAINT FK_Orders_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)

-- Orders
GO 
ALTER TABLE Orders
ADD 
CONSTRAINT FK_Orders_Employees	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipVia) REFERENCES Shippers(ShipperID)
