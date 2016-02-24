--HISTOGRAM by minute of day.
use weiboDEV
GO
SELECT
count(msgID) as NbrOfMsg,
RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(hour,8,createdAT)) , 2) AS HHMM
FROM
[dbo].[Points_Shanghai_262]
WHERE 
	userID NOT IN (Select userID FROM badusers)
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


-- HISTOGRAM for every day
USE 
	weiboDEV
GO
DROP TABLE
	#foo
SELECT 
	COUNT(msgID) as NbrOfMsg
	,CONVERT(DATETIME, DATEDIFF(DAY, 0, [createdAT])) as dateday 
INTO
	#foo
FROM
	[dbo].[Points_Shanghai_262]
WHERE 
	userID NOT IN (Select userID FROM badusers)
GROUP BY CONVERT(DATETIME, DATEDIFF(DAY, 0, [createdAT]))
ORDER BY CONVERT(DATETIME, DATEDIFF(DAY, 0, [createdAT]))

SELECT
	* 
FROM
	#foo 
ORDER BY
	dateday ASC