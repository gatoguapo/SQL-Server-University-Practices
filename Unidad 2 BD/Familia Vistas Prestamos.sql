use PRESTAMOS
go

--Familia vistas municipios
create view vw_municipios as
select 
m.munid, m.munnombre,
e.edoid, e.edonombre
from Municipios m 
inner join Estados e on m.EdoID = e.EdoID
go

--Familia vistas colonias
create view vw_colonias as
select 
c.colid, c.colnombre,
m.munid, m.munnombre, m.edoid, m.edonombre
from vw_municipios m 
inner join Colonias c on m.MunID = c.MunID
go

--Familia vistas usuarios
create view vw_usuarios as
select 
u.usuid, u.usunombre, u.usuapellidos, u.usudomicilio, u.usutelefono, u.usucorreo,
c.colid, c.colnombre, c.munid, c.munnombre, c.edoid, c.edonombre
from Usuarios u
inner join vw_colonias c on u.ColID = c.ColID
go

--Familia vistas piezas
create view vw_piezas as
select
p.pieid, p.pienombre, p.piedescripcion, p.pievalor,
t.tamid, t.tamnombre,
tip.tipoid, tip.tiponombre
from Piezas p
inner join Tamanios t on p.TamID = t.TamID
inner join Tipos tip on p.TipoID = tip.tipoid

go
--Familia vistas prestamos
create view vw_prestamos as
select
p.folio, p.fechacaptura, p.monto, p.mensualidad, p.emprealizo, p.empevaluo,
er.empid, 'Empleado nombre' = er.empnombre + ' ' + er.empapellidos,
er.emptelefono, er.empcorreo,
s.sucid, s.sucnombre, s.sucdominio, s.suctelefono,
u.*,
pie.*
from Prestamos p 
inner join Empleados er on p.EmpRealizo = er.EmpID
inner join Empleados ev on p.EmpEvaluo = ev.EmpID
inner join Sucursales s on p.SucID = s.SucId
inner join vw_usuarios u on p.UsuID = u.UsuID
inner join vw_piezas pie on p.PieID = pie.PieID