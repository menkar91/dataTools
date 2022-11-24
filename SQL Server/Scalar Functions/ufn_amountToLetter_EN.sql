create or alter function ufn_amountToLetter_EN (
    @amount money
)
returns varchar(max)
as
/* 
Date: 2022-02-26
Author: @menkar91
Note: Transforma un cantidad o monto a letra
Parameter:
- @@amount: Monto a transformar
*/
begin
    declare 
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
                when 1 then 'ONE '  + @string
                when 2 then 'TWO '  + @string
                when 3 then 'THREE '+ @string
                when 4 then 'FOUR ' + @string
                when 5 then 'FIVE ' + @string
                when 6 then 'SIX '  + @string
                when 7 then 'SEVEN '+ @string
                when 8 then 'EIGHT '+ @string
                when 9 then 'NINE ' + @string
                else @string
            end 

        -- Analizo las decenas
        set @string =
            case @ten
                when 1 then
                    case @unit
                        when 0 then 'TEN '
                        when 1 then 'ELEVEN '
                        when 2 then 'TWELVE '
                        when 3 then 'THIRTEEN '
                        when 4 then 'FOURTEEN '
                        when 5 then 'FIFTEEN '
                        when 6 then 'SIXTEEN '
                        when 7 then 'SEVENTEEN '
                        when 8 then 'EIGHTEEN '
                        when 9 then 'NINETEEN '
                    end
                when 2 then 'TWENTY '+@string 
                when 3 then 'THIRTY '+@string 
                when 4 then 'FORTY ' +@string 
                when 5 then 'FIFTY ' +@string 
                when 6 then 'SIXTY '+@string 
                when 7 then 'SEVENTY '+@string 
                when 8 then 'EIGHTY ' +@string 
                when 9 then 'NINETY ' +@string 
                else @string
            end

        -- Analizo las centenas
        set @string =
            case @hundred
                when 1 then 'ONE HUNDRED ' + @string
                when 2 then 'TWO HUNDRED ' + @string
                when 3 then 'THREE HUNDRED ' + @string
                when 4 then 'FOUR HUNDRED ' + @string
                when 5 then 'FIVE HUNDRED ' + @string
                when 6 then 'SIX HUNDRED ' + @string
                when 7 then 'SEVEN HUNDRED ' + @string
                when 8 then 'EIGHT HUNDRED ' + @string
                when 9 then 'NINE HUNDRED ' + @string
                else @string
            end 

        -- Analizo la terna
    
        set @string =
            case @terna
                when 1 then @string
                when 2 then @string + iif(@hundred+@ten+@unit=0, '', 'THOUSAND ')
                when 3 then @string + iif(@hundred+@ten+@unit=0, '', 'MILLION ')
                when 4 then @string + iif(@hundred+@ten+@unit=0, '', 'BILLION ')
                when 5 then @string + iif(@hundred+@ten+@unit=0, '', 'TRILLION ')
                else ''
            end
        -- Armo el retorno terna a terna
    
        set @return = @string + @return
        set @terna = @terna + 1
    end --Fin: Recorrido por terna

    if @terna = 1
        set @return = 'ZERO'

    set @output = @return 

    return @output
end