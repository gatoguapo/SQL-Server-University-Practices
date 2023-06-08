-- FAMILIA DE VISTAS 

-- Plan para generar la familia de vistas en la base de datos northwind:

--Se debe ir generando las vistas de afuera hacia adentro
--Secuencia de creacion de vistas
nombre					tablas utilizadas
---------------------------------------------------------------------------------------------
vw_products					products, categories. suppliers
vw_orders					orders, employees, shippers, customers
vw_orderdetails				[order details], vw_orders, vw_products

--suplementarias
vw_territories				territories, region
vw_employeeterritories		vw_territories, employees, employeeterritories
---------------------------------------------------------------------------------------------
go
--vista products
create view vw_products as
select
p.productid, p.productname, p.quantityperunit, produnitprice = p.unitprice,
p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued,

s.supplierid, s.companyname, s.contactname, s.contacttitle, s.address,
s.city, s.region, s.postalcode, s.country, s.phone, s.fax, s.homepage,

c.categoryid, c.categoryname, c.description, c.picture

from products p
inner join Suppliers s on p.SupplierID = s.SupplierID
inner join Categories c on p.CategoryID = c.CategoryID
go
--ejecucion de vista products
select * from vw_products

--Consulta con el nombre de producto, nombre de la categoria y nombre de proveedor
select ProductName, CategoryName, CompanyName
from vw_products

--antes se realizaca combinando las 3 tablas
select ProductName, CategoryName, CompanyName

--Group by
select productname, categoryname, companyname
from vw_products
order by companyname

--primero agrupamos por nombre del proveedor
select productname
from vw_products
group by productname --busca proveedores distintos

select productname, categoryname, companyname
from vw_products
group by categoryname

select categoryname
from vw_products
group by categoryname -- busca las categorias distintas

--max
--min
--avg
select*from vw_products
--total de productos
select COUNT(*)FROM vw_products
--suma de todos los precios de los productos
select SUM(produnitprice) from vw_products
select unitprice from Products
--clave maxima de productos
select MAX(productid) from vw_products
--clave minima de productos
select min(productid) from vw_products
--fecha mas grande de ordenes
select max(orderdate) from Orders
--fecha mas pequeña de ordenes
select min(orderdate) from Orders


--Consulta con el nombre del proveedor y cuantos productos surte
select productname, categoryname, companyname
from vw_products
order by CompanyName

--primero agrupamos por nombre del proveedor
select companyname
from vw_products
group by CompanyName --busca los proveedores distintos

--Ahora se aplica la funcion count sobre todo el group by
select companyname, total = count(*)
from vw_products
group by companyname --busca los proveedores distintos

--consulta con el nombre de la categoria y cuantos productos contiene
select productname, categoryname, companyname
from vw_products
order by categoryname

select categoryname
from vw_products
group by categoryname-- busca las categorias distintas

select categoryname, total = count(*)
from vw_products
group by categoryname

--consulta con el nombre del producto y total de piezas vendidas
select orderid, productname, quantity, unitprice
from vw_orderdetails
order by ProductName

--Muestra los productos distintos
select productname, piezas = sum(quantity)
from vw_orderdetails
group by productname

--consulta con el folio de la orden y el importe total de ventas
select orderid, productname, quantity, unitprice
from vw_orderdetails

--muestra las ordenes distintas
select orderid
from vw_orderdetails
group by orderid

select orderid, importe = sum(quantity*unitptice)
from vw_orderdetails
group by orderid --muestra las ordenes distintas

--consulta con el nombre de la categoria y total de productos que surte
--mostrar solo las categorias que tengan menos de 10 productos

--marca error, no se permiten funciones de agregado en el where
select categoryname, total = count(*)
from vw_products
where count(*) < 10
group by categoryname

--es necesario incluir la funcion de agregado en la clausula having
select categoryname, total = count(*)
from vw_products
group by categoryname
having count(*) < 10

