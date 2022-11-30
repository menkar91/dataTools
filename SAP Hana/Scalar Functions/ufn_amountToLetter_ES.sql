create or replace function ufn_amountToLetter_ES (
    amount smalldecimal
)
returns result varchar(5000)
as
/* 
Date: 2022-11-30
Author: @menkar91
Note: Transforma un cantidad o monto a letra
Parameter:
- amount: Monto a transformar
*/
currency varchar(20)='DOLARES'; --Moneda: 'PESOS', 'SOLES', 'DOLARES', ''
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
            end || string;

        -- Analizo las decenas
        string =
            case ten
                when 1 then
                    case unit
                        when 0 then 'DIEZ '
                        when 1 then 'ONCE '
                        when 2 then 'DOCE '
                        when 3 then 'TRECE '
                        when 4 then 'CATORCE '
                        when 5 then 'QUINCE '
                        else 'DIECI' || string
                    end
                when 2 then 'VEINT'     || (case unit when 0 then 'E ' else 'I'  || string end) 
                when 3 then 'TREINTA'   || (case unit when 0 then ' ' else ' Y ' || string end)
                when 4 then 'CUARENTA'  || (case unit when 0 then ' ' else ' Y ' || string end)
                when 5 then 'CINCUENTA' || (case unit when 0 then ' ' else ' Y ' || string end)
                when 6 then 'SESENTA'   || (case unit when 0 then ' ' else ' Y ' || string end)
                when 7 then 'SETENTA'   || (case unit when 0 then ' ' else ' Y ' || string end)
                when 8 then 'OCHENTA'   || (case unit when 0 then ' ' else ' Y ' || string end)
                when 9 then 'NOVENTA'   || (case unit when 0 then ' ' else ' Y ' || string end)
                else string
            end;

        -- Analizo las centenas
        string =
            case hundred
                when 1 then (case unit||ten when 0 then 'CIEN ' else 'CIENTO ' end)
                when 2 then 'DOSCIENTOS '
                when 3 then 'TRESCIENTOS '
                when 4 then 'CUATROCIENTOS '
                when 5 then 'QUINIENTOS '
                when 6 then 'SEISCIENTOS '
                when 7 then 'SETECIENTOS '
                when 8 then 'OCHOCIENTOS '
                when 9 then 'NOVECIENTOS '
                else ''
            end || string;

        -- Analizo la terna
    
        string =
            case terna
                when 1 then string
                when 2 then string || (case when hundred+ten+unit=0 then '' else 'MIL ' end)
                when 3 then string || (case when hundred+ten=0 and unit=1 then 'MILLON ' else 'MILLONES ' end)
                when 4 then string || (case when hundred+ten+unit=0 then '' else 'MIL ' end)
                when 5 then string || (case when hundred+ten=0 and unit=1 then 'BILLON ' else 'BILLONES ' end)
                when 6 then string || (case when hundred+ten+unit=0 then '' else 'MIL ' end)
                else ''
            end;
        -- Armo el retorno terna a terna
    
        result = string || string_;
        terna = terna + 1;
    end while; --Fin: Recorrido por terna

    if terna = 1 then
        result = 'CERO';
    end if;
    if left(result,7) = 'UN MIL ' then
        result = 'MIL ' || substring(result,8,length(result));
    end if;
    if result like '%BILLON MILLON%' or result like '%BILLONES MILLON%' then
        result = replace(result,'MILLONES ','');
    end if;

    if currency='' then
        if right(result,3)='UN ' then
            result = substring(result,1,length(result)-2) || 'UNO ';
        end if;
    else 
        string_ = result;
        if result like '%ILLON ' or result like '%ILLONES ' then
            result = string_ || 'DE ';
        end if;

        string_ = result;
        result = string_ || (case result when 'UN ' then(case 
                                            when right(currency,2)='ES' then left(currency,length(currency)-2)
                                            when right(currency,1)='S'  then left(currency,length(currency)-1)
                                            else currency
                                          end) else currency end);

        if decimal>0 then
            string_ = result;
            result = string_ || ' CON ' || substring(to_varchar(decimal,''),1,2) || ' CENTAVO' || (case when decimal>1 then 'S' else '' end);
        end if;
    end if;
    
    result = ltrim(rtrim(result));
end;