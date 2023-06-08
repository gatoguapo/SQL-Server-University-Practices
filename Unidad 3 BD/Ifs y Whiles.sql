use Northwind
if (condicion)
begin 
sentencia1
sentencia2
end
else
begin
sentencia3
sentencia4
end
go
--imprimir el precio del producto mas caro y especificar si es mayor a 30 pesos o no
declare @precio numeric(12,2)
select @precio = max(unitprice) from products

if @precio > 30
	print 'El precio maximo es mayor a 30 = ' +convert(varchar(10),@precio)
else
	print 'El precio maximo es menor a 30 = ' +convert(varchar(10),@precio)

--Instruccion if exists(consulta): se utiliza para consultar y verificar la existencia de registros

--Verificar si existe el producto 1000
if exists(select*from Products where productid = 1000) 
	print 'si existe el producto 1000'
else
	print 'no existe el producto 1000'
go
while (condicion)
begin
	sentencia1
	sentencia2
end
go
select productid from products order by 1

--recorrer la tabla productos e imprimir la clave de todos los productos
declare @min int
select @min = min(productid) from Products

while @min is not null
begin
	print @min

	select @min = min(productid) from Products where ProductID > @min
end
print 'fin del ciclo'