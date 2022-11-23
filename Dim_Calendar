let
    /* 
    Name: Dim_Calendar
    Date: 2022-11-23
    Author: @menkar91
    Note: I=Inserted | C=Changed | D=Deleted | M=Merged | R=Replaced | N=Renamed | S=Split

    Source = #"Fact_Documentos"[Fecha],
    Date.StartOfMonth(List.Min(Source))
    */
    Start = #date(2022,1,1), 
    End = #date(2022,12,31) 
,
    #"List" = {Number.From(Start)..Number.From(End)},
    #"Table" = Table.FromList(#"List", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"N-Date" = Table.RenameColumns(#"Table",{{"Column1", "Fecha"}}),
    #"C-Type" = Table.TransformColumnTypes(#"N-Date",{{"Fecha", type date}}),
    #"I-DateFK" = Table.AddColumn(#"C-Type", "FechaSK", each Text.Combine({Date.ToText([Fecha], "yyyy"), Date.ToText([Fecha], "MM"), Date.ToText([Fecha], "dd")}), type text),
    #"I-Year" = Table.AddColumn(#"I-DateFK", "Ano", each Date.Year([Fecha]), Int64.Type),
    #"I-Quarter" = Table.AddColumn(#"I-Year", "Trimestre", each Date.QuarterOfYear([Fecha]), Int64.Type),
    #"I-Month" = Table.AddColumn(#"I-Quarter", "Mes", each Date.Month([Fecha]), Int64.Type),
    #"I-Day" = Table.AddColumn(#"I-Month", "Dia", each Date.Day([Fecha]), Int64.Type),
    #"I-TQuarter" = Table.AddColumn(#"I-Day", "TTrimestre", each Text.Combine({"T", Text.From([Trimestre], "es-CO")}), type text),
    #"I-MonthName" = Table.AddColumn(#"I-TQuarter", "NombreMes", each Date.MonthName([Fecha]), type text),
    #"I-MonthNameShort" = Table.AddColumn(#"I-MonthName", "NombreMesCorto", each Text.Start([NombreMes], 3), type text),
    #"I-DayWeek" = Table.AddColumn(#"I-MonthNameShort", "DiaSemana", each Date.DayOfWeek([Fecha]), Int64.Type),
    #"I-WeekYear" = Table.AddColumn(#"I-DayWeek", "SemanaAno", each Date.WeekOfYear([Fecha]), Int64.Type),
    #"I-WeekMonth" = Table.AddColumn(#"I-WeekYear", "SemanaMes", each Date.WeekOfMonth([Fecha]), Int64.Type),
    #"I-EndWeek" = Table.AddColumn(#"I-WeekMonth", "FinalSemana", each Date.EndOfWeek([Fecha],Day.Monday), type date),
    #"I-DayYear" = Table.AddColumn(#"I-EndWeek", "DiaAno", each Date.DayOfYear([Fecha]), Int64.Type),
    #"I-DayName" = Table.AddColumn(#"I-DayYear", "NombreDia", each Date.DayOfWeekName([Fecha]), type text),
    #"I-DayNameShort" = Table.AddColumn(#"I-DayName", "NombreDiaCorto", each Text.Start([NombreDia], 3), type text),
    #"I-Year-TQuarter" = Table.AddColumn(#"I-DayNameShort", "Ano-Trimestre", each Text.Combine({Text.From([Ano], "es-CO"), [TTrimestre]}, "-"), type text),
    #"I-YearMonth" = Table.AddColumn(#"I-Year-TQuarter", "AnoMes", each Text.Start([FechaSK], 6), type text),
    #"I-Year-Month" = Table.AddColumn(#"I-YearMonth", "Ano-Mes", each Text.Start([FechaSK], 6), type text),
    #"S-Year-Month" = Table.SplitColumn(#"I-Year-Month", "Ano-Mes", Splitter.SplitTextByPositions({0, 4}, false), {"Ano-Mes Ano", "Ano-Mes Mes"}),
    #"M-Year-Month" = Table.CombineColumns(#"S-Year-Month",{"Ano-Mes Ano", "Ano-Mes Mes"},Combiner.CombineTextByDelimiter("-", QuoteStyle.None),"Ano-Mes"),
    #"I-YearMonthName" = Table.AddColumn(#"M-Year-Month", "Ano-NombreMesCorto", each Text.Combine({Text.From([Ano], "es-CO"), "-", [NombreMesCorto]}), type text),
    #"R-DayWeek 0->7" = Table.ReplaceValue(#"I-YearMonthName",0,7,Replacer.ReplaceValue,{"DiaSemana"}),
    #"I-StartMonth" = Table.AddColumn(#"R-DayWeek 0->7", "InicioMes", each Date.StartOfMonth([Fecha]), type date),
    #"I-EndMonth" = Table.AddColumn(#"I-StartMonth", "FinMes", each Date.EndOfMonth([Fecha]), type date)
in
    #"I-EndMonth"
