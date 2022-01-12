create or alter function ufn_DianDV (
    @input varchar(11)
)
returns varchar(max)
as
/* 
Date: 2022-01-12
Author: @menkar91
Note: Calcula el digito de verificación por medio de formula dada por la DIAN
Parameter:
- @input: NIT o Cedula de ciudadania sin puntos ni otros caracteres que no sean números
*/
begin
    declare 
        @i      int=1, 
        @max    int=11, 
        @output int=0
    declare @t table (
        id     int, 
        factor int, 
        value  int)

    insert into @t values(1,47,0)
    insert into @t values(2,43,0)
    insert into @t values(3,41,0)
    insert into @t values(4,37,0)
    insert into @t values(5,29,0)
    insert into @t values(6,23,0)
    insert into @t values(7,19,0)
    insert into @t values(8,17,0)
    insert into @t values(9,13,0)
    insert into @t values(10,7,0)
    insert into @t values(11,3,0)

    set @input=right(concat(replace(space(@max),' ','0'),@input),@max)
    while @i<=@max
    begin
        update t set value=substring(@input,@i,1) from @t t where id=@i
        set @i+=1
    end

    select @output=sum(value*factor)%@max from @t
    if @output not in (1,0) set @output=11-@output
    return @output
end