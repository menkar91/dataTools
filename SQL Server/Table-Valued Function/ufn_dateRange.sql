
create or alter function ufn_dateRange(
    @startDate  datetime,
    @endDate    datetime,
    @secondDate datetime
)
returns @output table ([value] datetime)
as
/* 
Date: 2022-03-12
Author: @menkar91
Note: Genera un listado de fechas
Parameter:
- @startDate: Fecha inicial del rango a generar
- @endDate: Fecha final del rango a generar
- @secondDate: La segunda fecha que se debe generar y la cuál define el intervalo entre cada registro a generar del listado
Examples:
    select * from dbo.ufn_dateRange('20220101','20220131',null)
    select * from dbo.ufn_dateRange('20220101 08:00','20220105 18:00','20220101 10:00')
    select * from dbo.ufn_dateRange('20220101 08:00:00.000','20220101 08:00:10.000','20220101 08:00:00.050')
*/
begin
    declare
        @ok bit,
        @interval int,
        @typeInterval varchar(12),
        @iDate datetime=@startDate

    if @secondDate is null
        set @secondDate=dateAdd(day,1,@startDate)

    --Se verifica intervalos desde fecha inicio a segunda fecha
    if datePart(millisecond,@secondDate)>datePart(millisecond,@startDate)
        select @typeInterval='millisecond', @interval=dateDiff(millisecond,@startDate,@secondDate)
    if datePart(second,@secondDate)>datePart(second,@startDate)
        select @typeInterval='second', @interval=dateDiff(second,@startDate,@secondDate)
    else if datePart(minute,@secondDate)>datePart(minute,@startDate)
        select @typeInterval='minute', @interval=dateDiff(minute,@startDate,@secondDate)
    else if datePart(hour,@secondDate)>datePart(hour,@startDate)
        select @typeInterval='hour', @interval=dateDiff(hour,@startDate,@secondDate)
    else if datePart(day,@secondDate)>datePart(day,@startDate)
        select @typeInterval='day', @interval=dateDiff(day,@startDate,@secondDate)
 
    --Inserto primer registro
    insert into @output select @iDate

    while @iDate<@endDate
    begin
        set @ok=0

        --Se realiza aumento de intervalo
        if @typeInterval='millisecond'
        begin
            set @iDate=dateadd(millisecond,@interval,@iDate)
            if datePart(millisecond,@iDate) between datePart(millisecond,@startDate) and iif(datePart(millisecond,@endDate)=0,1000,datePart(millisecond,@endDate))
                and datePart(second,@iDate) between datePart(second,@startDate) and iif(datePart(second,@endDate)=0,60,datePart(second,@endDate))
                and datePart(minute,@iDate) between datePart(minute,@startDate) and iif(datePart(minute,@endDate)=0,60,datePart(minute,@endDate))
                and datePart(hour,@iDate) between datePart(hour,@startDate) and datePart(hour,@endDate)
            begin
                set @ok=1
            end
        end
        else if @typeInterval='second'
        begin
            set @iDate=dateadd(second,@interval,@iDate)
            if datePart(second,@iDate) between datePart(second,@startDate) and iif(datePart(second,@endDate)=0,60,datePart(second,@endDate))
                and datePart(minute,@iDate) between datePart(minute,@startDate) and iif(datePart(minute,@endDate)=0,60,datePart(minute,@endDate))
                and datePart(hour,@iDate) between datePart(hour,@startDate) and datePart(hour,@endDate)
            begin
                set @ok=1
            end
        end
        else if @typeInterval='minute'
        begin
            set @iDate=dateadd(minute,@interval,@iDate)
            if datePart(minute,@iDate) between datePart(minute,@startDate) and iif(datePart(minute,@endDate)=0,60,datePart(minute,@endDate))
                and datePart(hour,@iDate) between datePart(hour,@startDate) and datePart(hour,@endDate)
            begin
                set @ok=1
            end
        end
        else if @typeInterval='hour'
        begin
            set @iDate=dateadd(hour,@interval,@iDate)
            if datePart(hour,@iDate) between datePart(hour,@startDate) and datePart(hour,@endDate)
                set @ok=1
        end
        else if @typeInterval='day'
        begin
            set @iDate=dateadd(day,@interval,@iDate)
            if datePart(day,@iDate) between datePart(day,@startDate) and datePart(day,@endDate)
                set @ok=1
        end

        if @iDate<=@endDate and @ok=1
            insert into @output select @iDate
    end

    return
end