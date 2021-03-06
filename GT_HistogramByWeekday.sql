/****** Script for SelectTopNRows command from SSMS  ******/
DROP TABLE
	#up
SELECT
	userID
	,userprovince
INTO 
	#up
FROM 
	[dbo].[NBT4_exact_copy] as AL
WHERE
	AL.msgID IN (SELECT msgID FROM [weiboDEV].[dbo].[Points_Shanghai_262] WHERE 
	userID NOT IN (Select userID FROM badusers) )



SELECT
	COUNT(DISTINCT SH.userID)
FROM 
	[weiboDEV].[dbo].[Points_Shanghai_262] AS SH
JOIN
	#up AS AL
ON
	SH.msgID = AL.msgID
WHERE 
	SH.userID NOT IN (Select userID FROM badusers) AND AL.userprovince <> 31




SELECT
	Count(DISTINCT userID)
FROM
	[dbo].[Points_Shanghai_262]


SELECT 
	COUNT(DISTINCT userID)
FROM
	#up
WHERE
	userprovince <> 31




SELECT
	COUNT(SH.msgID) as MessageCount
	,DATENAME(dw, SH.createdAT) as WEEKDAYs
FROM 
	[weiboDEV].[dbo].[Points_Shanghai_262] AS SH
WHERE 
	SH.userID NOT IN (Select userID FROM badusers) 
GROUP BY
	DATENAME(dw, SH.createdAT) 


SELECT
	DATENAME(dw, SH.createdAT) as WEEKDAYs
	,COUNT(SH.msgID) as MessageCount
FROM 
	[weiboDEV].[dbo].[Points_Shanghai_262] AS SH
WHERE 
	SH.userID NOT IN (Select userID FROM badusers) AND SH.createdAT >= '2014/03/17' AND SH.createdAT <= '2014/03/24'
GROUP BY
	DATENAME(dw, SH.createdAT) 