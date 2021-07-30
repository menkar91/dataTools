create or alter function ufn_dateStyle(
    @input sql_variant,
	@format varchar(25)
)
returns varchar(max)
as
/* 
Date: 2021-07-30
Author: @menkar91
Note: Transforma una fecha al estilo elegido
*/
begin
    declare @output varchar(25), @p tinyint

	if @format=''                         set @p=0
	if @format='mm/dd/yy'                 set @p=1
	if @format='yy.mm.dd'                 set @p=2
	if @format='dd/mm/yy'                 set @p=3
	if @format='dd.mm.yy'                 set @p=4
	if @format='dd-mm-yy'                 set @p=5
	if @format='dd mon yy'                set @p=6
	if @format='Mon dd, yy'               set @p=7
	if @format='hh:mi:ss'                 set @p=8
	if @format='mon dd yyyy hh:mi:ss:mmm' set @p=9
	if @format='mm-dd-yy'                 set @p=10
	if @format='yy/mm/dd'                 set @p=11
	if @format='yymmdd'                   set @p=12
	if @format='dd mon yyyy hh:mi:ss:mmm' set @p=13
	if @format='hh:mi:ss:mmm'             set @p=14
	if @format='yyyy-mm-dd hh:mi:ss'      set @p=20
	if @format='yyyy-mm-dd hh:mi:ss.mmm'  set @p=21
	if @format='mm/dd/yy hh:mi:ss'		  set @p=22
	if @format='yyyy-mm-dd'               set @p=23
	if @format='mm/dd/yyyy'               set @p=101
	if @format='yyyy.mm.dd'               set @p=102
	if @format='dd/mm/yyyy'               set @p=103
	if @format='dd.mm.yyyy'               set @p=104
	if @format='dd-mm-yyyy'               set @p=105
	if @format='dd mon yyyy'              set @p=106
	if @format='Mon dd, yyyy'             set @p=107
	if @format='hh:mi:ss'                 set @p=108
	if @format='mm-dd-yyyy'               set @p=110
	if @format='yyyy/mm/dd'               set @p=111
	if @format='yyyymmdd'                 set @p=112
	if @format='yyyy-mm-ddThh:mi:ss.mmm'  set @p=126
	if @format='yyyy-MM-ddThh:mm:ss.fffZ' set @p=127
	if @format='dd mon yyyy hh:mi:ss:mmm' set @p=130
	if @format='dd/mm/yyyy hh:mi:ss:mmm'  set @p=131

	set @output=convert(varchar,@input,@p)
	return @output
end