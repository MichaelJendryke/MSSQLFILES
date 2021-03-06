/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	DISTINCT userID
FROM	
	[weiboDEV].[dbo].[Points_Shanghai_262]
-- 1865580 distinct users in Shanghai

DROP TABLE
	#temp1
SELECT 
	* 
INTO
	#temp1
FROM
(SELECT 
	[userID]
	,count([msgID]) as MESSAGECOUNT
	,count([msgID])/462 as AvgMESSAGECOUNTperDay
	,count([msgID])/15 as AvgMESSAGECOUNTperMonth
FROM 
	[weiboDEV].[dbo].[Points_Shanghai_262]
GROUP BY 
	[userID]) as C
WHERE 
	MESSAGECOUNT > 10000 OR MESSAGECOUNT <=1
ORDER BY
	MESSAGECOUNT DESC



USE 
	weiboDEV
GO
DROP TABLE
	#foo
SELECT 
	[userID]
	,COUNT(msgID) as NbrOfMsgPerUserPerDay
	,CONVERT(DATETIME, DATEDIFF(DAY, 0, [createdAT])) as dateday 
INTO
	#foo
FROM
	[dbo].[Points_Shanghai_262]
GROUP BY [userID], CONVERT(DATETIME, DATEDIFF(DAY, 0, [createdAT]))
ORDER BY NbrOfMsgPerUserPerDay DESC


DROP TABLE
	#temp2
SELECT
	userID
	,COUNT(userID) AS NbrOfDaysOverSixtyMsg
INTO
	#temp2
FROM
	#foo
WHERE 
	NbrOfMsgPerUserPerDay > 20
GROUP BY 
	userID

SELECT 
	*
FROM 
	#temp2
ORDER BY 
	NbrOfDaysOverSixtyMsg DESC


DROP TABLE 
	#temp3
	SELECT 
		userID
	INTO
	#temp3
	FROM
		#temp1 -- Users with more than 10000 or only 1 message
	UNION ALL
	SELECT 
		userID
	FROM 
		#temp2 
	WHERE 
		NbrOfDaysOverSixtyMsg >= 66 -- Useres that have more than 15 days with more than 60 messages per day

	
--937026


DROP TABLE
	badusers
SELECT 
	DISTINCT * 
INTO 
	badusers 
FROM 
	#temp3

SELECT 
	COUNT(msgID) as MessageCountOfBadUsers
FROM
	[dbo].[Points_Shanghai_262]
WHERE 
	userID NOT IN (Select userID FROM badusers)


SELECT COUNT(*) FROM [dbo].[Points_Shanghai_262] --Total number of messages collected 
SELECT COUNT(DISTINCT userID) FROM [dbo].[Points_Shanghai_262] --Total number of distinct users 
SELECT COUNT(userID) FROM #temp1 WHERE MESSAGECOUNT > 10000 -- Number of users with more than 10000 messages
SELECT COUNT(userID) FROM #temp1 WHERE MESSAGECOUNT <=1 -- Number of users with 1 message only
SELECT COUNT(userID) FROM #temp2 WHERE NbrOfDaysOverSixtyMsg >= 66 -- Users that have >= 66 days with more than 60 messages (66 on average one day per week)
SELECT COUNT(DISTINCT userID) FROM badusers


SELECT userID FROM #temp1 WHERE MESSAGECOUNT > 10000 ORDER BY userID
SELECT userID FROM #temp2 WHERE NbrOfDaysOverSixtyMsg >= 66 ORDER BY userID


-- get average number of messages per user
SELECT
	AVG(messagecount*1.0)*1.0 as AvgMsgCntPerUsr
	,STDEV(messagecount)*1.0 as STDEVMsgCntPerUsr
	,STDEVP(messagecount)*1.0 as STDEVPMsgCntPerUsr
FROM 
	(
SELECT
	userID
	,COUNT(msgID) as messagecount
FROM 
	[dbo].[Points_Shanghai_262]
WHERE 
	userID NOT IN (Select userID FROM badusers)
GROUP BY 
	userID) as C

