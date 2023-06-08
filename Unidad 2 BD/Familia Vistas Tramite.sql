use Tramite
go

-- Vistas Damilias Municipios
create view vw_municipios 
as
select 

m.munid, m.MunNombre,

e.EdoID ,e.edoNombre

from Municipios m
inner join Estados e on m.EdoID = e.EdoID
go
--Vistas Familias Colonias
create view vw_colonias 
as
select

c.colid, c.colnombre,

m.munid, m.munnombre, m.edoid, m.edonombre

from Colonias c
inner join vw_municipios m on c.MunID = m.MunID
go
--Vistas Familias Usuarios
create view vw_usuario 
as
select

u.usuid, u.usunombre, u.usuapepat, u.usuapemat, u.usudomicilio, u.usutelefono,
u.usucurp, u.usurfc, u.usucorreo,

c.*

from Usuarios u
inner join vw_colonias c on u.ColID = c.ColID
go
--Vistas Familias Departamentos
create view vw_departamentos 
as
select

dep.depid, dep.DepNombre, dep.DepDomicilio, dep.DepTelefono,

den.denid, den.DenNombre, den.DenDomicilio, den.DenTelefono

from Departamentos dep
inner join Dependencias den on dep.DenID = den.DenID
go
--Vistas Familias Empleados
create view vw_empleados 
as
select

e.empid, e.empnombre, e.empapepat, e.empapemat, e.empdomicilio,
e.emptelefono, e.empcurp, e.emprfc, e.empcorreo,

d.*

from Empleados e
inner join vw_departamentos d on e.DepID = d.DepID
go
--Vistas Familias Ventanillas
create view vw_ventanillas
as
select

v.venid, v.vennombre, 

t.tipoid, t.tiponombre

from Ventanillas v
inner join Tipos t on v.TipoID = t.TipoID
go
--Vistas Familias Registro
create view vw_registro 
as
select

r.Folio, r.FechaCaptura,

v.*, e.*, u.*

from Registro r
inner join vw_ventanillas v on r.VenID = v.VenID
inner join vw_empleados e on r.EmpID = e.EmpID
inner join vw_usuario u on r.UsuID = u.UsuID
go
--Vistas Familias Tramites
create view vw_tramites
as
select

t.tramid, t.tramnombre, t.tramdescripcion, t.tramcosto, 

f.famid, f.famnombre

from Tramites t
inner join Familias f on t.FamID = f.FamID
go
--Vistas Familias TramitesXRegistro
create view wv_tramitesXregistro
as
select 

tr.fechafinal, tr.costo,

r.*, t.*

from TramitesXRegistro tr
inner join vw_registro r on tr.Folio = r.Folio
inner join vw_tramites t on tr.TramID = t.FamID
go