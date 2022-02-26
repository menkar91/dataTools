create or alter function ufn_amountToLetter_ES (
    @amount money
)
returns varchar(max)
as
/* 
Date: 2022-02-25
Author: @menkar91
Note: Transforma un cantidad o monto a letra
Parameter:
- @@amount: Monto a transformar
*/
begin
    declare 
        @currency varchar(20)='DOLARES', --Moneda: 'PESOS', 'SOLES', 'DOLARES', ''
	    @output varchar(max), --Resultado
        @integer bigint, --Entero
        @decimal int, --Centavos
        @unit int, --Unidades
        @ten int, --Decenas
        @hundred int, --Centenas
        @string varchar(max),
        @terna int=1,
        @return varchar(max)='',
        @lcMiles varchar(max)

    set @integer = @amount
    set @decimal = (@amount - @integer) * 100

    while @integer > 0
    begin --Inicio: Recorrido por terna
        set @string = ''

        set @unit = @integer % 10
        set @integer = @integer/10

        set @ten = @integer % 10
        set @integer = @integer/10

        set @hundred = @integer % 10
        set @integer = @integer/10

        -- Analizo las unidades
        set @string =
            case @unit
                when 1 then 'UN '
                when 2 then 'DOS '
                when 3 then 'TRES '
                when 4 then 'CUATRO '
                when 5 then 'CINCO '
                when 6 then 'SEIS '
                when 7 then 'SIETE '
                when 8 then 'OCHO '
                when 9 then 'NUEVE '
                else ''
            end + @string

        -- Analizo las decenas
        set @string =
            case @ten
                when 1 then
                    case @unit
                        when 0 then 'DIEZ '
                        when 1 then 'ONCE '
                        when 2 then 'DOCE '
                        when 3 then 'TRECE '
                        when 4 then 'CATORCE '
                        when 5 then 'QUINCE '
                        else 'DIECI'+@string
                    end
                when 2 then 'VEINT'     +iif(@unit=0,'E ','I' +@string) 
                when 3 then 'TREINTA'   +iif(@unit=0,' ',' Y '+@string)
                when 4 then 'CUARENTA'  +iif(@unit=0,' ',' Y '+@string)
                when 5 then 'CINCUENTA' +iif(@unit=0,' ',' Y '+@string)
                when 6 then 'SESENTA'   +iif(@unit=0,' ',' Y '+@string)
                when 7 then 'SETENTA'   +iif(@unit=0,' ',' Y '+@string)
                when 8 then 'OCHENTA'   +iif(@unit=0,' ',' Y '+@string)
                when 9 then 'NOVENTA'   +iif(@unit=0,' ',' Y '+@string)
                else @string
            end

        -- Analizo las centenas
        set @string =
            case @hundred
                when 1 then iif(@unit+@ten=0, 'CIEN ', 'CIENTO ')
                when 2 then 'DOSCIENTOS '
                when 3 then 'TRESCIENTOS '
                when 4 then 'CUATROCIENTOS '
                when 5 then 'QUINIENTOS '
                when 6 then 'SEISCIENTOS '
                when 7 then 'SETECIENTOS '
                when 8 then 'OCHOCIENTOS '
                when 9 then 'NOVECIENTOS '
                else ''
            end + @string

        -- Analizo la terna
    
        set @string =
            case @terna
                when 1 then @string
                when 2 then @string + iif(@hundred+@ten+@unit=0, '', 'MIL ')
                when 3 then @string + iif(@hundred+@ten=0 and @unit=1, 'MILLON ', 'MILLONES ')
                when 4 then @string + iif(@hundred+@ten+@unit=0, '', 'MIL ')
                when 5 then @string + iif(@hundred+@ten=0 and @unit=1, 'BILLON ', 'BILLONES ')
                when 6 then @string + iif(@hundred+@ten+@unit=0, '', 'MIL ')
                else ''
            end
        -- Armo el retorno terna a terna
    
        set @return = @string + @return
        set @terna = @terna + 1
    end --Fin: Recorrido por terna

    if @terna = 1
        set @return = 'CERO'
    if left(@return,7) = 'UN MIL '
        set @return = 'MIL '+substring(@return,8,len(@return))
    if @return like '%BILLON MILLON%' or @return like '%BILLONES MILLON%'
        set @return = replace(@return,'MILLONES ','')

    if @currency=''
    begin
        if right(@return,3)='UN '
            set @return = substring(@return,1,len(@return)-2)+'UNO '
    end
    else
    begin
        if @return like '%ILLON ' or @return like '%ILLONES '
            set @return += 'DE '

        set @return += iif(@return='UN ',(case 
                                            when right(@currency,2)='ES' then left(@currency,len(@currency)-2)
                                            when right(@currency,1)='S'  then left(@currency,len(@currency)-1)
                                            else @currency
                                          end),@currency)

        if @decimal>0
            set @return += ' CON '+substring(convert(varchar(4),@decimal),1,2)+' CENTAVO'+iif(@decimal>1,'S','')
    end
    
    set @output = ltrim(rtrim(@return))

    return @output
end