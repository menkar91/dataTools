create or alter function ufn_years(
    @date1 date,
    @date2 date
)
returns int
as
/* 
Date: 2021-01-31
Author: @menkar91
Note: Calcula en a�os teniendo en cuenta los bisiesto, ejemplo: dbo.fn_years('20160229','20200228') tiene: 3 a�os, 11 meses, 28 d�as
*/
begin
    declare @output int = dateDiff(year,@date1,@date2)

    if @date2>@date1
        set @output-= iif(dateAdd(yy,@output,@date1)>@date2,1,0)
    else
        set @output+= iif(dateAdd(yy,-@output,@date1)<@date2,1,0)

    return @output
end