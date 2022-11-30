create or replace function ufn_amountToLetter_EN (
    amount smalldecimal
)
returns result varchar(5000) --Resultado
as
/* 
Date: 2022-11-29
Author: @menkar91
Note: Transforma un cantidad o monto a letra
Parameter:
- amount: Monto a transformar
*/
integer bigint; --Entero
decimal int; --Centavos
unit int; --Unidades
ten int; --Decenas
hundred int; --Centenas
string varchar(5000);
string_ varchar(5000);
terna int=1;
lcMiles varchar(5000);
begin
    integer = amount;
    decimal = (amount - integer) * 100;
    result = '';
        
    while integer > 0 do --Inicio: Recorrido por terna
        string = '';
        string_ = result;
		
        unit = mod(integer,10);
        integer = integer/10;
        
        ten = mod(integer,10);
        integer = integer/10;
        
        hundred = mod(integer,10);
        integer = integer/10;

        -- Analizo las unidades
        string =
            case unit
                when 1 then 'ONE '   || string
                when 2 then 'TWO '   || string
                when 3 then 'THREE ' || string
                when 4 then 'FOUR '  || string
                when 5 then 'FIVE '  || string
                when 6 then 'SIX '   || string
                when 7 then 'SEVEN ' || string
                when 8 then 'EIGHT ' || string
                when 9 then 'NINE '  || string
                else string
            end;
            
        -- Analizo las decenas
        string =
            case ten
                when 1 then
                    case unit
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
                when 2 then 'TWENTY '  || string 
                when 3 then 'THIRTY '  || string 
                when 4 then 'FORTY '   || string 
                when 5 then 'FIFTY '   || string 
                when 6 then 'SIXTY '   || string 
                when 7 then 'SEVENTY ' || string 
                when 8 then 'EIGHTY '  || string 
                when 9 then 'NINETY '  || string 
                else string
            end;

        -- Analizo las centenas
        string =
            case hundred
                when 1 then 'ONE HUNDRED '   || string
                when 2 then 'TWO HUNDRED '   || string
                when 3 then 'THREE HUNDRED ' || string
                when 4 then 'FOUR HUNDRED '  || string
                when 5 then 'FIVE HUNDRED '  || string
                when 6 then 'SIX HUNDRED '   || string
                when 7 then 'SEVEN HUNDRED ' || string
                when 8 then 'EIGHT HUNDRED ' || string
                when 9 then 'NINE HUNDRED '  || string
                else string
            end ;

        -- Analizo la terna

        string =
            case terna
                when 1 then string
                when 2 then string || (case hundred+ten+unit when 0 then '' else 'THOUSAND ' end)
                when 3 then string || (case hundred+ten+unit when 0 then '' else 'MILLION '  end)
                when 4 then string || (case hundred+ten+unit when 0 then '' else 'BILLION '  end)
                when 5 then string || (case hundred+ten+unit when 0 then '' else 'TRILLION ' end)
                else ''
            end;
        -- Armo el retorno terna a terna
    
        result = string || string_;
        terna = terna + 1;
    end while; --Fin: Recorrido por terna

    if terna = 1 then
        result = 'ZERO';
    end if;
end;