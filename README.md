# dataTools

Este documento es una guía para los script que aquí se encuentran como herramientas de datos.


## SQL Server ![SQL Server](https://i.imgur.com/NQ2eQjR.png)

 - **[ufn_amountToLetter_EN:](SQL%20Server/Scalar%20Functions/ufn_amountToLetter_EN.sql)** Transforma un cantidad o monto a letra en ingles
 - **[ufn_amountToLetter_ES:](SQL%20Server/Scalar%20Functions/ufn_amountToLetter_ES.sql)** Transforma un cantidad o monto a letra en español
 - **[ufn_capitalize:](SQL%20Server/Scalar%20Functions/ufn_capitalize.sql)** Capitaliza un texto (la primera letra de cada palabra la coloca en mayuscula y el resto en minuscula)
 - **[ufn_cleanText:](SQL%20Server/Scalar%20Functions/ufn_cleanText.sql)** Limpia un texto por medio de una expresión regular
 - **[ufn_columnPosition:](SQL%20Server/Scalar%20Functions/ufn_columnPosition.sql)** Devuelve la posición en letra de un número (A-Z). Conocer la columna en hojas de calculo
 - **[ufn_dateAlter:](SQL%20Server/Scalar%20Functions/ufn_dateAlter.sql)** Permite alterar para colocar el día exacto y poder añadir o quitar meses y/o años. De gran utilidad cuando se requiere sacar el último día del mes
 - **[ufn_dateRange:](SQL%20Server/Table-Valued%20Function/ufn_dateRange.sql)** Genera un listado de fechas
 - **[ufn_dateStyle:](SQL%20Server/Scalar%20Functions/ufn_dateStyle.sql)** Transforma una fecha al estilo elegido
 - **[ufn_dianDV:](SQL%20Server/Scalar%20Functions/ufn_dianDV.sql)** Calcula el digito de verificación por medio de formula dada por la DIAN
 - **[ufn_months:](SQL%20Server/Table-Valued%20Function/ufn_months.sql)** Genera un listado de meses
 - **[ufn_nRecord:](SQL%20Server/Table-Valued%20Function/ufn_nRecord.sql)** Genera un listado de números con la cantidad establecida
 - **[ufn_numericToString:](SQL%20Server/Scalar%20Functions/ufn_numericToString.sql)** Transforma un dato númerico a una cadena y retira los ceros a la derecha de un decimal
 - **[ufn_rtf:](SQL%20Server/Scalar%20Functions/ufn_rtf.sql)** Limpia un texto enriquecido
 - **[ufn_split:](SQL%20Server/Table-Valued%20Function/ufn_split.sql)** Divide una cadena en filas de subcadenas según un carácter separador especificado ó divide una cadena por filas de un caracter si no se usa separador
 - **[ufn_years:](SQL%20Server/Scalar%20Functions/ufn_years.sql)** Calcula en años teniendo en cuenta los bisiesto
 - **[usp_codeGenerator:](SQL%20Server/Stored%20Procedure/usp_codeGenerator.sql)** Genera un código mediante una expresión regular
 - **[usp_columnTable:](SQL%20Server/Stored%20Procedure/usp_columnTable.sql)** Genera un listado de los campos que componen la tabla
 - **[usp_error:](SQL%20Server/Stored%20Procedure/usp_error.sql)** Genera información del error desde un try catch
 - **[usp_generateInsert:](SQL%20Server/Stored%20Procedure/usp_generateInsert.sql)** Genera un listado de resultados listo para insertar
 - **[usp_pivot:](SQL%20Server/Stored%20Procedure/usp_pivot.sql)** Pivotea una consulta enviada desde un parametro
 - **[sp_Blitz:](https://www.brentozar.com/blitz/)** Free SQL Server Health Check Script by Brent Ozar
 - **[sp_whoIsActive:](http://whoisactive.com/)** SQL Server Monitoring Stored Procedure by Adam Machanic


## SAP Hana ![SAP Hana](https://i.imgur.com/oUnQ4km.png)

 - **[ufn_amountToLetter_EN:](SAP%20Hana/Scalar%20Functions/ufn_amountToLetter_EN.sql)** Transforma un cantidad o monto a letra en ingles
 - **[ufn_amountToLetter_ES:](SAP%20Hana/Scalar%20Functions/ufn_amountToLetter_ES.sql)** Transforma un cantidad o monto a letra en español
 - **[ufn_months:](SAP%20Hana/Table-Valued%20Function/ufn_months.sql)** Genera un listado de meses
 - **[ufn_nRecord:](SAP%20Hana/Table-Valued%20Function/ufn_nRecord.sql)** Genera un listado de números con la cantidad establecida
 - **[ufn_split:](SAP%20Hana/Table-Valued%20Function/ufn_split.sql)** Divide una cadena en filas de subcadenas según un carácter separador especificado ó divide una cadena por filas de un caracter si no se usa separador


## AppScript ![App Script](https://i.imgur.com/zdtSQSa.png)

 - **[CONCAT_WS:](AppScript/CONCAT_WS.js)** Recibe un separador y un arreglo donde concatenará cada columna de cada fila y separandola por el primer parametro. (Basado en SQL Server)
 - **[BUSCAR:](AppScript/BUSCAR.js)** Esta función permite buscar un valor e una hoja especifica


## Power Query ![Power Query](https://i.imgur.com/1XmeS9k.png)

 - **[Dim_Calendar:](Power%20Query/Dim_Calendar.pq)** Dimensión de calendario
