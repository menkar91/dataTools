create or alter procedure sp_columnTable (
    @table        varchar(max),
    @numberColumn smallint=0,
    @space        tinyint=0,
    @quote        bit=0,
    @type         varchar(max)=null,
    @separator    varchar(100)=','
)
as
/* 
Date: 2021-01-30
Note: Genera un listado de los campos que componen la tabla
Parameter:
- @numberColumn: Establece el número de columnas de forma horizontal
- @space: Establece la cantidad de espacio entre cada columna
- @quote: Permite citar entre [] cada columna
- @type: Filtra solo campos del tipo designado y separados por coma
- @separator: Establece el separador para el parametro @type en caso de ser diferente a la coma [,]
*/
set nocount on
declare 
    @query      varchar(max),
    @firstField varchar(max)
begin
    select top 1 @firstField=name
    from sys.columns 
    where object_id=object_id(@table) 
        and is_identity!=1 
        and is_computed!=1

    select @query=
        isnull(
            @query 
            + ',' 
            + space(@space) 
            + iif(@numberColumn=0, '', iif((row_number() over (order by @firstField)-1)%@numberColumn=0,char(13),''))
        , '') 
        + iif(@quote=1, quoteName(c.name,'[]'), c.name)
    from sys.columns as c
        inner join sys.types as t on t.user_type_id=c.user_type_id
    where c.object_id=object_id(@table) 
        and c.is_identity!=1 
        and c.is_computed!=1
        and (t.name in (select value from string_split(@type,@separator)) or iif(isnull(@type,'')='',1,0)=1)
    order by c.column_id
    
    set @query = coalesce(@query,'La tabla '+@table+' no existe en la base de datos')

    select @query
end