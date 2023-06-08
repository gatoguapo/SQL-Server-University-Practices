--Base de datos
create database Hospitales
go
use Hospitales

create table Zonas(
ZonaID int not null,
ZonaNombre nvarchar(50) not null)
go
create table Hospitales(
HospID int not null,
HospNombre nvarchar(50) not null,
ZonaID int not null)
go
create table Consultorios(
ConID int not null,
ConNombre nvarchar(50) not null,
HospID int not null)
go
create table Citas(
Cita int not null,
Fecha datetime not null,
Peso numeric (10,2) not null,
Estatura numeric (10,2) not null,
Presion numeric (10,2) not null,
Observaciones nvarchar(1000) not null,
ConID int not null)

--Integridades
--Primary keys
alter table Zonas add constraint pk_zonas 
primary key (ZonaID)
go
alter table Hospitales add constraint pk_hospitales
primary key (HospID)
go
alter table Consultorios add constraint pk_consultorios
primary key (ConID)
go
alter table Citas add constraint pk_citas
primary key (Cita)
go
--Foreign Keys
alter table Hospitales add constraint fk_hospitales_zonas
foreign key (ZonaID) references Zonas(ZonaID)
go
alter table Consultorios add constraint fk_consultorios_hospitales
foreign key (HospID) references Hospitales(HospID)
go
alter table Citas add constraint fk_citas_consultorios
foreign key (ConID) references Consultorios(ConID)
go

--Inserts
insert Zonas values(1, 'Centro')
insert Zonas values(2, 'Norte')
insert Zonas values(3, 'Sur')

insert Hospitales values(1,'Hospital Atletico', 1)
insert Hospitales values(2,'Hospital Madrid', 2)
insert Hospitales values(3,'Hospital Juventus', 3)
insert Hospitales values(4,'Hospital Barcelona', 2)
insert Hospitales values(5,'Hospital PSG', 1)

insert Consultorios values(1,'Consultorio Atletico', 1)
insert Consultorios values(2,'Consultorio Madrid', 2)
insert Consultorios values(3,'Consultorio Juventus', 3)
insert Consultorios values(4,'Consultorio Barcelona', 4)
insert Consultorios values(5,'Consultorio PSG', 5)

insert Citas values(1,'2023-05-23', 00000115.15, 00000188.00, 00000139.00, 'Presion Arterial Alta', 1)
insert Citas values(2,'2023-01-10', 00000085.32, 00000190.00, 00000120.00, 'Presion Arterial Normal', 2)
insert Citas values(3,'2022-12-25', 00000074.65, 00000171.00, 00000080.00, 'Presion Arterial Normal', 3)
insert Citas values(4,'2020-10-05', 00000058.12, 00000169.00, 00000125.00, 'Presion Arterial Elevada', 4)
insert Citas values(5,'2021-08-17', 00000068.54, 00000176.00, 00000141.00, 'Presion Arterial Muy Alta', 5)
  
go
--Familias
create view vw_hospitales as
select 
h.hospid, h.hospnombre, 
z.zonaid, z.zonanombre
from Hospitales h
inner join Zonas z on h.ZonaID = z.ZonaID
go
create view vw_consultorios as
select 
c.conid, c.connombre, 
h.HospID, h.HospNombre, h.ZonaID, h.zonanombre
from Consultorios c
inner join vw_hospitales h on h.HospID = c.HospID
go
create view vw_citas as
select 
c.cita, c.fecha, c.peso, c.estatura, c.presion, c.observaciones, 
cons.*
from Citas c
inner join vw_consultorios cons on c.ConID = cons.ConID
go

--Consultas Familias
--1.- NOMBRE DE LA ZONA Y TOTAL DE HOSPITALES DE LA ZONA.
select ZonaNombre, 'Total de hospitales de la zona' = count(distinct hospid)
from vw_hospitales
group by ZonaNombre

--2.- NOMBRE DEL CONSULTORIO Y TOTAL DE CITAS REALIZADAS.
select ConNombre, 'Total de citas realizadas' = count(distinct Cita)
from vw_citas
group by ConNombre

--3.- AÑO Y TOTAL DE CITAS REALIZADAS.
select Anio = year(fecha), count(distinct cita)
from vw_citas
group by datepart(yy,fecha)

--4.- MES Y TOTAL DE CITAS REALIZADAS. MOSTRAR TODOS LOS MESES, SI NO TIENE CITAS, MOSTAR EN CERO.
go
create view vw_meses as
select clave = 1, mes='Enero'
union
select 2, 'Febrero'
union
select 3, 'Marzo'
union
select 4, 'Abril'
union
select 5, 'Mayo'
union
select 6, 'Junio'
union
select 7, 'Julio'
union
select 8, 'Agosto'
union
select 9, 'Septiembre'
union
select 10, 'Octubre'
union
select 11, 'Noviembre'
union
select 12, 'Diciembre'
go

select f.mes, 'Citas Realizadas' = isnull(count(distinct C.cita),0)
from vw_citas C
right join vw_meses f on f.Clave = datepart (mm,C.fecha )
group by f.clave, f.mes
order by f.clave

--5.- NOMBRE DEL HOSPITAL Y TOTAL DE CONSULTORIOS QUE CONTIENE.
select 'Nombre del hospital' = c.hospnombre, count(distinct c.conid)
from vw_citas c
group by hospnombre, conid

