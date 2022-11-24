create or alter function ufn_capitalize(@string varchar(max))
returns varchar(max)
as
/* 
Date: 2022-03-17
Author: @menkar91
Note: Capitaliza un texto (la primera letra de cada palabra la coloca en mayuscula y el resto en minuscula)
Parameter:
- @string: Cadena que se quiere capitalizar
Examples:
    select dbo.ufn_capitalize('hello world!') --> Hello World!
*/
begin
    declare 
        @output varchar(max)=lower(@string),
        @char char(1),
        @alphaNum bit=0,
        @i_to int=len(@string),
        @i int=1

    while @i<=@i_to
    begin
        set @char=substring(@string, @i, 1)

        if @i=1 or @alphaNum=0
            set @output=stuff(@output, @i, 1, upper(@char))

        set @i+=1

        if ascii(@char)<=47 or (ascii(@char) between 58 and 64) or (ascii(@char) between 91 and 96) or (ascii(@char) between 123 and 126)
            set @alphaNum=0
        else
            set @alphaNum=1
    end

    return @output
end