create or alter function fn_numericToString(
    @data sql_variant
)
returns varchar(max)
as
/* 
Date: 2021-07-28
Author: @menkar91
Note: Transforma un dato numerico a una cadena y retira los ceros a la derecha de un decimal
*/
begin
    declare @output varchar(max)=''

	set @output = convert(varchar(max),@data)
	
	if   sql_variant_property(@data,'BaseType') in ('numeric','float','real','decimal','money','smallmoney') 
	 and sql_variant_property(@data,'Scale')>0
	begin
		declare @exit bit=0
		while @exit=0
		begin
			if right(@output,1)='.' or (right(@output,1)='0' and @output like '%.%')
				set @output = left(@output,len(@output)-1)
			else
				set @exit = 1
		end
	end

    return @output
end