create or alter procedure usp_generateInsert (
    @table  varchar(max),
    @mode   varchar(20)='values',
    @select varchar(max)='',
    @where  varchar(max)='',
    @order  varchar(max)='',
    @top    int=0
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
    if @select<>''
        set @select=replace(@select,', ',',')
    
    if @where<>'' and ltrim(@where) not like 'where%'
        set @where='where '+@where
    
    if @order<>'' and @order not like '%order by%'
        set @order='order by '+@order
    
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
            and 1=iif(coalesce(@select,'')='',1,iif((select count(1) from string_split(@select,',') a where a.value=name)=0,0,1))
        for xml path('')
    ),1,1,'')
    
    if @columns is null
    begin
        raiserror('La tabla no existe',11,1)
        return
    end
    
    set @field=stuff((
         select '+'','''+'+||isnull('+
            (case 
                when t.name in ('image','varbinary','binary') 
                    then '''null'''
                when t.name in ('xml','text','ntext','uniqueidentifier','sql_variant','geometry','geography') 
                    then '''''''''+convert(varchar(max),['+c.name+'])+'''''''''
                when t.precision!=0 and (t.name not like '%date%' and t.name not like '%time%') 
                    then 'convert(varchar('+convert(varchar(10),iif(c.precision>=4,c.precision,4))+'),['+c.name+'])'
                when t.name like '%date%' or t.name like '%time%' 
                    then '''''''''+replace(convert(varchar,['+c.name+'],'+(case t.name when 'date' then '112' when 'time' then '24' else '21' end)+'),''-'','''')+'''''''''
                else '''''''''+['+c.name+']+'''''''''
            end)
            +','+'''null'''+')'
         from sys.columns as c
            inner join sys.types as t on t.user_type_id=c.user_type_id
         where c.object_id=object_id(@table)
            and c.is_identity!=1 
            and c.is_computed!=1
            and 1=iif(coalesce(@select,'')='',1,iif((select count(1) from string_split(@select,',') a where a.value=c.name)=0,0,1))
         for xml path('')
    ),1,7,'')

    if @mode='values'
    begin
        select @field=replace(@field,'||','')
        set @result='select'+iif(@top>0,concat(' top ',@top),'')+' ''insert into '+@table+'('+@columns+')values('''+'+'+@field+'+'+''')'''+' from '+@table+' '+@where+' '+@order
    end
    else if @mode='select'
    begin
        select @field=replace(@field,'||',char(13)+'    ')

        set @result='select ''--insert into '+@table+'('+@columns+')'''+char(13)
                   +'union all select'+iif(@top>0,concat(' top ',@top),'')+' iif(row_number() over (order by '+@firstField+')=1,'''',''union all '')+''select '''+'+'+char(13)
                   +'    '+@field+char(13)
                   +'from '+@table+' '+@where+' '+@order
    end
    else if @mode='valuesTotal'
    begin
        select @field=replace(@field,'||',char(13)+'    ')

        set @result='select ''insert into '+@table+'('+@columns+')'''+char(13)
                   +'union all select ''values'''+char(13)
                   +'union all select'+iif(@top>0,concat(' top ',@top),'')+' iif(row_number() over (order by '+@firstField+')=1,'' '','','')+''('''+'+'+char(13)
                   +'    '+@field+char(13)
                   +'+'+''')'''+char(13)
                   +'from '+@table+' '+@where+' '+@order
    end
    else
    begin
        raiserror('El parametro @mode solo recibe las siguientes opciones values|valuesTotal|select',11,1)
        return
    end

    print @result
    exec (@result)
end