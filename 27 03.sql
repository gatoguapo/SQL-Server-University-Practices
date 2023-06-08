use Northwind
go
--
declare @ordenes varchar(2000)

select @ordenes = ''

select @ordenes = @ordenes + convert(varchar(6), orderid) + ', '
from [Order Details] where productid = 8

select @ordenes
go
--con string agg
declare @ordenes varchar(2000)

select @ordenes = ''

select @ordenes = string_agg(orderid, ', ')
from [Order Details] where ProductID = 8

select @ordenes