--Consulta con el nombre del cliente, el importe total de ventas
--importe de 1996, importe 1997 e importe 1998

--metodo 2, con vistas
go
create view vw_cte96 as
select nomcliente, T96 = SUM(quantity*unitprice)
from vw_orderdetails
where year(orderdate) = 1996
group by nomcliente
go
create view vw_cte97 as
select nomcliente, T97 = SUM(quantity*unitprice)
from vw_orderdetails
where year(orderdate) = 1997
group by nomcliente
go
create view vw_cte98 as
select nomcliente, T98 = SUM(quantity*unitprice)
from vw_orderdetails
where year(orderdate) = 1998
group by nomcliente
go
select * from vw_cte98

--no muestra todos los clientes
select A.nomcliente, A.T96, B.T97, C.798
from vw_cte96 A
inner join vw_cte97 B on b.nomcliente = a.nomcliente
inner join vw_cte98 C on c.nomcliente = a.nomcliente
--muestra todos los clientes 
select c.companyname, t96 = isnull(a.t96,0), t97 = isnull(b.t97,0), t98 = isnull(d.t98,0)
from Customers c
left outer join vw_cte96 A on A.nomcliente = c.companyname
left outer join vw_cte97 b on b.nomcliente = c.companyname
left outer join vw_cte98 d on d.nomcliente = c.companyname
go

--consulta con el año, importe total de ventas, importe total de ventas x dia de la semana
select año = year(orderdate), imp = sum(quantity*unitprice),
lunes  = sum(case when datepart(dw, orderdate)=2 then quantity*unitprice end),
Martes = sum(case when datepart(dw, orderdate)=3 then quantity*unitprice end),
Mier   = sum(case when datepart(dw, orderdate)=4 then quantity*unitprice end),
Jueves = sum(case when datepart(dw, orderdate)=5 then quantity*unitprice end),
Vierne = sum(case when datepart(dw, orderdate)=6 then quantity*unitprice end)

from vw_orderdetails
group by year(orderdate)
go

--realizar la transpuesta de la consulta anterior
select dia = datename(dw, orderdate),
t96 = sum(case when year(orderdate) = 1996 then quantity*unitprice end),
t97 = sum(case when year(orderdate) = 1997 then quantity*unitprice end),
t98 = sum(case when year(orderdate) = 1998 then quantity*unitprice end)
from vw_orderdetails
group by datename(dw, orderdate), datepart(dw, orderdate)
union
select 11, 'zTotal',
t96 = sum(case when year(orderdate) = 1996 then quantity*unitprice end),
t97 = sum(case when year(orderdate) = 1997 then quantity*unitprice end),
t98 = sum(case when year(orderdate) = 1998 then quantity*unitprice end)
from vw_orderdetails
order by datepart(dw, orderdate)

--consulta con el nombre del dia de la semana, total de ordenes realizadas e importe de venta de ese dia
select orderid, datepart(dw,orderdate), datename(dw,orderdate),productname, quantity, unitprice
from vw_orderdetails
order by datepart(dw,orderdate)

select dia=datename(dw,orderdate), ordenes = count(distinct orderid),
importe = sum(quantity*unitprice)
from vw_orderdetails
group by datename(dw,orderdate),  datepart(dw,orderdate)
order by datepart(dw,orderdate)

--La consulta anterior no muestra todos los dias de la semana, correccion:
create view vw_dias as
select Clave = 1, Dia = 'Domingo'
union
select 2, 'Lunes'
union
select 3, 'Martes'
union
select 4, 'Miercoles'
union
select 5, 'Jueves'
union
select 6, 'Viernes'
union
select 7, 'Sabado'
go
select * from vw_dias

select
d.nombre, ordenes = count(distinct od.orderid), importe = isnull(sum(od.quantity*od.unitprice),0)
from vw_orderdetails od right join vw_dias d on d.clave = datepart(dw,od.orderdate)
group by d.clave, d.nombre
order by d.clave asc


