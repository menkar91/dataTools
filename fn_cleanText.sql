create or alter function fn_cleanText (
    @text  varchar(max), 
    @regex varchar(max)
)
returns varchar(max)
as
/* 
Date: 2021-01-30
Note: Limpia un texto por medio de una expresión regular
Parameter:
- @regex: Limpiar acentuaciones (A-ZÑ 0-9), solo números (0-9.), solo letras sin ñ y con espacios (A-Z )
*/
begin
    declare 
        @replace   varchar(max), 
        @replaceTo varchar(max), 
        @fix       int 
   
    set @replace   = 'ñáéíóúàèìòùãõâêîôûäëïöüç'
    set @replaceTo = 'naeiouaeiouaoaeiooaeiouc'
    set @fix       = 1
   
    -- Si la expresión regular no son solo números entrará, sino evitará entrar ahorrando tiempo de proceso
    if replace(@regex,space(1),space(0))<>'0-9'
    begin
        -- Si no se asigno expresión regular, asignará una por defecto
        if isnull(@regex,space(0))=space(0)
            set @regex = 'a-z 0-9'   

        -- Si la expresión regular tiene ñ se quita de los replace: @regex like '%ñ%'
        if lower(@regex) like char(37)+char(164)+char(37)
        begin
            set @replace   = replace(@replace  ,char(164),space(0))
            set @replaceTo = replace(@replaceTo,char(110),space(0))
        end
      
        -- Se agregan minusculas y mayusculas a los replace
        set @replace   = lower(@replace  )+upper(@replace  )
        set @replaceTo = lower(@replaceTo)+upper(@replaceTo)
      
        -- Limpia acentuaciones y tildes desde los replace
        while @fix <= len(@replace)
        begin
            set @text = replace(@text, substring(@replace,@fix,1), substring(@replaceTo,@fix,1))
            set @fix = @fix+1
        end
    end 

    -- Se configura expresión regular
    set @regex = stuff('%[^]%',4,0,@regex)
   
    -- Se quitan todo lo que no este incluido en la expresión regular
    while patindex(@regex, @text) > 0
    begin
	    set @text = replace(@text, substring(@text,patindex(@regex, @text),1), space(0))
    end

    -- Se quitan espacios dobles: @text like '%  %'
    while @text like char(37)+space(2)+char(37)
    begin
	    set @text = replace(@text, space(2), space(1))
    end
   
    -- Se quitan espacios sobrantes a los lados
    set @text = ltrim(rtrim(@text))

    return @text
end
