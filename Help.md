# Indice

1. [Nomenclatura SQL](#id1)
2. [Estructura SQL](#id2)

.

# Nomenclatura SQL <a name="id1"></a>

Las siguientes iniciales son referencias a sus respectivos conjuntos:
* BD_ -> base de dato o `data base`
* PK_ -> llave primaria o `primary key`
* FK_ -> llave foránea o `foreign key`
* DF_ -> restricción de tipo `default`
* CK_ -> restricción de tipo `check`
* UQ_ -> restricción de tipo `unique`
* VW_ -> vista o `view`
* SP_ -> procedimiento almacenado o `stored procedure`
* TR_ -> desencadenador o `trigger`
* FN_ -> función de tipo escalar o `sclara function`
* TF_ -> función de tabla o `table valued function`

Los siguientes puntos muestran cómo se compone los nombres con su respectivo tipo de objeto

* Todo nombre de cualquier tipo de objeto debe ir en mayúscula excepto los reservados por el sistema
* El guion bajo o `_` solo debe ser usado como parte de la referencia anteriormente nombrado excepto en los campos de una tabla, vista o índice
* El nombre es la concatenación de la referencia más el nombre de la tabla_ más el o los campos que la componen, ejemplo: `PK_TABLA1_CAMPO1`, `DF_TABLA1_CAMPO2`, `PK_TABLA2_CAMPO1CAMPO2`
* El nombre para los índices es la concatenación de la tabla_ más el o los campos que la componen, ejemplo: `TABLA1_CAMPO1`, `TABLA2_CAMPO1CAMPO2`

.

# Estructura SQL <a name="id2"></a>

A nivel de base de datos:
* El `charset` debe ser `SQL_Latin1_General_CP1_CI_AI`

A nivel de tabla:
* Todas las tablas deben tener nombres en singular
* Todas las tablas hijas de otra se le debe agregar la última letra, ejemplo: `IMPUESTO -> IMPUESTOO`
* Por seguridad y facilidad de manejo las tablas más usadas deberán tener su homologo como vista donde en vez de mostrar ID ya tendrá la descripción correspondiente y estás tendrán como nombre la misma que la tabla, pero en plural, ejemplo: la tabla `USUARIO` tendría como vista `USUARIOS`
* Todas las tablas deben tener como primer campo el nombre de la tabla más `_ID` y esta debe ser `primary key`, `identity`, `not null`, `clustered` y este debe ser de tipo `int` o `bigint`, ejemplo: `TABLA_ID`
```sql
alter table TABLA add constraint PK_TABLA primary key clustered (TABLA_ID)
```

A nivel de campos:
* Todo campo de tipo `bit`, `tinyint`, `smallint`, `int`, `bigint`, `decimal`, `numeric`, `float`, `money` debe tener su respectivo `default` en cero (0), ejemplo: 
```sql 
alter table TABLA add constraint DF_TABLA_CAMPO default (0) for CAMPO
```

* Todo campo que contenga la fecha correspondiente a la creación del registro de la tabla debe ser de tipo `datetime`, tener por `default (getdate())` y llevar un índice `non clustered` descendente, ejemplo:
```sql 
alter table TABLA add constraint DF_TABLA_CAMPO default (getdate())) for CAMPO
create index TABLA_CAMPO on TABLA(CAMPO desc)
```

* Todo campo que haga referencia a una fecha y hora digitada por el mismo usuario y no corresponde a la fecha del registro de tabla debe ser de tipo `smalldatetime` para que este no guarde segundos ni milisegundos, ejemplo: fecha y hora de nacimiento, fecha y hora de ingreso
* Todo campo que contenga exclusivamente la fecha debe ser de tipo `date` y evitar cargar la hora, ejemplo: fecha de nacimiento, fecha de expedición, fecha de vencimiento
* Todo campo que haga referencia al estado del registro debe ser como mínimo de tipo `varchar(10)` para dar posibilidades de escalar dichos estados
* Todo campo que haga referencia a SI|NO debe ser de tipo `bit`
* Todo campo que contenga una descripción posiblemente mayor a 255 caracteres debe ser de tipo `varchar(max)`
* Todo campo que haga referencia a valores de una moneda debe ser de tipo `money`, ejemplo: precio, costo, valor
* Todo campo numérico que nunca llegará a ser mayor o igual a 128 debe ser de tipo `tinyint`, ejemplo: nivel