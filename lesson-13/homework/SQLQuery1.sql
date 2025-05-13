DECLARE @GivenDate DATE = '20250305';

WITH cte AS(
	SELECT DATEFROMPARTS(YEAR(@GivenDate), MONTH(@GivenDate), 1) AS [date], 
	DATENAME(WEEKDAY, DATEFROMPARTS(YEAR(@GivenDate), MONTH(@GivenDate), 1)) AS WeekdayName,
	DATEPART(WEEKDAY, DATEFROMPARTS(YEAR(@GivenDate), MONTH(@GivenDate), 1)) AS WeekdayNum,
	1 as weeknumber

	UNION ALL

	SELECT DATEADD(DAY, 1 , [date]), 
	DATENAME(WEEKDAY, DATEADD(DAY, 1 , [date])),
	DATEPART(WEEKDAY, DATEADD(DAY, 1 , [date])),
	CASE 
		WHEN WeekdayNum>DATEPART(WEEKDAY, DATEADD(DAY, 1 , [date])) THEN weeknumber+1
		ELSE weeknumber
	END
	from cte
	WHERE [date] < EOMONTH(@GivenDate)
)

SELECT
    MAX(CASE WHEN WeekdayName = 'Sunday' THEN DAY([date]) END) AS Sunday,
    MAX(CASE WHEN WeekdayName = 'Monday' THEN DAY([date]) END) AS Monday,
    MAX(CASE WHEN WeekdayName = 'Tuesday' THEN DAY([date]) END) AS Tuesday,
    MAX(CASE WHEN WeekdayName = 'Wednesday' THEN DAY([date]) END) AS Wednesday,
    MAX(CASE WHEN WeekdayName = 'Thursday' THEN DAY([date]) END) AS Thursday,
    MAX(CASE WHEN WeekdayName = 'Friday' THEN DAY([date]) END) AS Friday,
    MAX(CASE WHEN WeekdayName = 'Saturday' THEN DAY([date]) END) AS Saturday
FROM cte
GROUP BY weeknumber


