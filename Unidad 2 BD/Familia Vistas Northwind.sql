use Northwind
GO

-- Familia vistas productos
create view vw_products as
select

p.productid, p.productname, p.quantityperunit,'Precio Producto' = p.unitprice, 
p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued,

s.supplierid, s.companyname, s.contactname, s.contacttitle, s.address, s.city,
s.region, s.postalcode, s.country, s.phone, s.fax, s.homepage,

c.categoryid, c.categoryname, c.description, c.picture

from Products p 
inner join Suppliers s on p.SupplierID = s.SupplierID
inner join Categories c on p.CategoryID = c.CategoryID
go

--Familia vistas Ordenes
create view vw_orders as
select
o.orderid, o.OrderDate, o.RequiredDate, o.ShippedDate, o.ShipVia, o.Freight, o.ShipName,
o.ShipAddress, o.ShipCity, o.ShipRegion, o.ShipPostalCode, o.ShipCountry,

e.employeeid, e.LastName, e.FirstName, e.Title, e.TitleOfCourtesy, e.BirthDate,
e.HireDate, empAddress = e.Address, empCity = e.City, empRegion = e.Region, 
empPostalCode = e.PostalCode, empCountry = e.Country, e.HomePhone, e.Extension, e.Photo,
e.Notes, e.ReportsTo, e.PhotoPath,

c.CustomerID, cusCompanyName = c.CompanyName, cusContactName = c.ContactName,
cusContactTitle = c.ContactTitle, cusAddress = c.Address, cusRegios = c.Region,
cusPostalCode = c.PostalCode, cusCountry = c.Country, cusPhone = c.Phone, cusFax = c.Fax,

s.ShipperID, shipCompanyName = s.CompanyName, shipPhone = s.Phone

from Orders o
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join Customers c on o.CustomerID = c.CustomerID
inner join Shippers s on o.ShipVia = s.ShipperID
go
--Familia vistas Order Detail
create view vw_orderdetails as
select 
od_unitprice = od.unitprice, od.quantity, od.discount, o.*, p.*
from [Order Details] od
inner join vw_orders o on o.OrderID = od.OrderID
inner join vw_products p on p.ProductID = od.ProductID
go
--Suplementarias Territorios
create view vw_territories as
select 

t.territoryid, t.territorydescription,

r.regionid, r.regiondescription

from Territories t
inner join Region r on t.RegionID = r.RegionID
go

--Suplementarias Empleados Territorios
create view vw_employeeterritoryes as
select 

etEmployeeID = et.employeeid, etTerritoryID = et.territoryid,

e.lastname, e.firstname, e.title, e.titleofcourtesy, e.birthdate, e.hiredate,
e.address, e.city, e.region, e.postalcode, e.country, e.homephone, e.extension,
e.photo, e.notes, e.reportsto, e.photopath,

t.*

from EmployeeTerritories et
inner join Employees e on et.EmployeeID = e.EmployeeID
inner join vw_territories t on et.TerritoryID = t.TerritoryID