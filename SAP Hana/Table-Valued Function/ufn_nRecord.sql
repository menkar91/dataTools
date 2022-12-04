create or replace function ufn_nRecord ( 
    quantity int
) 
returns table (value int)
as
/* 
Date: 2022-12-03
Author: @menkar91
Note: Genera un listado de números con la cantidad establecida
Parameter:
- quantity: Cantidad de registros a generar
*/
begin  
return
	select element_number as value
  	from SERIES_GENERATE_INTEGER(1,0,:quantity);
end;