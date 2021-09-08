if object_id('usuario','U') is not null
    drop table usuario
go
create table dbo.usuario (
    usuario_id        int identity(1,1),
    userName          varchar(20)  not null,  --> usuario real y unico
    clave             varchar(20)  masked with (function='default()') not null,
    email             varchar(255) masked with (function='email()') not null,
    fecha             datetime,               --> fecha de creacion del usuario
    primerNombre      varchar(30),
    segundoNombre     varchar(30),
    primerApellido    varchar(30),
    segundoApellido   varchar(30),
    nombre            as concat_ws(' ',primerNombre,segundoNombre,primerApellido,segundoApellido),
    fechaNacimiento   date,
    fechaCambio       datetime,               --> permite saber la ultima actualizacion del usuario
    imagen            varchar(255),           --> imagen de perfil
    estado            varchar(10),            --> permite inactivar usuario
    grupo_id          int
)

alter table usuario add constraint pk_usuario primary key clustered (usuario_id)
alter table usuario add constraint uq_usuario_userName unique (userName)
alter table usuario add constraint fk_usuario_grupo foreign key (grupo_id) references grupo (grupo_id) on delete no action
alter table usuario add constraint ck_fechaNacimiento check(fechaNacimiento<=dateAdd(year,-18,getDate()))
--alter table usuario [with nocheck] add constraint ck_fechaNacimiento check(fechaNacimiento<=dateAdd(year,-18,getDate()))
--alter table usuario [check|nocheck] constraint ck_fechaNacimiento
alter table usuario add constraint df_usuario_fecha default (getDate()) for fecha
alter table usuario add constraint df_usuario_fechaCambio default (getDate()) for fechaCambio
alter table usuario add constraint df_usuario_estado default ('activo') for estado
create index usuario_fecha on usuario(fecha desc)