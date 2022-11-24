create or alter function ufn_columnPosition(
    @numberColumns int
)
returns varchar(3)
as
/* 
Date: 2022-03-16
Author: @menkar91
Note: Devuelve la posición en letra de un número (A-Z). Conocer la columna en hojas de calculo
Parameter:
- @numberColumns: La posición de la columna que desea encontrar, soporta desde 1 (A) hasta 18278 (ZZZ)
Examples:
    select dbo.ufn_columnPosition(100)   --> CV
    select dbo.ufn_columnPosition(2054)  --> BZZ
    select dbo.ufn_columnPosition(18278) --> ZZZ
*/
begin
    declare 
        @output varchar(3),
        @i int=0,
        @unit smallint=0,
        @ten smallint=0,
        @hundred smallint=0

    while @i<@numberColumns
    begin
        set @i+=1

        if @ten>=26 and @unit>=26
        begin
            set @hundred+=1
            set @ten=1
            set @unit=1
        end
        else if @unit>=26
        begin
            set @ten+=1
            set @unit=1
        end
        else
            set @unit+=1
    end

    set @hundred=iif(@hundred=0,null,@hundred+64)
    set @ten=iif(@ten=0,null,@ten+64)
    set @unit=iif(@unit=0,null,@unit+64)
    set @output = concat(char(@hundred),char(@ten),char(@unit))
    return @output
end