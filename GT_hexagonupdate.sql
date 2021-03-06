SET IDENTITY_INSERT [dbo].[HEXAGONFIELDS_CHINA_msgID] ON
USE 
	weiboDEV
GO
INSERT INTO 
	[dbo].[HEXAGONFIELDS_CHINA_msgID]
	(OBJECTID, msgID)
SELECT
	Polygon.[OBJECTID] AS OBJECTID
  , Point.[msgID] AS msgID
FROM
	[dbo].[HEXAGONFIELDS_CHINA] AS Polygon
JOIN
	[dbo].[NBT4_exact_copy_GEO] AS Point
ON 
	Polygon.Shape.STIntersects(Point.location) = 1

USE
	weiboDEV
GO
UPDATE  
	a
SET     
	a.TotalCount = b.msgCount
   ,a.[MessageDensityPerSQKM] = (b.msgCount/314.355)
FROM    
	[dbo].[HEXAGONFIELDS_CHINA] AS a
JOIN 
	(Select 
		 [OBJECTID] AS OID
		,COUNT([msgID]) AS msgCount
	 FROM 
		 [dbo].[HEXAGONFIELDS_CHINA_msgID]
	 GROUP BY
		 [OBJECTID]) AS b
ON
	a.OBJECTID = b.OID
