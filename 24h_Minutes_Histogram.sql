use weiboDEV
GO
SELECT
count(msgID),
RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(hour,8,createdAT)) , 2) AS HHMM
FROM
[dbo].[Points_Shanghai_262]
Group by RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(hour,8,createdAT)) , 2)
Order by RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(hour,8,createdAT)) , 2) ASC



use weiboDEV
GO
SELECT
RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) AS HHMM,
count(msgID) as NumberOfMessages
FROM
[dbo].[Points_Shanghai_262]
Group by RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2)
Order by RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) ASC

