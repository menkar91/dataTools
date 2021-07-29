# sqlTools

Este documento es una guía para herramientas de **sql server**.


## Archivos

### Funciones escalares:

 - **fn_cleanText:** Limpia un texto por medio de una expresión regular
 - **fn_numericToString:** Transforma un dato númerico a una cadena y retira los ceros a la derecha de un decimal
 - **fn_rtf:** Limpia un texto enriquecido
 - **fn_years:** Calcula en años teniendo en cuenta los bisiesto

### Funciones con valores de tabla:

 - **tf_nRecord:** Genera un listado de números con la cantidad establecida
 - **tf_months:** Genera un listado de números con la cantidad establecida
 
### Procedimientos almacenados:

 - **sp_columnTable:** Genera un listado de los campos que componen la tabla
 - **sp_error:** Genera información del error desde un try catch
 - **sp_generateInsert:** Genera un listado de resultados listo para insertar
 - **sp_pivot:** Pivotea una consulta enviada desde un parametro


## Enlaces

 - **sp_Blitz:** [Free SQL Server Health Check Script by Brent Ozar](https://www.brentozar.com/blitz/)
 - **sp_whoIsActive** [SQL Server Monitoring Stored Procedure by Adam Machanic](http://whoisactive.com/)