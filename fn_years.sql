create or alter function fn_years(
    @date1 date,
    @date2 date
)
returns int
as
/* 
Date: 2021-01-31
Author: @menkar91
Note: Calcula en años teniendo en cuenta los bisiesto, ejemplo: dbo.fn_years('20160229','20200228') tiene: 3 años, 11 meses, 28 días
*/
begin
    declare @output int = dateDiff(year,@date1,@date2)

    if @date2>@date1
        set @output-= iif(dateAdd(yy,@output,@date1)>@date2,1,0)
    else
        set @output+= iif(dateAdd(yy,-@output,@date1)<@date2,1,0)

    return @output
end