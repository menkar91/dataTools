create or alter procedure sp_generateInsert (
    @table  varchar(max),
    @filter varchar(max)='',
    @mode   varchar(20)='values'
)
as
/* 
Date: 2021-01-30
Author: @menkar91
Note: Genera un listado de resultados listo para insertar
Parameter:
- @mode: values: genera listado con values independientes
         valuesTotal: genera listado con values de forma mas reducida
         select: genera listado con select para poder agregarle código como [not exists]
*/
set nocount on
declare 
    @columns    varchar(max),
    @field      varchar(max),
    @result     varchar(max),
    @firstField varchar(max)
begin
    if @filter<>'' and @filter not like '%where%'
        set @filter='where '+@filter
    
    set @mode=IIF(@mode='','values',@mode)

    select top 1 @firstField=name
    from sys.columns 
    where object_id=object_id(@table) 
        and is_identity!=1 
        and is_computed!=1
    
    set @columns=stuff((
        select ',['+name+']' 
        from sys.columns 
        where object_id=object_id(@table) 
            and is_identity!=1 
            and is_computed!=1
        for xml path('')
    ),1,1,'')

    set @field=stuff((
         select '+'','''+'+||isnull('+
            (case 
                when t.name in ('image','text') then '''null'''
                when t.precision!=0 and (t.name not like '%date%' and t.name not like '%time%') then 'convert(varchar('+convert(varchar(10),c.precision)+'),'+c.name+')'
                else 'quoteName('+c.name+','+quoteName('''','''''')+')'
            end)
            +','+'''null'''+')'
         from sys.columns as c
            inner join sys.types as t on t.user_type_id=c.user_type_id
         where c.object_id=object_id(@table)
            and c.is_identity!=1 
            and c.is_computed!=1
         for xml path('')
    ),1,7,'')

    if @mode='values'
    begin
        select @field=replace(@field,'||','')
        set @result='select ''insert into '+@table+'('+@columns+')values('''+'+'+@field+'+'+''')'''+' from '+@table+' '+@filter
    end
    else if @mode='select'
    begin
        select @field=replace(@field,'||',char(13)+'    ')

        set @result='select ''--insert into '+@table+'('+@columns+')'''+char(13)
                   +'union all select iif(row_number() over (order by '+@firstField+')=1,'''',''union all '')+''select '''+'+'+char(13)
                   +'    '+@field+char(13)
                   +'from '+@table+' '+@filter
    end
    else if @mode='valuesTotal'
    begin
        select @field=replace(@field,'||',char(13)+'    ')

        set @result='select ''insert into '+@table+'('+@columns+')'''+char(13)
                   +'union all select ''values'''+char(13)
                   +'union all select iif(row_number() over (order by '+@firstField+')=1,'' '','','')+''('''+'+'+char(13)
                   +'    '+@field+char(13)
                   +'+'+''')'''+char(13)
                   +'from '+@table+' '+@filter
    end
    else
    begin
        raiserror('El parametro @mode solo recibe las siguientes opciones values|valuesTotal|select',11,1)
        return
    end

    print @result
    exec (@result)
end