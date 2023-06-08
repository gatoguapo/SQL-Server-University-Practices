--proc alm que reciba el nombre de una tabla y regrese el select completo con el nombre de todos los
--campos usando, usar un alias en la tabla
--sp04 T SYS.doc diagrama 1

select colid, name from syscolumns where id = object_id('products')

go
create or alter proc sp_columnas @tabla nvarchar(100) as
declare @texto nvarchar(2000), @alias varchar(2), @min int, @columna varchar(50)

select @alias = SUBSTRING(@tabla, 1, 1)
select @texto = 'Select '

select @min = min(colid) from syscolumns where id=object_id(@tabla)
while @min is not null 
begin
	select @columna = name from syscolumns where id = object_id(@tabla) and @min = colid
	select @texto = @texto + @alias + '.'+@columna+', '
	
	select @min = min(colid) from syscolumns where id = OBJECT_ID(@tabla) and colid > @min
end
select @texto = substring(@texto, 1 , len(@texto)-1)--quitar ultima coma
select @texto = @texto+'from'+@tabla+' '+@alias
select @texto

exec sp_columnas 'Customers'