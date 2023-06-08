create database ExamenPractica
go
use ExamenPractica
go
create table pasillos (
pasid int not null,
nombre nvarchar(50) not null
)
go
create table familias (
famid int not null,
nombre nvarchar(50) not null
)
go
create table productos (
prodid int not null,
nombre nvarchar(50) not null,
precio numeric (10,2) not null,
famid int not null,
pasid int not null
)
go
create table detalle (
folio int not null,
prodid int not null,
cantidad int null,
precio numeric (10,2) not null,
)
go
create table tipos (
tipoid int not null,
nombre nvarchar(50) not null
)
go
create table colonias (
colid int not null,
nombre nvarchar(50) not null
)
go
create table clientes (
cliid int not null,
nombre nvarchar(50) not null,
apellidos nvarchar(50) not null,
domicilios nvarchar(50) not null,
colid int not null,
tipoid int not null
)
create table ventas(
folio int not null,
fecha datetime not null,
cliid int not null
)
go
alter table pasillos add constraint pk_pasillos
primary key (pasid)
go
alter table familias add constraint pk_familias
primary key (famid)
go
alter table productos add constraint pk_productos
primary key (prodid)
go
alter table detalle add constraint pk_detalle
primary key (folio,prodid)
go
alter table tipos add constraint pk_tipos
primary key (tipoid)
go
alter table colonias add constraint pk_colonias
primary key (colid)
go
alter table clientes add constraint pk_clientes
primary key (cliid)
go
alter table ventas add constraint pk_ventas
primary key (folio)
go
alter table clientes add constraint fk_clientes_colonias
foreign key (colid) references colonias(colid)
go
alter table clientes add constraint fk_clientes_tipos
foreign key (tipoid) references tipos(tipoid)
go
alter table ventas add constraint fk_ventas_clientes
foreign key (cliid) references clientes(cliid)
go
alter table detalle add constraint fk_detalle_ventas
foreign key (folio) references ventas(folio)
go
alter table detalle add constraint fk_detalle_productos
foreign key (prodid) references productos(prodid)
go
alter table productos add constraint fk_productos_familias
foreign key (famid) references familias(famid)
go
alter table productos add constraint fk_productos_pasillos
foreign key (pasid) references pasillos(pasid)
go

create view vw_productos as
select
p.prodid, ProdNombre = p.nombre, ProdPrecio = p.precio,
f.famid, FamNombre = f.nombre,
pas.pasid, PasNombre = pas.nombre
from Productos p
inner join familias f on p.famid = f.famid
inner join pasillos pas on pas.pasid = p.pasid
go
create view vw_clientes as
select
c.cliid, ClienteNombre = c.nombre + ' ' + c.apellidos, c.domicilios,
t.tipoid, TipoNombre = t.nombre,
col.colid, ColoniaNombre = col.nombre
from clientes c
inner join tipos t on c.tipoid = t.tipoid
inner join colonias col on c.colid = col.colid
go
create view vw_ventas as
select
v.folio, v.fecha, 
c.*
from ventas v 
inner join vw_clientes c on v.cliid = c.cliid
go
create view vw_detalle as
select
d.cantidad, d.precio,
p.*, v.*
from detalle d
inner join vw_productos p on d.prodid = p.prodid
inner join vw_ventas v on d.folio = v.folio
go
--Consulta con el nombre de la familia y el importe total de ventas
select d.FamNombre, 'Importe total de ventas' = sum(distinct d.cantidad *  d.precio)
from vw_detalle d
group by d.FamNombre

select p.PasNombre, count(distinct p.prodid)
from vw_productos p
group by PasNombre

select d.ClienteNombre, sum(distinct d.cantidad*d.precio)
from vw_detalle d
group by ClienteNombre

select d.ColoniaNombre, count(distinct d.cliid)
from vw_detalle d
group by ColoniaNombre

--Consulta con el nombre del producto e importe total de ventas, donde su nombre tenga mas de 10 letras y el importe este entre 500 y 1000.
select d.prodNombre, sum(distinct d.cantidad*d.precio)
from vw_detalle d
where len(prodNombre) > 10
group by ProdNombre
having (sum(distinct d.cantidad*d.precio) between 500 and 1000)

--Consulta con el nombre del cliente y el total de ventas realizadas los dias lunes, martes, miercoles, jueves y viernes. Cada dia en una columna
select d.ClienteNombre, 
Lunes = count(distinct case when DATEPART(dw,d.fecha) = 2 then d.folio end),
Martes = count(distinct case when DATEPART(dw,d.fecha) = 3 then d.folio end),
Miercoles = count(distinct case when DATEPART(dw,d.fecha) = 4 then d.folio end),
Jueves = count(distinct case when DATEPART(dw,d.fecha) = 5 then d.folio end),
Viernes = count(distinct case when DATEPART(dw,d.fecha) = 6 then d.folio end)
from vw_detalle d
group by ClienteNombre