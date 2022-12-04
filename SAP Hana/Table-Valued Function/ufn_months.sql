create or replace function ufn_months()
returns table (value int, month char(2), name varchar(10))
as
/* 
Date: 2022-12-03
Author: @menkar91
Note: Genera un listado de los meses con númeración y nombre
*/
temp table (value int, month char(2), name varchar(10));
i int = 1;
begin
    while i <= 12 do
        insert into :temp (value, month, name)
        select i as value, right(concat('00',i),2) as month, monthName(add_months('1900-01-01',(i-1))) as name
        from DUMMY;

        i = i + 1;
    end while;
    
    return 
		select value, month, name from :temp;
end;