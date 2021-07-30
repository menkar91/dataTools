create or alter procedure usp_pivot (
    @input varchar(max),
    @pivot nvarchar(max)=null,
	@funct varchar(max)=null,
    @name  varchar(max)='name',
    @value varchar(max)='value',
	@print bit=0
)
as
/* 
Date: 2021-07-28
Author: @menkar91
Note: Pivotea una consulta enviada desde un parametro
Parameter:
- @value: nombre que se define al campo que contendrá los valores
- @name:  nombre que se define al campo que contrendrá los nombres de columnas
- @pivot: listado de posibles resultados a transformar como columna
*/
set nocount on
declare 
	@sql nvarchar(max),
	@parameters nvarchar(max),
	@property nvarchar(max)
begin
	if coalesce(@funct,'')=''
	begin
		set @sql=N'select @result=max(convert(varchar(max),sql_variant_property('+@value+',''BaseType''))) from ('+@input+') as source'
		set @parameters=N'@result varchar(max) output'
		execute sp_executesql @sql, @parameters, @result=@property OUTPUT
		if @property in ('char','date','datetime','datetime2','datetimeoffset','nchar','nvarchar','smalldatetime','time','varchar')
			set @funct='max'
		else
			set @funct='sum'
	end
	if coalesce(@pivot,'')=''
	begin
		set @sql=N'select @result=stuff((select concat('',['','+@name+','']'') from ('+@input+') as source group by '+@name+' order by '+@name+' for xml path('''')),1,1,'''')'
		set @parameters=N'@result varchar(max) output'
		execute sp_executesql @sql, @parameters, @result=@pivot OUTPUT
	end

	set @sql=N'select * from (
	'+@input+'
) as source pivot ( 
	'+@funct+'('+@value+') for '+@name+' in ('+@pivot+') 
) as p '

	print @sql
	if @print=0 exec (@sql)
end