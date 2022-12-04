create or replace function ufn_split(string varchar(5000), separator varchar(1))
returns table (result varchar(5000))
as
/* 
Date: 2022-12-03
Author: @menkar91
Note: Divide una cadena en filas de subcadenas según un carácter separador especificado ó divide una cadena por filas de un caracter si no se usa separador
Parameter:
- string: Cadena que se requiere dividir en filas
- separator: Caracter que funcionará como delimitador para crear las filas
Examples:
    select * from ufn_split('1,2,3,4,5,6,7,8,9,10',',')
    select * from ufn_split('2022-03-17','')
*/
temp table (result varchar(5000));
begin 
	using SQLSCRIPT_STRING as LIB;
		
	if separator='' then
	    while length(string)>0 do
	        insert into :temp (result)
			select subString(string,1,1) as result from DUMMY;
			
	        string = subString(string,2,length(string));
	    end while;	
	else
		temp := LIB:split_to_table( :string, :separator );
	end if;
	
	return 
		select result from :temp;
end;