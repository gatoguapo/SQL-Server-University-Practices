use Northwind
go
create proc sp_products_orders as
declare @product int, @productname varchar(50), @order int, @totalorders varchar(max)

create table #ProductsOrders(ProductName varchar(50), TotalOrders varchar(MAX))

select @product = min(ProductID) from Products
select @order = min(OrderID) from [Order Details]

while @product is not null
begin
	select @productname = productname from Products where ProductID = @product
	select @order = min(OrderID) from [Order Details] where ProductID = @product

	while @order is not null
	begin
		if exists (select ProductID from [Order Details] where productId = @product) 
		select @totalorders = STRING_AGG(orderid, ', ') from [Order Details] where ProductID = @product

		select @order = min(OrderID) from [Order Details] where OrderID > @order
	end
	insert #ProductsOrders values(@productname , @totalorders)
	
	select @product = min(ProductID) from Products where ProductID > @product
end

select 'Producto Nombre' = p.ProductName, 'Total de Ordenes' = p.TotalOrders
from #ProductsOrders p
order by ProductName asc
go

exec sp_products_orders