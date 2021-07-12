create or alter procedure sp_error
as
/* 
Date: 2021-07-11
Author: @menkar91
Note: Genera información del error desde un try catch
xact_state() = -1
*/
set nocount on
begin
    print concat('
 ---------------------------------
|            sp_error             |
 ---------------------------------
|    scheme: ', current_user,'
|      user: ', suser_sname(),'
|    number: ', error_number(),'
|     state: ', error_state(),'
|  severity: ', error_severity(),'
| procedure: ', error_procedure(),'
|      line: ', error_line(),'
|   message: ', error_message(), '
 ---------------------------------'
)
end