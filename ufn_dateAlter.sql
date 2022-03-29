create or alter function ufn_dateAlter(
    @input date,
    @alter varchar(max)
)
returns date
as
/* 
Date: 2022-03-29
Author: @menkar91
Note: Permite alterar para colocar el d�a exacto y poder a�adir o quitar meses y/o a�os. De gran utilidad cuando se requiere sacar el �ltimo d�a del mes
Parameter:
- @input: Fecha la cu�l se quiere modificar
- @alter: Alteraci�n que se quiere aplicar a la fecha, estas se componen de los siguientes caracteres:
    n�merico: define el d�a a establecer en la fecha. 
        NOTA1: si este valor es superior al d�a m�ximo del mes entonces asignar� el �ltimo d�a del mes, ejemplo: 31 en Febrero me devolver� 28 o 29 de febrero
        NOTA2: si este valor es cero (0) o se omiti�, entonces se devolver� el mismo d�a recibido
    simbolos aritm�ticos: agregar� o restar� n cantidad dependiendo de las veces que se definan, estos se pueden combinar o utilizar en cualquier posici�n
        + -> adiciona meses
        - -> resta meses
        * -> adiciona a�os
        / -> resta a�os
Examples:
    select dbo.ufn_dateAlter('2022-03-29','1'  ) --> Primer d�a del mes
    select dbo.ufn_dateAlter('2022-03-29','99' ) --> �ltimo d�a del mes
    select dbo.ufn_dateAlter('2022-03-29','+1' ) --> Primer d�a del mes posterior
    select dbo.ufn_dateAlter('2022-03-29','-99') --> �ltimo d�a del mes anterior
    select dbo.ufn_dateAlter('2022-03-29','*1' ) --> Primer d�a del mes del a�o posterior
    select dbo.ufn_dateAlter('2022-03-29','/99') --> �ltimo d�a del mes del a�o anterior
    select dbo.ufn_dateAlter('2022-03-29','---') --> Fecha con tres meses anterior
    select dbo.ufn_dateAlter('2022-03-29','15' ) --> 15 del mes y a�o enviado
*/
begin
    declare @output date

    declare 
        @monthAfter  int=0,
        @monthBefore int=0, 
        @yearAfter   int=0,
        @yearBefore  int=0, 
        @month       int=0,
        @year        int=0 

    select @monthAfter =count(1)-1 from string_split(@alter,'+')
    select @monthBefore=count(1)-1 from string_split(@alter,'-')
    select @yearAfter  =count(1)-1 from string_split(@alter,'*')
    select @yearBefore =count(1)-1 from string_split(@alter,'/')

    set @month=@monthAfter-@monthBefore
    set @year=@yearAfter-@yearBefore
    set @alter=replace(replace(replace(replace(@alter,'-',''),'+',''),'/',''),'*','')
    set @output=@input

    if isnumeric(@alter)=0
        return @output

    if @month<>0
        set @output=dateAdd(month,@month,@output)

    if @year<>0
        set @output=dateAdd(year,@year,@output)

    if isNull(@alter,'')='' or @alter='0'
        return @output

    set @output=dateAdd(day,-(day(@output)-1),@output)

    if month(@output) <> month(dateAdd(day,convert(int,@alter)-1,@output))
        set @output=dateAdd(day,-1,dateAdd(month,1,@output))
    else
        set @output=dateAdd(day,convert(int,@alter)-1,@output)

    return @output
end