--6.-NOMBRE DEL CONSULTORIO Y PESO TOTAL DE LOS PACIENTES ATENDIDOS EN LAS CITAS.
select Consultorio = c.connombre, PesoTotal = sum(c.peso)
from vw_citas c
group by c.connombre

--7.-NOMBRE DEL HOSPITAL Y TOTAL DE CITAS REALIZADAS POR MES DEL AÑO 2020.
select c.hospnombre, 
Enero = case when datepart(mm,c.fecha) = 1 then count(distinct c.cita) else 0 end,
Febrero = case when datepart(mm,c.fecha) = 2 then count(distinct c.cita) else 0 end,
Marzo = case when datepart(mm,c.fecha) = 3 then count(distinct c.cita) else 0 end,
Abril = case when datepart(mm,c.fecha) = 4 then count(distinct c.cita) else 0 end,
Mayo = case when datepart(mm,c.fecha) = 5 then count(distinct c.cita) else 0 end,
Junio = case when datepart(mm,c.fecha) = 6 then count(distinct c.cita) else 0 end,
Julio = case when datepart(mm,c.fecha) = 7 then count(distinct c.cita) else 0 end,
Agosto = case when datepart(mm,c.fecha) = 8 then count(distinct c.cita) else 0 end,
Septiembre = case when datepart(mm,c.fecha) = 9 then count(distinct c.cita) else 0 end,
Octubre = case when datepart(mm,c.fecha) = 10 then count(distinct c.cita) else 0 end,
Noviembre = case when datepart(mm,c.fecha) = 11 then count(distinct c.cita) else 0 end,
Diciembre = case when datepart(mm,c.fecha) = 12 then count(distinct c.cita) else 0 end
from vw_citas c
where datepart(yy,c.fecha) = 2020
group by c.HospNombre, datepart(mm,c.fecha)

select NombreHospital = c.HospNombre,
Enero      = count(distinct case when month(c.fecha) = 1 then c.cita end),
Febrero    = count(distinct case when month(c.fecha) = 2 then c.cita end),
Marzo      = count(distinct case when month(c.fecha) = 3 then c.cita end),
Abril      = count(distinct case when month(c.fecha) = 4 then c.cita end),
Mayo       = count(distinct case when month(c.fecha) = 5 then c.cita end),
Junio      = count(distinct case when month(c.fecha) = 6 then c.cita end),
Julio      = count(distinct case when month(c.fecha) = 7 then c.cita end),
Agosto     = count(distinct case when month(c.fecha) = 8 then c.cita end),
Septiembre = count(distinct case when month(c.fecha) = 9 then c.cita end),
Octubre    = count(distinct case when month(c.fecha) = 10 then c.cita end),
Noviembre  = count(distinct case when month(c.fecha) = 11 then c.cita end),
Diciembre  = count(distinct case when month(c.fecha) = 12 then c.cita end)
from vw_citas c
where year(c.fecha) = 2020
group by c.HospNombre

--8.-AÑO, Y TOTAL DE CITAS REALIZADAS POR DIA DE LA SEMANA.
select Anio = year(c.fecha),
Lunes = case when datepart(dw,c.fecha) = 2 then count(distinct c.cita) end,
Martes = case when datepart(dw,c.fecha) = 3 then count(distinct c.cita) end,
Miercoles = case when datepart(dw,c.fecha) = 4 then count(distinct c.cita) end,
Jueves = case when datepart(dw,c.fecha) = 5 then count(distinct c.cita) end,
Viernes = case when datepart(dw,c.fecha) = 6 then count(distinct c.cita) end,
Sabado = case when datepart(dw,c.fecha) = 7 then count(distinct c.cita) end,
Domingo = case when datepart(dw,c.fecha) = 1 then count(distinct c.cita) end
from vw_citas c
group by year(c.fecha), datepart(dw,c.fecha)

select Anio = year(c.fecha),
Lunes    = count(distinct case when datepart(dw,c.fecha) = 2 then c.cita end),
Martes   = count(distinct case when datepart(dw,c.fecha) = 3 then c.cita end),
Mircoles = count(distinct case when datepart(dw,c.fecha) = 4 then c.cita end),
Jueves   = count(distinct case when datepart(dw,c.fecha) = 5 then c.cita end),
Viernes  = count(distinct case when datepart(dw,c.fecha) = 6 then c.cita end),
Sabado   = count(distinct case when datepart(dw,c.fecha) = 7 then c.cita end),
Domingo  = count(distinct case when datepart(dw,c.fecha) = 1 then c.cita end)
from vw_citas c
group by year(c.fecha)

--9.-AÑO Y TOTAL DE CITAS POR ZONA.
select Anio = year(c.fecha),
Norte  = count(distinct case when c.zonanombre like 'Norte' then c.cita end),
Centro = count(distinct case when c.zonanombre like 'Centro' then c.cita end),
Sur    = count(distinct case when c.zonanombre like 'Sur'then c.cita end)
from vw_citas c
group by year(c.fecha)

--10.-NOMBRE DE LA ZONA, TOTAL DE HOSPITALES QUE EXISTEN, TOTAL DE CONSULTORIOS QUE EXISTEN EN LA ZONA.
select c.zonanombre, TotalHospitales = count(distinct c.hospid), TotalConsultorios = count(distinct c.conid)
from vw_citas c
group by c.zonanombre