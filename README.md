# sqlTools

Este documento es una guía para los script que aquí se encuentran como herramientas de **sql server**.


## SQL Server

 - **[ufn_amountToLetter_EN:](ufn_amountToLetter_EN.sql)** Transforma un cantidad o monto a letra en ingles
 - **[ufn_amountToLetter_ES:](ufn_amountToLetter_ES.sql)** Transforma un cantidad o monto a letra en español
 - **[ufn_capitalize:](ufn_capitalize.sql)** Capitaliza un texto (la primera letra de cada palabra la coloca en mayuscula y el resto en minuscula)
 - **[ufn_cleanText:](ufn_cleanText.sql)** Limpia un texto por medio de una expresión regular
 - **[ufn_columnPosition:](ufn_columnPosition.sql)** Devuelve la posición en letra de un número (A-Z). Conocer la columna en hojas de calculo
 - **[ufn_dateAlter:](ufn_dateAlter.sql)** Permite alterar para colocar el día exacto y poder añadir o quitar meses y/o años. De gran utilidad cuando se requiere sacar el último día del mes
 - **[ufn_dateRange:](ufn_dateRange.sql)** Genera un listado de fechas
 - **[ufn_dateStyle:](ufn_dateStyle.sql)** Transforma una fecha al estilo elegido
 - **[ufn_dianDV:](ufn_dianDV.sql)** Calcula el digito de verificación por medio de formula dada por la DIAN
 - **[ufn_months:](ufn_months.sql)** Genera un listado de meses
 - **[ufn_nRecord:](ufn_nRecord.sql)** Genera un listado de números con la cantidad establecida
 - **[ufn_numericToString:](ufn_numericToString.sql)** Transforma un dato númerico a una cadena y retira los ceros a la derecha de un decimal
 - **[ufn_rtf:](ufn_rtf.sql)** Limpia un texto enriquecido
 - **[ufn_split:](ufn_split.sql)** Divide una cadena en filas de subcadenas según un carácter separador especificado ó divide una cadena por filas de un caracter si no se usa separador
 - **[ufn_years:](ufn_years.sql)** Calcula en años teniendo en cuenta los bisiesto
 - **[usp_codeGenerator:](usp_codeGenerator.sql)** Genera un código mediante una expresión regular
 - **[usp_columnTable:](usp_columnTable.sql)** Genera un listado de los campos que componen la tabla
 - **[usp_error:](usp_error.sql)** Genera información del error desde un try catch
 - **[usp_generateInsert:](usp_generateInsert.sql)** Genera un listado de resultados listo para insertar
 - **[usp_pivot:](usp_pivot.sql)** Pivotea una consulta enviada desde un parametro
 - **sp_Blitz:** [Free SQL Server Health Check Script by Brent Ozar](https://www.brentozar.com/blitz/)
 - **sp_whoIsActive** [SQL Server Monitoring Stored Procedure by Adam Machanic](http://whoisactive.com/)


## AppScript

 - **[CONCAT_WS:](CONCAT_WS.js)** Recibe un separador y un arreglo donde concatenará cada columna de cada fila y separandola por el primer parametro. (Basado en SQL Server)


## Power Query

 - **[Dim_Calendar:](Dim_Calendar.pq)** Dimensión de calendario
