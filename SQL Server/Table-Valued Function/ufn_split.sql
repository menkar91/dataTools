create or alter function ufn_split(@string varchar(max), @separator varchar(1))
returns @output table ([value] varchar(max))
as
/* 
Date: 2022-03-16
Author: @menkar91
Note: Divide una cadena en filas de subcadenas según un carácter separador especificado ó divide una cadena por filas de un caracter si no se usa separador
Parameter:
- @string: Cadena que se requiere dividir en filas
- @separator: Caracter que funcionará como delimitador para crear las filas
Examples:
    select * from ufn_split('1,2,3,4,5,6,7,8,9,10',',')
    select * from ufn_split('2022-03-17','')
*/
begin
    if @separator=''
    begin
        while dataLength(@string)>0
        begin
            insert into @output
            select subString(@string,1,1)

            set @string=subString(@string,2,dataLength(@string))
        end
    end
    else
    begin
        insert into @output
        select split.a.value('.','varchar(max)') data
        from
        (
            select string=convert(xml,'<xml>'+replace(@string,@separator,'</xml><xml>')+'</xml>')
        ) as x
        cross apply string.nodes('/xml') as split(a)
    end

    return
end