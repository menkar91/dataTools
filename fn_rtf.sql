create or alter function fn_rtf (
    @rtf nvarchar(max)
)
returns nvarchar(max)
as
/* 
Date: 2021-01-30
Author: Unknown
Source: StackOverFlow
Note: Limpia un texto enriquecido
*/
begin
    declare @pos1 int
    declare @pos2 int
    declare @hex varchar(316)
    declare @stage table ([char] char(1), pos int)

    insert @stage ([char], pos)
    select substring(@rtf, number, 1), number
    from master..spt_values
    where (type = 'p')
        and (substring(@rtf, number, 1) in ('{', '}'))

    select @pos1 = min(pos), @pos2 = max(pos)
    from @stage

    delete
    from @stage
    where (pos in (@pos1, @pos2))

    while (1 = 1)
    begin
        select top 1 @pos1 = s1.pos, @pos2 = s2.pos
        from @stage s1
            inner join @stage s2 on s2.pos > s1.pos
        where (s1.char = '{')
            and (s2.char = '}')
        order by s2.pos - s1.pos

        if @@rowcount = 0
            break

        delete
        from @stage
        where (pos in (@pos1, @pos2))

        update @stage
        set pos = pos - @pos2 + @pos1 - 1
        where (pos > @pos2)

        set @rtf = stuff(@rtf, @pos1, @pos2 - @pos1 + 1, '')
    end

    set @rtf = replace(@rtf, '\pard', '')
    set @rtf = replace(@rtf, '\par', '')
    set @rtf = stuff(@rtf, 1, charindex(' ', @rtf), '')

    while (right(@rtf, 1) in (' ', char(13), char(10), '}'))
    begin
        select @rtf = substring(@rtf, 1, (len(@rtf + 'x') - 2))
        if len(@rtf) = 0 break
    end
    
    set @pos1 = charindex('\''', @rtf)

    while @pos1 > 0
    begin
        if @pos1 > 0
        begin
            set @hex = '0x' + substring(@rtf, @pos1 + 2, 2)
            set @rtf = replace(@rtf, substring(@rtf, @pos1, 4), char(convert(int, convert (binary(1), @hex,1))))
            set @pos1 = charindex('\''', @rtf)
        end
    end

    set @rtf = @rtf + ' '

    set @pos1 = patindex('%\%0123456789\ %', @rtf)

    while @pos1 > 0
    begin
        set @pos2 = charindex(' ', @rtf, @pos1 + 1)

        if @pos2 < @pos1
            set @pos2 = charindex('\', @rtf, @pos1 + 1)

        if @pos2 < @pos1
        begin
            set @rtf = substring(@rtf, 1, @pos1 - 1)
            set @pos1 = 0
        end
        else
        begin
            set @rtf = stuff(@rtf, @pos1, @pos2 - @pos1 + 1, '')
            set @pos1 = patindex('%\%0123456789\ %', @rtf)
        end
    end

    if right(@rtf, 1) = ' '
        set @rtf = substring(@rtf, 1, len(@rtf) -1)

    return @rtf
end