create or alter procedure usp_codeGenerator(
    @length int,
    @regex varchar(max)=null,
    @output varchar(max) output
)
as
/* 
Date: 2021-09-07
Author: @menkar91
Note: Genera un código mediante una expresión regular
Parameter:
- @length: Número de caracteres del código a generar
- @regex: Expresión regular que permitirá definir los caracteres validos para el código a generar 
          ejemplos: solo caracteres (A-Z), solo números (0-9), letras y números (A-Z0-9)
*/
set nocount on
begin
    declare 
        @special varchar(max)='[]%',
        @char char(1)='',
        @from smallint=33,
        @to smallint=94

    --Agrego escape a caracteres especiales
    while len(@special)>0
    begin
        set @char=right(@special,1)

        if @regex like stuff('%~%',3,0,@char) escape '~' 
            set @regex=replace(@regex,@char,'~'+@char)

        set @special=substring(@special,0,len(@special))
    end

    --Retiro caracteres que no estén inlcuidos en ASCII (@from a @to)
    set @special=@regex
    while len(@special)>0
    begin
        set @char=right(@special,1)

        if ascii(@char) not between @from and @to
            set @regex=replace(@regex,@char,'')

        set @special=substring(@special,0,len(@special))
    end
    
    if isnull(@regex,'')='' set @regex='A-Z'
    set @regex=stuff('%[]%',3,0,@regex)

    while @length>0
    begin 
        set @char=char(rand()*(@to-@from)+@from)
        if @char like @regex escape '~'
        begin
            set @output=concat(@output,@char)
            set @length-=1
        end
    end
end