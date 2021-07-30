create or alter function utf_months()
returns @output table ([value] int, [month] char(2), [name] varchar(10))
as
/* 
Date: 2021-01-30
Author: @menkar91
Note: Genera un listado de los meses con númeración y nombre
*/
begin
    declare @i int=1
	
    while @i <= 12
    begin
        insert into @output ([value],[month],[name])
        values (@i, right(concat('00',@i),2), dateName(month,dateAdd(month,(@i-1),'1900-01-01')))

        set @i += 1
    end

    return
end