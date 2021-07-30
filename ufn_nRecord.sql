create or alter function utf_nRecord ( 
    @quantity int
) 
returns @output table (value int)
as
/* 
Date: 2021-01-30
Author: @menkar91
Note: Genera un listado de números con la cantidad establecida
Parameter:
- @quantity: Cantidad de registros a generar
*/
begin
    declare @i int=1
	
    while @i <= @quantity
    begin
        insert into @output (value)
        values (@i)

        set @i += 1
    end

    return
end