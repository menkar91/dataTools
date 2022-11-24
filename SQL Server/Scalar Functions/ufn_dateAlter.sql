create or alter function ufn_dateAlter(
    @input date,
    @alter varchar(max)
)
returns date
as
/* 
Date: 2022-03-29
Author: @menkar91
Note: Permite alterar para colocar el día exacto y poder añadir o quitar meses y/o años. De gran utilidad cuando se requiere sacar el último día del mes
Parameter:
- @input: Fecha la cuál se quiere modificar
- @alter: Alteración que se quiere aplicar a la fecha, estas se componen de los siguientes caracteres:
    númerico: define el día a establecer en la fecha. 
        NOTA1: si este valor es superior al día máximo del mes entonces asignará el último día del mes, ejemplo: 31 en Febrero me devolverá 28 o 29 de febrero
        NOTA2: si este valor es cero (0) o se omitió, entonces se devolverá el mismo día recibido
    simbolos aritméticos: agregará o restará n cantidad dependiendo de las veces que se definan, estos se pueden combinar o utilizar en cualquier posición
        + -> adiciona meses
        - -> resta meses
        * -> adiciona años
        / -> resta años
Examples:
    select dbo.ufn_dateAlter('2022-03-29','1'  ) --> Primer día del mes
    select dbo.ufn_dateAlter('2022-03-29','99' ) --> Último día del mes
    select dbo.ufn_dateAlter('2022-03-29','+1' ) --> Primer día del mes posterior
    select dbo.ufn_dateAlter('2022-03-29','-99') --> Último día del mes anterior
    select dbo.ufn_dateAlter('2022-03-29','*1' ) --> Primer día del mes del año posterior
    select dbo.ufn_dateAlter('2022-03-29','/99') --> Último día del mes del año anterior
    select dbo.ufn_dateAlter('2022-03-29','---') --> Fecha con tres meses anterior
    select dbo.ufn_dateAlter('2022-03-29','15' ) --> 15 del mes y año enviado
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

    if isNull(@alter,'')=''
        set @alter='0'

    if isnumeric(@alter)=0
        return @output

    if @month<>0
        set @output=dateAdd(month,@month,@output)

    if @year<>0
        set @output=dateAdd(year,@year,@output)

    if @alter='0'
        return @output

    set @output=dateAdd(day,-(day(@output)-1),@output)

    if month(@output) <> month(dateAdd(day,convert(int,@alter)-1,@output))
        set @output=dateAdd(day,-1,dateAdd(month,1,@output))
    else
        set @output=dateAdd(day,convert(int,@alter)-1,@output)

    return @output
end
