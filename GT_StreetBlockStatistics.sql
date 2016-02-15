-----------------------------------------------------------------------------------
-- MOST IMPORTANT DOCUMENT WITH FINAL STREET-BLOCK AND URBAN DISTRICT STATISTICS --
-----------------------------------------------------------------------------------

-- PREPARATION
SELECT
	[OBJECTID]
   ,[Shape]
INTO
	SHANGHAI_STREET_BLOCKS_ROADS_RIVERS_BORDERS
FROM
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA]
-- create primary index on OBJECTID then create spatial index as below
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE SPATIAL INDEX [SpatialIndex-Shape] ON [dbo].[SHANGHAI_STREET_BLOCKS_ROADS_RIVERS_BORDERS]
(
	[Shape]
)USING  GEOGRAPHY_GRID 
WITH (GRIDS =(LEVEL_1 = HIGH,LEVEL_2 = HIGH,LEVEL_3 = HIGH,LEVEL_4 = HIGH), 
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

------------------------------------------------------------------------------------------------------
-- 1. Create link msgID userID and OBJECTID from SHANGHAI_STREET_BLOCKS_ROADS_RIVERS_BORDERS       ---
------------------------------------------------------------------------------------------------------
-- around 17 minutes runtime for Shanghai with over 30000 polygons
--
SELECT COUNT(msgID) from [dbo].[Points_Shanghai_262]
SELECT COUNT(msgID) from SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID
USE 
	weiboDEV
GO
DROP TABLE 
	-- the link between street blocks and messages!!!
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID
Select 
	polygon.[OBJECTID]
   ,point.[msgID]
   ,point.[userID]
INTO
    -- the link between street blocks and messages!!! 
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID
FROM 
	-- the original points (use already subsetted Points)
	[dbo].[Points_Shanghai_262] as point WITH(nolock,INDEX([location_SpatialIndex-20150624-142054]))
JOIN 
	-- the street block layer
	[dbo].[SHANGHAI_STREET_BLOCKS_ROADS_RIVERS_BORDERS] as polygon
ON 
	point.location.STIntersects(polygon.Shape) =1
-- (11793991 row(s) affected)

USE 
	[weiboDEV]
GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-msgID] ON [dbo].[SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID]
(
	[msgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


------------------------------------------------------------------------------------------------------
-- 2. DATA AGGREGATION per STREET BLOCK
------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------
-- a) Total message count and number of unique users
------------------------------------------------------------------------------------
USE
	weiboDEV
GO
DROP TABLE
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount
SELECT
	LINK1.[OBJECTID] -- unique id of each Street Block polygon
   ,COUNT (LINK1.[msgID]) AS TotalMessageCount
   ,COUNT(DISTINCT LINK1.[userID]) AS DistinctUserCount
INTO
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID as LINK1
GROUP BY
	LINK1.OBJECTID


				SELECT * FROM STEET_BLOCK_TotalMessageCount_and_DistinctUserCount



------------------------------------------------------------------------------------
-- b) Total message count and number of unique users that said that they are from province 31 (Shanghai)
------------------------------------------------------------------------------------
DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount
SELECT
	LINK1.[OBJECTID]
   ,COUNT (LINK1.[msgID]) AS ResidentsTotalMessageCount
   ,COUNT(DISTINCT LINK1.[userID]) AS ResidentsTotalUserCount
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID as LINK1
JOIN
	[dbo].[NBT4_exact_copy] as points -- only this one has userprovince information
ON
	LINK1.msgID = points.msgID
WHERE
	points.userprovince = 31
GROUP BY
	LINK1.OBJECTID


				SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount


------------------------------------------------------------------------------------
-- c) MessageCount and DistinctUserCount user count per month per street-block
------------------------------------------------------------------------------------
DROP TABLE
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH_rowformat
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS MessageCount
   ,COUNT(DISTINCT LINK1.userID) AS DistinctUserCount
INTO
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
GROUP BY
	LINK1.OBJECTID
   ,YEAR([createdAT])
   ,MONTH([createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,YEAR([createdAT]) ASC
   ,MONTH([createdAT]) ASC

DROP TABLE
	temp1
SELECT   [OBJECTID]
		,[201206] AS '201206_MessageCount'
		,[201207] AS '201207_MessageCount'
		,[201208] AS '201208_MessageCount'
		,[201209] AS '201209_MessageCount'
		,[201210] AS '201210_MessageCount'
		,[201211] AS '201211_MessageCount'
		,[201212] AS '201212_MessageCount'
		,[201301] AS '201301_MessageCount'
		,[201302] AS '201302_MessageCount'
		,[201303] AS '201303_MessageCount'
		,[201304] AS '201304_MessageCount'
		,[201305] AS '201305_MessageCount'
		,[201306] AS '201306_MessageCount'
		,[201307] AS '201307_MessageCount'
		,[201308] AS '201308_MessageCount'
		,[201309] AS '201309_MessageCount'
		,[201310] AS '201310_MessageCount'
		,[201311] AS '201311_MessageCount'
		,[201312] AS '201312_MessageCount'
		,[201401] AS '201401_MessageCount'
		,[201402] AS '201402_MessageCount'
		,[201403] AS '201403_MessageCount'
		,[201404] AS '201404_MessageCount'
		,[201405] AS '201405_MessageCount'
		,[201406] AS '201406_MessageCount'
		,[201407] AS '201407_MessageCount'
		,[201408] AS '201408_MessageCount'
		,[201409] AS '201409_MessageCount'
		,[201410] AS '201410_MessageCount'
		,[201411] AS '201411_MessageCount'
		,[201412] AS '201412_MessageCount'
		,[201501] AS '201501_MessageCount'
		,[201502] AS '201502_MessageCount'
		,[201503] AS '201503_MessageCount'
		,[201504] AS '201504_MessageCount'
		,[201505] AS '201505_MessageCount'
		,[201506] AS '201506_MessageCount'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		,D.MessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(MessageCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp1

DROP TABLE
	temp2
SELECT 
	[OBJECTID]
	,[201206] AS '201206_DistinctUserCount'
	,[201207] AS '201207_DistinctUserCount'
	,[201208] AS '201208_DistinctUserCount'
	,[201209] AS '201209_DistinctUserCount'
	,[201210] AS '201210_DistinctUserCount'
	,[201211] AS '201211_DistinctUserCount'
	,[201212] AS '201212_DistinctUserCount'
	,[201301] AS '201301_DistinctUserCount'
	,[201302] AS '201302_DistinctUserCount'
	,[201303] AS '201303_DistinctUserCount'
	,[201304] AS '201304_DistinctUserCount'
	,[201305] AS '201305_DistinctUserCount'
	,[201306] AS '201306_DistinctUserCount'
	,[201307] AS '201307_DistinctUserCount'
	,[201308] AS '201308_DistinctUserCount'
	,[201309] AS '201309_DistinctUserCount'
	,[201310] AS '201310_DistinctUserCount'
	,[201311] AS '201311_DistinctUserCount'
	,[201312] AS '201312_DistinctUserCount'
	,[201401] AS '201401_DistinctUserCount'
	,[201402] AS '201402_DistinctUserCount'
	,[201403] AS '201403_DistinctUserCount'
	,[201404] AS '201404_DistinctUserCount'
	,[201405] AS '201405_DistinctUserCount'
	,[201406] AS '201406_DistinctUserCount'
	,[201407] AS '201407_DistinctUserCount'
	,[201408] AS '201408_DistinctUserCount'
	,[201409] AS '201409_DistinctUserCount'
	,[201410] AS '201410_DistinctUserCount'
	,[201411] AS '201411_DistinctUserCount'
	,[201412] AS '201412_DistinctUserCount'
	,[201501] AS '201501_DistinctUserCount'
	,[201502] AS '201502_DistinctUserCount'
	,[201503] AS '201503_DistinctUserCount'
	,[201504] AS '201504_DistinctUserCount'
	,[201505] AS '201505_DistinctUserCount'
	,[201506] AS '201506_DistinctUserCount'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		--,D.MessageCount
		,D.DistinctUserCount
	FROM
		STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(DistinctUserCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp2

DROP TABLE
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH
SELECT 
		 A.[OBJECTID]
		,A.[201206_MessageCount]
		,A.[201207_MessageCount]
		,A.[201208_MessageCount]
		,A.[201209_MessageCount]
		,A.[201210_MessageCount]
		,A.[201211_MessageCount]
		,A.[201212_MessageCount]
		,A.[201301_MessageCount]
		,A.[201302_MessageCount]
		,A.[201303_MessageCount]
		,A.[201304_MessageCount]
		,A.[201305_MessageCount]
		,A.[201306_MessageCount]
		,A.[201307_MessageCount]
		,A.[201308_MessageCount]
		,A.[201309_MessageCount]
		,A.[201310_MessageCount]
		,A.[201311_MessageCount]
		,A.[201312_MessageCount]
		,A.[201401_MessageCount]
		,A.[201402_MessageCount]
		,A.[201403_MessageCount]
		,A.[201404_MessageCount]
		,A.[201405_MessageCount]
		,A.[201406_MessageCount]
		,A.[201407_MessageCount]
		,A.[201408_MessageCount]
		,A.[201409_MessageCount]
		,A.[201410_MessageCount]
		,A.[201411_MessageCount]
		,A.[201412_MessageCount]
		,A.[201501_MessageCount]
		,A.[201502_MessageCount]
		,A.[201503_MessageCount]
		,A.[201504_MessageCount]
		,A.[201505_MessageCount]
		,A.[201506_MessageCount]
		,B.[201206_DistinctUserCount]
		,B.[201207_DistinctUserCount]
		,B.[201208_DistinctUserCount]
		,B.[201209_DistinctUserCount]
		,B.[201210_DistinctUserCount]
		,B.[201211_DistinctUserCount]
		,B.[201212_DistinctUserCount]
		,B.[201301_DistinctUserCount]
		,B.[201302_DistinctUserCount]
		,B.[201303_DistinctUserCount]
		,B.[201304_DistinctUserCount]
		,B.[201305_DistinctUserCount]
		,B.[201306_DistinctUserCount]
		,B.[201307_DistinctUserCount]
		,B.[201308_DistinctUserCount]
		,B.[201309_DistinctUserCount]
		,B.[201310_DistinctUserCount]
		,B.[201311_DistinctUserCount]
		,B.[201312_DistinctUserCount]
		,B.[201401_DistinctUserCount]
		,B.[201402_DistinctUserCount]
		,B.[201403_DistinctUserCount]
		,B.[201404_DistinctUserCount]
		,B.[201405_DistinctUserCount]
		,B.[201406_DistinctUserCount]
		,B.[201407_DistinctUserCount]
		,B.[201408_DistinctUserCount]
		,B.[201409_DistinctUserCount]
		,B.[201410_DistinctUserCount]
		,B.[201411_DistinctUserCount]
		,B.[201412_DistinctUserCount]
		,B.[201501_DistinctUserCount]
		,B.[201502_DistinctUserCount]
		,B.[201503_DistinctUserCount]
		,B.[201504_DistinctUserCount]
		,B.[201505_DistinctUserCount]
		,B.[201506_DistinctUserCount]
INTO
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID


				SELECT * FROM STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH


------------------------------------------------------------------------------------
-- d) RESIDENTS MessageCount and DistinctUserCount per month per street-block
------------------------------------------------------------------------------------
DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH_rowformat
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS ResidentsMessageCount
   ,COUNT(DISTINCT LINK1.userID) AS ResidentsDistinctUserCount
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
JOIN
	[dbo].[NBT4_exact_copy] as AllAttributes -- only this one has userprovince information
ON
	LINK1.msgID = AllAttributes.msgID
WHERE
	AllAttributes.userprovince = 31
GROUP BY
	LINK1.OBJECTID
   ,YEAR([POINTS].[createdAT])
   ,MONTH([POINTS].[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,YEAR([POINTS].[createdAT]) ASC
   ,MONTH([POINTS].[createdAT]) ASC

DROP TABLE
	temp1
SELECT   [OBJECTID]
		,[201206] AS '201206_ResidentsMessageCount'
		,[201207] AS '201207_ResidentsMessageCount'
		,[201208] AS '201208_ResidentsMessageCount'
		,[201209] AS '201209_ResidentsMessageCount'
		,[201210] AS '201210_ResidentsMessageCount'
		,[201211] AS '201211_ResidentsMessageCount'
		,[201212] AS '201212_ResidentsMessageCount'
		,[201301] AS '201301_ResidentsMessageCount'
		,[201302] AS '201302_ResidentsMessageCount'
		,[201303] AS '201303_ResidentsMessageCount'
		,[201304] AS '201304_ResidentsMessageCount'
		,[201305] AS '201305_ResidentsMessageCount'
		,[201306] AS '201306_ResidentsMessageCount'
		,[201307] AS '201307_ResidentsMessageCount'
		,[201308] AS '201308_ResidentsMessageCount'
		,[201309] AS '201309_ResidentsMessageCount'
		,[201310] AS '201310_ResidentsMessageCount'
		,[201311] AS '201311_ResidentsMessageCount'
		,[201312] AS '201312_ResidentsMessageCount'
		,[201401] AS '201401_ResidentsMessageCount'
		,[201402] AS '201402_ResidentsMessageCount'
		,[201403] AS '201403_ResidentsMessageCount'
		,[201404] AS '201404_ResidentsMessageCount'
		,[201405] AS '201405_ResidentsMessageCount'
		,[201406] AS '201406_ResidentsMessageCount'
		,[201407] AS '201407_ResidentsMessageCount'
		,[201408] AS '201408_ResidentsMessageCount'
		,[201409] AS '201409_ResidentsMessageCount'
		,[201410] AS '201410_ResidentsMessageCount'
		,[201411] AS '201411_ResidentsMessageCount'
		,[201412] AS '201412_ResidentsMessageCount'
		,[201501] AS '201501_ResidentsMessageCount'
		,[201502] AS '201502_ResidentsMessageCount'
		,[201503] AS '201503_ResidentsMessageCount'
		,[201504] AS '201504_ResidentsMessageCount'
		,[201505] AS '201505_ResidentsMessageCount'
		,[201506] AS '201506_ResidentsMessageCount'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		,D.ResidentsMessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(ResidentsMessageCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp1

DROP TABLE
	temp2
SELECT 
	[OBJECTID]
	,[201206] AS '201206_ResidentsDistinctUserCount'
	,[201207] AS '201207_ResidentsDistinctUserCount'
	,[201208] AS '201208_ResidentsDistinctUserCount'
	,[201209] AS '201209_ResidentsDistinctUserCount'
	,[201210] AS '201210_ResidentsDistinctUserCount'
	,[201211] AS '201211_ResidentsDistinctUserCount'
	,[201212] AS '201212_ResidentsDistinctUserCount'
	,[201301] AS '201301_ResidentsDistinctUserCount'
	,[201302] AS '201302_ResidentsDistinctUserCount'
	,[201303] AS '201303_ResidentsDistinctUserCount'
	,[201304] AS '201304_ResidentsDistinctUserCount'
	,[201305] AS '201305_ResidentsDistinctUserCount'
	,[201306] AS '201306_ResidentsDistinctUserCount'
	,[201307] AS '201307_ResidentsDistinctUserCount'
	,[201308] AS '201308_ResidentsDistinctUserCount'
	,[201309] AS '201309_ResidentsDistinctUserCount'
	,[201310] AS '201310_ResidentsDistinctUserCount'
	,[201311] AS '201311_ResidentsDistinctUserCount'
	,[201312] AS '201312_ResidentsDistinctUserCount'
	,[201401] AS '201401_ResidentsDistinctUserCount'
	,[201402] AS '201402_ResidentsDistinctUserCount'
	,[201403] AS '201403_ResidentsDistinctUserCount'
	,[201404] AS '201404_ResidentsDistinctUserCount'
	,[201405] AS '201405_ResidentsDistinctUserCount'
	,[201406] AS '201406_ResidentsDistinctUserCount'
	,[201407] AS '201407_ResidentsDistinctUserCount'
	,[201408] AS '201408_ResidentsDistinctUserCount'
	,[201409] AS '201409_ResidentsDistinctUserCount'
	,[201410] AS '201410_ResidentsDistinctUserCount'
	,[201411] AS '201411_ResidentsDistinctUserCount'
	,[201412] AS '201412_ResidentsDistinctUserCount'
	,[201501] AS '201501_ResidentsDistinctUserCount'
	,[201502] AS '201502_ResidentsDistinctUserCount'
	,[201503] AS '201503_ResidentsDistinctUserCount'
	,[201504] AS '201504_ResidentsDistinctUserCount'
	,[201505] AS '201505_ResidentsDistinctUserCount'
	,[201506] AS '201506_ResidentsDistinctUserCount'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		--,D.MessageCount
		,D.ResidentsDistinctUserCount
	FROM
		STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(ResidentsDistinctUserCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp2

DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH
SELECT 
		 A.[OBJECTID]
		,A.[201206_ResidentsMessageCount]
		,A.[201207_ResidentsMessageCount]
		,A.[201208_ResidentsMessageCount]
		,A.[201209_ResidentsMessageCount]
		,A.[201210_ResidentsMessageCount]
		,A.[201211_ResidentsMessageCount]
		,A.[201212_ResidentsMessageCount]
		,A.[201301_ResidentsMessageCount]
		,A.[201302_ResidentsMessageCount]
		,A.[201303_ResidentsMessageCount]
		,A.[201304_ResidentsMessageCount]
		,A.[201305_ResidentsMessageCount]
		,A.[201306_ResidentsMessageCount]
		,A.[201307_ResidentsMessageCount]
		,A.[201308_ResidentsMessageCount]
		,A.[201309_ResidentsMessageCount]
		,A.[201310_ResidentsMessageCount]
		,A.[201311_ResidentsMessageCount]
		,A.[201312_ResidentsMessageCount]
		,A.[201401_ResidentsMessageCount]
		,A.[201402_ResidentsMessageCount]
		,A.[201403_ResidentsMessageCount]
		,A.[201404_ResidentsMessageCount]
		,A.[201405_ResidentsMessageCount]
		,A.[201406_ResidentsMessageCount]
		,A.[201407_ResidentsMessageCount]
		,A.[201408_ResidentsMessageCount]
		,A.[201409_ResidentsMessageCount]
		,A.[201410_ResidentsMessageCount]
		,A.[201411_ResidentsMessageCount]
		,A.[201412_ResidentsMessageCount]
		,A.[201501_ResidentsMessageCount]
		,A.[201502_ResidentsMessageCount]
		,A.[201503_ResidentsMessageCount]
		,A.[201504_ResidentsMessageCount]
		,A.[201505_ResidentsMessageCount]
		,A.[201506_ResidentsMessageCount]
		,B.[201206_ResidentsDistinctUserCount]
		,B.[201207_ResidentsDistinctUserCount]
		,B.[201208_ResidentsDistinctUserCount]
		,B.[201209_ResidentsDistinctUserCount]
		,B.[201210_ResidentsDistinctUserCount]
		,B.[201211_ResidentsDistinctUserCount]
		,B.[201212_ResidentsDistinctUserCount]
		,B.[201301_ResidentsDistinctUserCount]
		,B.[201302_ResidentsDistinctUserCount]
		,B.[201303_ResidentsDistinctUserCount]
		,B.[201304_ResidentsDistinctUserCount]
		,B.[201305_ResidentsDistinctUserCount]
		,B.[201306_ResidentsDistinctUserCount]
		,B.[201307_ResidentsDistinctUserCount]
		,B.[201308_ResidentsDistinctUserCount]
		,B.[201309_ResidentsDistinctUserCount]
		,B.[201310_ResidentsDistinctUserCount]
		,B.[201311_ResidentsDistinctUserCount]
		,B.[201312_ResidentsDistinctUserCount]
		,B.[201401_ResidentsDistinctUserCount]
		,B.[201402_ResidentsDistinctUserCount]
		,B.[201403_ResidentsDistinctUserCount]
		,B.[201404_ResidentsDistinctUserCount]
		,B.[201405_ResidentsDistinctUserCount]
		,B.[201406_ResidentsDistinctUserCount]
	    ,B.[201407_ResidentsDistinctUserCount]
		,B.[201408_ResidentsDistinctUserCount]
		,B.[201409_ResidentsDistinctUserCount]
		,B.[201410_ResidentsDistinctUserCount]
		,B.[201411_ResidentsDistinctUserCount]
		,B.[201412_ResidentsDistinctUserCount]
		,B.[201501_ResidentsDistinctUserCount]
		,B.[201502_ResidentsDistinctUserCount]
		,B.[201503_ResidentsDistinctUserCount]
		,B.[201504_ResidentsDistinctUserCount]
		,B.[201505_ResidentsDistinctUserCount]
		,B.[201506_ResidentsDistinctUserCount]
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID


				SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH
			  

------------------------------------------------------------------------------------
-- e) TOURISTS MessageCount and DistinctUserCount per month per street-block
------------------------------------------------------------------------------------
DROP TABLE
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS TouristsMessageCount
   ,COUNT(DISTINCT LINK1.userID) AS TouristsDistinctUserCount
INTO
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
JOIN
	[dbo].[NBT4_exact_copy] as AllAttributes -- only this one has userprovince information
ON
	LINK1.msgID = AllAttributes.msgID
WHERE
	AllAttributes.userprovince <> 31
GROUP BY
	LINK1.OBJECTID
   ,YEAR([POINTS].[createdAT])
   ,MONTH([POINTS].[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,YEAR([POINTS].[createdAT]) ASC
   ,MONTH([POINTS].[createdAT]) ASC

DROP TABLE
	temp1
SELECT   [OBJECTID]
		,[201206] AS '201206_TouristsMessageCount'
		,[201207] AS '201207_TouristsMessageCount'
		,[201208] AS '201208_TouristsMessageCount'
		,[201209] AS '201209_TouristsMessageCount'
		,[201210] AS '201210_TouristsMessageCount'
		,[201211] AS '201211_TouristsMessageCount'
		,[201212] AS '201212_TouristsMessageCount'
		,[201301] AS '201301_TouristsMessageCount'
		,[201302] AS '201302_TouristsMessageCount'
		,[201303] AS '201303_TouristsMessageCount'
		,[201304] AS '201304_TouristsMessageCount'
		,[201305] AS '201305_TouristsMessageCount'
		,[201306] AS '201306_TouristsMessageCount'
		,[201307] AS '201307_TouristsMessageCount'
		,[201308] AS '201308_TouristsMessageCount'
		,[201309] AS '201309_TouristsMessageCount'
		,[201310] AS '201310_TouristsMessageCount'
		,[201311] AS '201311_TouristsMessageCount'
		,[201312] AS '201312_TouristsMessageCount'
		,[201401] AS '201401_TouristsMessageCount'
		,[201402] AS '201402_TouristsMessageCount'
		,[201403] AS '201403_TouristsMessageCount'
		,[201404] AS '201404_TouristsMessageCount'
		,[201405] AS '201405_TouristsMessageCount'
		,[201406] AS '201406_TouristsMessageCount'
		,[201407] AS '201407_TouristsMessageCount'
		,[201408] AS '201408_TouristsMessageCount'
		,[201409] AS '201409_TouristsMessageCount'
		,[201410] AS '201410_TouristsMessageCount'
		,[201411] AS '201411_TouristsMessageCount'
		,[201412] AS '201412_TouristsMessageCount'
		,[201501] AS '201501_TouristsMessageCount'
		,[201502] AS '201502_TouristsMessageCount'
		,[201503] AS '201503_TouristsMessageCount'
		,[201504] AS '201504_TouristsMessageCount'
		,[201505] AS '201505_TouristsMessageCount'
		,[201506] AS '201506_TouristsMessageCount'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		,D.TouristsMessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(TouristsMessageCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp1

DROP TABLE
	temp2
SELECT 
	[OBJECTID]
	,[201206] AS '201206_TouristsDistinctUserCount'
	,[201207] AS '201207_TouristsDistinctUserCount'
	,[201208] AS '201208_TouristsDistinctUserCount'
	,[201209] AS '201209_TouristsDistinctUserCount'
	,[201210] AS '201210_TouristsDistinctUserCount'
	,[201211] AS '201211_TouristsDistinctUserCount'
	,[201212] AS '201212_TouristsDistinctUserCount'
	,[201301] AS '201301_TouristsDistinctUserCount'
	,[201302] AS '201302_TouristsDistinctUserCount'
	,[201303] AS '201303_TouristsDistinctUserCount'
	,[201304] AS '201304_TouristsDistinctUserCount'
	,[201305] AS '201305_TouristsDistinctUserCount'
	,[201306] AS '201306_TouristsDistinctUserCount'
	,[201307] AS '201307_TouristsDistinctUserCount'
	,[201308] AS '201308_TouristsDistinctUserCount'
	,[201309] AS '201309_TouristsDistinctUserCount'
	,[201310] AS '201310_TouristsDistinctUserCount'
	,[201311] AS '201311_TouristsDistinctUserCount'
	,[201312] AS '201312_TouristsDistinctUserCount'
	,[201401] AS '201401_TouristsDistinctUserCount'
	,[201402] AS '201402_TouristsDistinctUserCount'
	,[201403] AS '201403_TouristsDistinctUserCount'
	,[201404] AS '201404_TouristsDistinctUserCount'
	,[201405] AS '201405_TouristsDistinctUserCount'
	,[201406] AS '201406_TouristsDistinctUserCount'
	,[201407] AS '201407_TouristsDistinctUserCount'
	,[201408] AS '201408_TouristsDistinctUserCount'
	,[201409] AS '201409_TouristsDistinctUserCount'
	,[201410] AS '201410_TouristsDistinctUserCount'
	,[201411] AS '201411_TouristsDistinctUserCount'
	,[201412] AS '201412_TouristsDistinctUserCount'
	,[201501] AS '201501_TouristsDistinctUserCount'
	,[201502] AS '201502_TouristsDistinctUserCount'
	,[201503] AS '201503_TouristsDistinctUserCount'
	,[201504] AS '201504_TouristsDistinctUserCount'
	,[201505] AS '201505_TouristsDistinctUserCount'
	,[201506] AS '201506_TouristsDistinctUserCount'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		--,D.MessageCount
		,D.TouristsDistinctUserCount
	FROM
		STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(TouristsDistinctUserCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp2

DROP TABLE
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
SELECT 
		 A.[OBJECTID]
		,A.[201206_TouristsMessageCount]
		,A.[201207_TouristsMessageCount]
		,A.[201208_TouristsMessageCount]
		,A.[201209_TouristsMessageCount]
		,A.[201210_TouristsMessageCount]
		,A.[201211_TouristsMessageCount]
		,A.[201212_TouristsMessageCount]
		,A.[201301_TouristsMessageCount]
		,A.[201302_TouristsMessageCount]
		,A.[201303_TouristsMessageCount]
		,A.[201304_TouristsMessageCount]
		,A.[201305_TouristsMessageCount]
		,A.[201306_TouristsMessageCount]
		,A.[201307_TouristsMessageCount]
		,A.[201308_TouristsMessageCount]
		,A.[201309_TouristsMessageCount]
		,A.[201310_TouristsMessageCount]
		,A.[201311_TouristsMessageCount]
		,A.[201312_TouristsMessageCount]
		,A.[201401_TouristsMessageCount]
		,A.[201402_TouristsMessageCount]
		,A.[201403_TouristsMessageCount]
		,A.[201404_TouristsMessageCount]
		,A.[201405_TouristsMessageCount]
		,A.[201406_TouristsMessageCount]
		,A.[201407_TouristsMessageCount]
		,A.[201408_TouristsMessageCount]
		,A.[201409_TouristsMessageCount]
		,A.[201410_TouristsMessageCount]
		,A.[201411_TouristsMessageCount]
		,A.[201412_TouristsMessageCount]
		,A.[201501_TouristsMessageCount]
		,A.[201502_TouristsMessageCount]
		,A.[201503_TouristsMessageCount]
		,A.[201504_TouristsMessageCount]
		,A.[201505_TouristsMessageCount]
		,A.[201506_TouristsMessageCount]
		,B.[201206_TouristsDistinctUserCount]
		  ,B.[201207_TouristsDistinctUserCount]
		  ,B.[201208_TouristsDistinctUserCount]
		  ,B.[201209_TouristsDistinctUserCount]
		  ,B.[201210_TouristsDistinctUserCount]
		  ,B.[201211_TouristsDistinctUserCount]
		  ,B.[201212_TouristsDistinctUserCount]
		  ,B.[201301_TouristsDistinctUserCount]
		  ,B.[201302_TouristsDistinctUserCount]
		  ,B.[201303_TouristsDistinctUserCount]
		  ,B.[201304_TouristsDistinctUserCount]
		  ,B.[201305_TouristsDistinctUserCount]
		  ,B.[201306_TouristsDistinctUserCount]
		  ,B.[201307_TouristsDistinctUserCount]
		  ,B.[201308_TouristsDistinctUserCount]
		  ,B.[201309_TouristsDistinctUserCount]
		  ,B.[201310_TouristsDistinctUserCount]
		  ,B.[201311_TouristsDistinctUserCount]
		  ,B.[201312_TouristsDistinctUserCount]
		  ,B.[201401_TouristsDistinctUserCount]
		  ,B.[201402_TouristsDistinctUserCount]
		  ,B.[201403_TouristsDistinctUserCount]
		  ,B.[201404_TouristsDistinctUserCount]
		  ,B.[201405_TouristsDistinctUserCount]
		  ,B.[201406_TouristsDistinctUserCount]
		  ,B.[201407_TouristsDistinctUserCount]
		  ,B.[201408_TouristsDistinctUserCount]
		  ,B.[201409_TouristsDistinctUserCount]
		  ,B.[201410_TouristsDistinctUserCount]
		  ,B.[201411_TouristsDistinctUserCount]
		  ,B.[201412_TouristsDistinctUserCount]
		  ,B.[201501_TouristsDistinctUserCount]
		  ,B.[201502_TouristsDistinctUserCount]
		  ,B.[201503_TouristsDistinctUserCount]
		  ,B.[201504_TouristsDistinctUserCount]
		  ,B.[201505_TouristsDistinctUserCount]
		  ,B.[201506_TouristsDistinctUserCount]
INTO
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID


				SELECT * FROM STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH



------------------------------------------------------------------------------------
-- f LINK STREET BLOCK to nearest CENSUS POINT
------------------------------------------------------------------------------------
SELECT 
	SB.OBJECTID
   ,SB.JOIN_FID as  CensusPointID
INTO
	SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID
FROM
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA] as SB


				SELECT * FROM SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID



------------------------------------------------------------------------------------
-- g Number of messages of Residents and tourists per streetblock per HOUR
------------------------------------------------------------------------------------
DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS ResidentsTotalMessageCount
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
JOIN
	[dbo].[NBT4_exact_copy] as AllAttributes -- only this one has userprovince information
ON
	LINK1.msgID = AllAttributes.msgID
WHERE
	AllAttributes.userprovince = 31
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC
SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp1
SELECT   
     [OBJECTID]
    ,[00] AS 'ResTMsgCnt_00'
    ,[01] AS 'ResTMsgCnt_01'
    ,[02] AS 'ResTMsgCnt_02'
    ,[03] AS 'ResTMsgCnt_03'
    ,[04] AS 'ResTMsgCnt_04'
    ,[05] AS 'ResTMsgCnt_05'
    ,[06] AS 'ResTMsgCnt_06'
    ,[07] AS 'ResTMsgCnt_07'
    ,[08] AS 'ResTMsgCnt_08'
    ,[09] AS 'ResTMsgCnt_09'
    ,[10] AS 'ResTMsgCnt_10'
    ,[11] AS 'ResTMsgCnt_11'
    ,[12] AS 'ResTMsgCnt_12'
    ,[13] AS 'ResTMsgCnt_13'
    ,[14] AS 'ResTMsgCnt_14'
    ,[15] AS 'ResTMsgCnt_15'
    ,[16] AS 'ResTMsgCnt_16'
    ,[17] AS 'ResTMsgCnt_17'
    ,[18] AS 'ResTMsgCnt_18'
    ,[19] AS 'ResTMsgCnt_19'
    ,[20] AS 'ResTMsgCnt_20'
    ,[21] AS 'ResTMsgCnt_21'
    ,[22] AS 'ResTMsgCnt_22'
    ,[23] AS 'ResTMsgCnt_23'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.ResidentsTotalMessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(ResidentsTotalMessageCount)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;
SELECT * FROM temp1



DROP TABLE
	STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS TouristTotalMessageCount
INTO
	STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
JOIN
	[dbo].[NBT4_exact_copy] as AllAttributes -- only this one has userprovince information
ON
	LINK1.msgID = AllAttributes.msgID
WHERE
	AllAttributes.userprovince <> 31 -- all messages from users that do not state provicen 31 in their profile
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC
SELECT * FROM STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp2
SELECT 
	 [OBJECTID]
	,[00] AS 'TouTMsgCnt_00'
	,[01] AS 'TouTMsgCnt_01'
	,[02] AS 'TouTMsgCnt_02'
	,[03] AS 'TouTMsgCnt_03'
	,[04] AS 'TouTMsgCnt_04'
	,[05] AS 'TouTMsgCnt_05'
	,[06] AS 'TouTMsgCnt_06'
	,[07] AS 'TouTMsgCnt_07'
	,[08] AS 'TouTMsgCnt_08'
	,[09] AS 'TouTMsgCnt_09'
	,[10] AS 'TouTMsgCnt_10'
	,[11] AS 'TouTMsgCnt_11'
	,[12] AS 'TouTMsgCnt_12'
	,[13] AS 'TouTMsgCnt_13'
	,[14] AS 'TouTMsgCnt_14'
	,[15] AS 'TouTMsgCnt_15'
	,[16] AS 'TouTMsgCnt_16'
	,[17] AS 'TouTMsgCnt_17'
	,[18] AS 'TouTMsgCnt_18'
	,[19] AS 'TouTMsgCnt_19'
	,[20] AS 'TouTMsgCnt_20'
	,[21] AS 'TouTMsgCnt_21'
	,[22] AS 'TouTMsgCnt_22'
	,[23] AS 'TouTMsgCnt_23'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.TouristTotalMessageCount
	FROM
		STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(TouristTotalMessageCount)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;
SELECT * FROM temp2


DROP TABLE
	STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS TotalMessageCountPerHour
INTO
	STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC
SELECT * FROM STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp3
SELECT   
     [OBJECTID]
	,[00] AS 'TotalMsgCnt_00'
	,[01] AS 'TotalMsgCnt_01'
	,[02] AS 'TotalMsgCnt_02'
	,[03] AS 'TotalMsgCnt_03'
	,[04] AS 'TotalMsgCnt_04'
	,[05] AS 'TotalMsgCnt_05'
	,[06] AS 'TotalMsgCnt_06'
	,[07] AS 'TotalMsgCnt_07'
	,[08] AS 'TotalMsgCnt_08'
	,[09] AS 'TotalMsgCnt_09'
	,[10] AS 'TotalMsgCnt_10'
	,[11] AS 'TotalMsgCnt_11'
	,[12] AS 'TotalMsgCnt_12'
	,[13] AS 'TotalMsgCnt_13'
	,[14] AS 'TotalMsgCnt_14'
	,[15] AS 'TotalMsgCnt_15'
	,[16] AS 'TotalMsgCnt_16'
	,[17] AS 'TotalMsgCnt_17'
	,[18] AS 'TotalMsgCnt_18'
	,[19] AS 'TotalMsgCnt_19'
	,[20] AS 'TotalMsgCnt_20'
	,[21] AS 'TotalMsgCnt_21'
	,[22] AS 'TotalMsgCnt_22'
	,[23] AS 'TotalMsgCnt_23'
INTO temp3
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.TotalMessageCountPerHour
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(TotalMessageCountPerHour)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;
SELECT * FROM temp3


DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR
SELECT 
		 A.[OBJECTID]
		,A.[ResTMsgCnt_00]
		,A.[ResTMsgCnt_01]
		,A.[ResTMsgCnt_02]
		,A.[ResTMsgCnt_03]
		,A.[ResTMsgCnt_04]
		,A.[ResTMsgCnt_05]
		,A.[ResTMsgCnt_06]
		,A.[ResTMsgCnt_07]
		,A.[ResTMsgCnt_08]
		,A.[ResTMsgCnt_09]
		,A.[ResTMsgCnt_10]
		,A.[ResTMsgCnt_11]
		,A.[ResTMsgCnt_12]
		,A.[ResTMsgCnt_13]
		,A.[ResTMsgCnt_14]
		,A.[ResTMsgCnt_15]
		,A.[ResTMsgCnt_16]
		,A.[ResTMsgCnt_17]
		,A.[ResTMsgCnt_18]
		,A.[ResTMsgCnt_19]
		,A.[ResTMsgCnt_20]
		,A.[ResTMsgCnt_21]
		,A.[ResTMsgCnt_22]
		,A.[ResTMsgCnt_23]
		,B.[TouTMsgCnt_00]
		,B.[TouTMsgCnt_01]
		,B.[TouTMsgCnt_02]
		,B.[TouTMsgCnt_03]
		,B.[TouTMsgCnt_04]
		,B.[TouTMsgCnt_05]
		,B.[TouTMsgCnt_06]
		,B.[TouTMsgCnt_07]
		,B.[TouTMsgCnt_08]
		,B.[TouTMsgCnt_09]
		,B.[TouTMsgCnt_10]
		,B.[TouTMsgCnt_11]
		,B.[TouTMsgCnt_12]
		,B.[TouTMsgCnt_13]
		,B.[TouTMsgCnt_14]
		,B.[TouTMsgCnt_15]
		,B.[TouTMsgCnt_16]
		,B.[TouTMsgCnt_17]
		,B.[TouTMsgCnt_18]
		,B.[TouTMsgCnt_19]
		,B.[TouTMsgCnt_20]
		,B.[TouTMsgCnt_21]
		,B.[TouTMsgCnt_22]
		,B.[TouTMsgCnt_23]
		,C.[TotalMsgCnt_00]
		,C.[TotalMsgCnt_01]
		,C.[TotalMsgCnt_02]
		,C.[TotalMsgCnt_03]
		,C.[TotalMsgCnt_04]
		,C.[TotalMsgCnt_05]
		,C.[TotalMsgCnt_06]
		,C.[TotalMsgCnt_07]
		,C.[TotalMsgCnt_08]
		,C.[TotalMsgCnt_09]
		,C.[TotalMsgCnt_10]
		,C.[TotalMsgCnt_11]
		,C.[TotalMsgCnt_12]
		,C.[TotalMsgCnt_13]
		,C.[TotalMsgCnt_14]
		,C.[TotalMsgCnt_15]
		,C.[TotalMsgCnt_16]
		,C.[TotalMsgCnt_17]
		,C.[TotalMsgCnt_18]
		,C.[TotalMsgCnt_19]
		,C.[TotalMsgCnt_20]
		,C.[TotalMsgCnt_21]
		,C.[TotalMsgCnt_22]
		,C.[TotalMsgCnt_23]
		
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID
JOIN 
	temp3 AS C
ON
	A.OBJECTID = C.OBJECTID


				SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR
				


------------------------------------------------------------------------------------------------------
-- 3. GET DATA FROM COHERENCE TO STREET BLOCKS INTO ONE BIG TABLE A_SHANGHAI_STEETBLOCKS_final
------------------------------------------------------------------------------------------------------
-- Consider the results produced with 
-- GT_STACK1_StreetBlockStatistics.sql
-- GT_STACK2_StreetBlockStatistics.sql

DROP TABLE
	A_SHANGHAI_STEETBLOCKS_final
SELECT
	 SBS.OBJECTID
	,SBS.Shape.STArea() AS AREASQM
	,WBf.CensusPointID AS CensusPointID
	,WBa.TotalMessageCount AS TotalMessageCount
	,WBa.TotalMessageCount/SBS.Shape.STArea() AS TotalMsgDensity
	,WBa.DistinctUserCount AS DistinctUserCount
	,WBb.ResidentsTotalMessageCount AS ResidentsTotalMessageCount
	,WBb.ResidentsTotalUserCount AS ResidentsTotalUserCount
	,WBc.[201206_MessageCount] AS 'MessageCount_201206'
	,WBc.[201207_MessageCount] AS 'MessageCount_201207'
	,WBc.[201208_MessageCount] AS 'MessageCount_201208'
	,WBc.[201209_MessageCount] AS 'MessageCount_201209'
	,WBc.[201210_MessageCount] AS 'MessageCount_201210'
	,WBc.[201211_MessageCount] AS 'MessageCount_201211'
	,WBc.[201212_MessageCount] AS 'MessageCount_201212'
	,WBc.[201301_MessageCount] AS 'MessageCount_201301'
	,WBc.[201302_MessageCount] AS 'MessageCount_201302'
	,WBc.[201303_MessageCount] AS 'MessageCount_201303'
	,WBc.[201304_MessageCount] AS 'MessageCount_201304'
	,WBc.[201305_MessageCount] AS 'MessageCount_201305'
	,WBc.[201306_MessageCount] AS 'MessageCount_201306'
	,WBc.[201307_MessageCount] AS 'MessageCount_201307'
	,WBc.[201308_MessageCount] AS 'MessageCount_201308'
	,WBc.[201309_MessageCount] AS 'MessageCount_201309'
	,WBc.[201310_MessageCount] AS 'MessageCount_201310'
	,WBc.[201311_MessageCount] AS 'MessageCount_201311'
	,WBc.[201312_MessageCount] AS 'MessageCount_201312'
	,WBc.[201401_MessageCount] AS 'MessageCount_201401'
	,WBc.[201402_MessageCount] AS 'MessageCount_201402'
	,WBc.[201403_MessageCount] AS 'MessageCount_201403'
	,WBc.[201404_MessageCount] AS 'MessageCount_201404'
	,WBc.[201405_MessageCount] AS 'MessageCount_201405'
	,WBc.[201406_MessageCount] AS 'MessageCount_201406'
	,WBc.[201407_MessageCount] AS 'MessageCount_201407'
	,WBc.[201408_MessageCount] AS 'MessageCount_201408'
	,WBc.[201409_MessageCount] AS 'MessageCount_201409'
	,WBc.[201410_MessageCount] AS 'MessageCount_201410'
	,WBc.[201411_MessageCount] AS 'MessageCount_201411'
	,WBc.[201412_MessageCount] AS 'MessageCount_201412'
	,WBc.[201501_MessageCount] AS 'MessageCount_201501'
	,WBc.[201502_MessageCount] AS 'MessageCount_201502'
	,WBc.[201503_MessageCount] AS 'MessageCount_201503'
	,WBc.[201504_MessageCount] AS 'MessageCount_201504'
	,WBc.[201505_MessageCount] AS 'MessageCount_201505'
	,WBc.[201506_MessageCount] AS 'MessageCount_201506'
	,WBc.[201206_DistinctUserCount] AS 'DistinctUserCount_201206'
	,WBc.[201207_DistinctUserCount] AS 'DistinctUserCount_201207'
	,WBc.[201208_DistinctUserCount] AS 'DistinctUserCount_201208'
	,WBc.[201209_DistinctUserCount] AS 'DistinctUserCount_201209'
	,WBc.[201210_DistinctUserCount] AS 'DistinctUserCount_201210'
	,WBc.[201211_DistinctUserCount] AS 'DistinctUserCount_201211'
	,WBc.[201212_DistinctUserCount] AS 'DistinctUserCount_201212'
	,WBc.[201301_DistinctUserCount] AS 'DistinctUserCount_201301'
	,WBc.[201302_DistinctUserCount] AS 'DistinctUserCount_201302'
	,WBc.[201303_DistinctUserCount] AS 'DistinctUserCount_201303'
	,WBc.[201304_DistinctUserCount] AS 'DistinctUserCount_201304'
	,WBc.[201305_DistinctUserCount] AS 'DistinctUserCount_201305'
	,WBc.[201306_DistinctUserCount] AS 'DistinctUserCount_201306'
	,WBc.[201307_DistinctUserCount] AS 'DistinctUserCount_201307'
	,WBc.[201308_DistinctUserCount] AS 'DistinctUserCount_201308'
	,WBc.[201309_DistinctUserCount] AS 'DistinctUserCount_201309'
	,WBc.[201310_DistinctUserCount] AS 'DistinctUserCount_201310'
	,WBc.[201311_DistinctUserCount] AS 'DistinctUserCount_201311'
	,WBc.[201312_DistinctUserCount] AS 'DistinctUserCount_201312'
	,WBc.[201401_DistinctUserCount] AS 'DistinctUserCount_201401'
	,WBc.[201402_DistinctUserCount] AS 'DistinctUserCount_201402'
	,WBc.[201403_DistinctUserCount] AS 'DistinctUserCount_201403'
	,WBc.[201404_DistinctUserCount] AS 'DistinctUserCount_201404'
	,WBc.[201405_DistinctUserCount] AS 'DistinctUserCount_201405'
	,WBc.[201406_DistinctUserCount] AS 'DistinctUserCount_201406'
	,WBc.[201407_DistinctUserCount] AS 'DistinctUserCount_201407'
	,WBc.[201408_DistinctUserCount] AS 'DistinctUserCount_201408'
	,WBc.[201409_DistinctUserCount] AS 'DistinctUserCount_201409'
	,WBc.[201410_DistinctUserCount] AS 'DistinctUserCount_201410'
	,WBc.[201411_DistinctUserCount] AS 'DistinctUserCount_201411'
	,WBc.[201412_DistinctUserCount] AS 'DistinctUserCount_201412'
	,WBc.[201501_DistinctUserCount] AS 'DistinctUserCount_201501'
	,WBc.[201502_DistinctUserCount] AS 'DistinctUserCount_201502'
	,WBc.[201503_DistinctUserCount] AS 'DistinctUserCount_201503'
	,WBc.[201504_DistinctUserCount] AS 'DistinctUserCount_201504'
	,WBc.[201505_DistinctUserCount] AS 'DistinctUserCount_201505'
	,WBc.[201506_DistinctUserCount] AS 'DistinctUserCount_201506'
	,WBd.[201206_ResidentsMessageCount] AS 'ResidentsMsgCnt_201206'
	,WBd.[201207_ResidentsMessageCount] AS 'ResidentsMsgCnt_201207'
	,WBd.[201208_ResidentsMessageCount] AS 'ResidentsMsgCnt_201208'
	,WBd.[201209_ResidentsMessageCount] AS 'ResidentsMsgCnt_201209'
	,WBd.[201210_ResidentsMessageCount] AS 'ResidentsMsgCnt_201210'
	,WBd.[201211_ResidentsMessageCount] AS 'ResidentsMsgCnt_201211'
	,WBd.[201212_ResidentsMessageCount] AS 'ResidentsMsgCnt_201212'
	,WBd.[201301_ResidentsMessageCount] AS 'ResidentsMsgCnt_201301'
	,WBd.[201302_ResidentsMessageCount] AS 'ResidentsMsgCnt_201302'
	,WBd.[201303_ResidentsMessageCount] AS 'ResidentsMsgCnt_201303'
	,WBd.[201304_ResidentsMessageCount] AS 'ResidentsMsgCnt_201304'
	,WBd.[201305_ResidentsMessageCount] AS 'ResidentsMsgCnt_201305'
	,WBd.[201306_ResidentsMessageCount] AS 'ResidentsMsgCnt_201306'
	,WBd.[201307_ResidentsMessageCount] AS 'ResidentsMsgCnt_201307'
	,WBd.[201308_ResidentsMessageCount] AS 'ResidentsMsgCnt_201308'
	,WBd.[201309_ResidentsMessageCount] AS 'ResidentsMsgCnt_201309'
	,WBd.[201310_ResidentsMessageCount] AS 'ResidentsMsgCnt_201310'
	,WBd.[201311_ResidentsMessageCount] AS 'ResidentsMsgCnt_201311'
	,WBd.[201312_ResidentsMessageCount] AS 'ResidentsMsgCnt_201312'
	,WBd.[201401_ResidentsMessageCount] AS 'ResidentsMsgCnt_201401'
	,WBd.[201402_ResidentsMessageCount] AS 'ResidentsMsgCnt_201402'
	,WBd.[201403_ResidentsMessageCount] AS 'ResidentsMsgCnt_201403'
	,WBd.[201404_ResidentsMessageCount] AS 'ResidentsMsgCnt_201404'
	,WBd.[201405_ResidentsMessageCount] AS 'ResidentsMsgCnt_201405'
	,WBd.[201406_ResidentsMessageCount] AS 'ResidentsMsgCnt_201406'
	,WBd.[201407_ResidentsMessageCount] AS 'ResidentsMsgCnt_201407'
	,WBd.[201408_ResidentsMessageCount] AS 'ResidentsMsgCnt_201408'
	,WBd.[201409_ResidentsMessageCount] AS 'ResidentsMsgCnt_201409'
	,WBd.[201410_ResidentsMessageCount] AS 'ResidentsMsgCnt_201410'
	,WBd.[201411_ResidentsMessageCount] AS 'ResidentsMsgCnt_201411'
	,WBd.[201412_ResidentsMessageCount] AS 'ResidentsMsgCnt_201412'
	,WBd.[201501_ResidentsMessageCount] AS 'ResidentsMsgCnt_201501'
	,WBd.[201502_ResidentsMessageCount] AS 'ResidentsMsgCnt_201502'
	,WBd.[201503_ResidentsMessageCount] AS 'ResidentsMsgCnt_201503'
	,WBd.[201504_ResidentsMessageCount] AS 'ResidentsMsgCnt_201504'
	,WBd.[201505_ResidentsMessageCount] AS 'ResidentsMsgCnt_201505'
	,WBd.[201506_ResidentsMessageCount] AS 'ResidentsMsgCnt_201506'
	,WBd.[201206_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201206' 
	,WBd.[201207_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201207' 
	,WBd.[201208_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201208' 
	,WBd.[201209_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201209' 
	,WBd.[201210_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201210' 
	,WBd.[201211_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201211' 
	,WBd.[201212_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201212' 
	,WBd.[201301_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201301' 
	,WBd.[201302_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201302' 
	,WBd.[201303_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201303' 
	,WBd.[201304_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201304' 
	,WBd.[201305_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201305' 
	,WBd.[201306_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201306' 
	,WBd.[201307_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201307' 
	,WBd.[201308_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201308' 
	,WBd.[201309_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201309' 
	,WBd.[201310_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201310' 
	,WBd.[201311_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201311' 
	,WBd.[201312_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201312' 
	,WBd.[201401_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201401' 
	,WBd.[201402_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201402' 
	,WBd.[201403_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201403' 
	,WBd.[201404_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201404' 
	,WBd.[201405_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201405' 
	,WBd.[201406_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201406' 
	,WBd.[201407_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201407' 
	,WBd.[201408_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201408' 
	,WBd.[201409_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201409' 
	,WBd.[201410_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201410' 
	,WBd.[201411_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201411' 
	,WBd.[201412_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201412' 
	,WBd.[201501_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201501' 
	,WBd.[201502_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201502' 
	,WBd.[201503_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201503' 
	,WBd.[201504_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201504' 
	,WBd.[201505_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201505' 
	,WBd.[201506_ResidentsDistinctUserCount] AS 'ResDistinctUsrCnt_201506' 
	,WBe.[201206_TouristsMessageCount] AS 'TouristsMsgCnt_201206'
	,WBe.[201207_TouristsMessageCount] AS 'TouristsMsgCnt_201207'
	,WBe.[201208_TouristsMessageCount] AS 'TouristsMsgCnt_201208'
	,WBe.[201209_TouristsMessageCount] AS 'TouristsMsgCnt_201209'
	,WBe.[201210_TouristsMessageCount] AS 'TouristsMsgCnt_201210'
	,WBe.[201211_TouristsMessageCount] AS 'TouristsMsgCnt_201211'
	,WBe.[201212_TouristsMessageCount] AS 'TouristsMsgCnt_201212'
	,WBe.[201301_TouristsMessageCount] AS 'TouristsMsgCnt_201301'
	,WBe.[201302_TouristsMessageCount] AS 'TouristsMsgCnt_201302'
	,WBe.[201303_TouristsMessageCount] AS 'TouristsMsgCnt_201303'
	,WBe.[201304_TouristsMessageCount] AS 'TouristsMsgCnt_201304'
	,WBe.[201305_TouristsMessageCount] AS 'TouristsMsgCnt_201305'
	,WBe.[201306_TouristsMessageCount] AS 'TouristsMsgCnt_201306'
	,WBe.[201307_TouristsMessageCount] AS 'TouristsMsgCnt_201307'
	,WBe.[201308_TouristsMessageCount] AS 'TouristsMsgCnt_201308'
	,WBe.[201309_TouristsMessageCount] AS 'TouristsMsgCnt_201309'
	,WBe.[201310_TouristsMessageCount] AS 'TouristsMsgCnt_201310'
	,WBe.[201311_TouristsMessageCount] AS 'TouristsMsgCnt_201311'
	,WBe.[201312_TouristsMessageCount] AS 'TouristsMsgCnt_201312'
	,WBe.[201401_TouristsMessageCount] AS 'TouristsMsgCnt_201401'
	,WBe.[201402_TouristsMessageCount] AS 'TouristsMsgCnt_201402'
	,WBe.[201403_TouristsMessageCount] AS 'TouristsMsgCnt_201403'
	,WBe.[201404_TouristsMessageCount] AS 'TouristsMsgCnt_201404'
	,WBe.[201405_TouristsMessageCount] AS 'TouristsMsgCnt_201405'
	,WBe.[201406_TouristsMessageCount] AS 'TouristsMsgCnt_201406'
	,WBe.[201407_TouristsMessageCount] AS 'TouristsMsgCnt_201407'
	,WBe.[201408_TouristsMessageCount] AS 'TouristsMsgCnt_201408'
	,WBe.[201409_TouristsMessageCount] AS 'TouristsMsgCnt_201409'
	,WBe.[201410_TouristsMessageCount] AS 'TouristsMsgCnt_201410'
	,WBe.[201411_TouristsMessageCount] AS 'TouristsMsgCnt_201411'
	,WBe.[201412_TouristsMessageCount] AS 'TouristsMsgCnt_201412'
	,WBe.[201501_TouristsMessageCount] AS 'TouristsMsgCnt_201501'
	,WBe.[201502_TouristsMessageCount] AS 'TouristsMsgCnt_201502'
	,WBe.[201503_TouristsMessageCount] AS 'TouristsMsgCnt_201503'
	,WBe.[201504_TouristsMessageCount] AS 'TouristsMsgCnt_201504'
	,WBe.[201505_TouristsMessageCount] AS 'TouristsMsgCnt_201505'
	,WBe.[201506_TouristsMessageCount] AS 'TouristsMsgCnt_201506'
	,WBe.[201206_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201206'
	,WBe.[201207_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201207'
	,WBe.[201208_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201208'
	,WBe.[201209_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201209'
	,WBe.[201210_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201210'
	,WBe.[201211_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201211'
	,WBe.[201212_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201212'
	,WBe.[201301_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201301'
	,WBe.[201302_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201302'
	,WBe.[201303_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201303'
	,WBe.[201304_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201304'
	,WBe.[201305_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201305'
	,WBe.[201306_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201306'
	,WBe.[201307_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201307'
	,WBe.[201308_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201308'
	,WBe.[201309_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201309'
	,WBe.[201310_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201310'
	,WBe.[201311_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201311'
	,WBe.[201312_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201312'
	,WBe.[201401_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201401'
	,WBe.[201402_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201402'
	,WBe.[201403_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201403'
	,WBe.[201404_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201404'
	,WBe.[201405_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201405'
	,WBe.[201406_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201406'
	,WBe.[201407_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201407'
	,WBe.[201408_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201408'
	,WBe.[201409_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201409'
	,WBe.[201410_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201410'
	,WBe.[201411_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201411'
	,WBe.[201412_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201412'
	,WBe.[201501_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201501'
	,WBe.[201502_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201502'
	,WBe.[201503_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201503'
	,WBe.[201504_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201504'
	,WBe.[201505_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201505'
	,WBe.[201506_TouristsDistinctUserCount] AS 'TouristsDistinctUsrCnt_201506'
	,WBg.[ResTMsgCnt_00] AS 'ResTtlMsgCntperH_00'
	,WBg.[ResTMsgCnt_01] AS 'ResTtlMsgCntperH_01'
	,WBg.[ResTMsgCnt_02] AS 'ResTtlMsgCntperH_02'
	,WBg.[ResTMsgCnt_03] AS 'ResTtlMsgCntperH_03'
	,WBg.[ResTMsgCnt_04] AS 'ResTtlMsgCntperH_04'
	,WBg.[ResTMsgCnt_05] AS 'ResTtlMsgCntperH_05'
	,WBg.[ResTMsgCnt_06] AS 'ResTtlMsgCntperH_06'
	,WBg.[ResTMsgCnt_07] AS 'ResTtlMsgCntperH_07'
	,WBg.[ResTMsgCnt_08] AS 'ResTtlMsgCntperH_08'
	,WBg.[ResTMsgCnt_09] AS 'ResTtlMsgCntperH_09'
	,WBg.[ResTMsgCnt_10] AS 'ResTtlMsgCntperH_10'
	,WBg.[ResTMsgCnt_11] AS 'ResTtlMsgCntperH_11'
	,WBg.[ResTMsgCnt_12] AS 'ResTtlMsgCntperH_12'
	,WBg.[ResTMsgCnt_13] AS 'ResTtlMsgCntperH_13'
	,WBg.[ResTMsgCnt_14] AS 'ResTtlMsgCntperH_14'
	,WBg.[ResTMsgCnt_15] AS 'ResTtlMsgCntperH_15'
	,WBg.[ResTMsgCnt_16] AS 'ResTtlMsgCntperH_16'
	,WBg.[ResTMsgCnt_17] AS 'ResTtlMsgCntperH_17'
	,WBg.[ResTMsgCnt_18] AS 'ResTtlMsgCntperH_18'
	,WBg.[ResTMsgCnt_19] AS 'ResTtlMsgCntperH_19'
	,WBg.[ResTMsgCnt_20] AS 'ResTtlMsgCntperH_20'
	,WBg.[ResTMsgCnt_21] AS 'ResTtlMsgCntperH_21'
	,WBg.[ResTMsgCnt_22] AS 'ResTtlMsgCntperH_22'
	,WBg.[ResTMsgCnt_23] AS 'ResTtlMsgCntperH_23'
	,WBg.[TouTMsgCnt_00] AS 'TouTtlMsgCntperH_00'
	,WBg.[TouTMsgCnt_01] AS 'TouTtlMsgCntperH_01'
	,WBg.[TouTMsgCnt_02] AS 'TouTtlMsgCntperH_02'
	,WBg.[TouTMsgCnt_03] AS 'TouTtlMsgCntperH_03'
	,WBg.[TouTMsgCnt_04] AS 'TouTtlMsgCntperH_04'
	,WBg.[TouTMsgCnt_05] AS 'TouTtlMsgCntperH_05'
	,WBg.[TouTMsgCnt_06] AS 'TouTtlMsgCntperH_06'
	,WBg.[TouTMsgCnt_07] AS 'TouTtlMsgCntperH_07'
	,WBg.[TouTMsgCnt_08] AS 'TouTtlMsgCntperH_08'
	,WBg.[TouTMsgCnt_09] AS 'TouTtlMsgCntperH_09'
	,WBg.[TouTMsgCnt_10] AS 'TouTtlMsgCntperH_10'
	,WBg.[TouTMsgCnt_11] AS 'TouTtlMsgCntperH_11'
	,WBg.[TouTMsgCnt_12] AS 'TouTtlMsgCntperH_12'
	,WBg.[TouTMsgCnt_13] AS 'TouTtlMsgCntperH_13'
	,WBg.[TouTMsgCnt_14] AS 'TouTtlMsgCntperH_14'
	,WBg.[TouTMsgCnt_15] AS 'TouTtlMsgCntperH_15'
	,WBg.[TouTMsgCnt_16] AS 'TouTtlMsgCntperH_16'
	,WBg.[TouTMsgCnt_17] AS 'TouTtlMsgCntperH_17'
	,WBg.[TouTMsgCnt_18] AS 'TouTtlMsgCntperH_18'
	,WBg.[TouTMsgCnt_19] AS 'TouTtlMsgCntperH_19'
	,WBg.[TouTMsgCnt_20] AS 'TouTtlMsgCntperH_20'
	,WBg.[TouTMsgCnt_21] AS 'TouTtlMsgCntperH_21'
	,WBg.[TouTMsgCnt_22] AS 'TouTtlMsgCntperH_22'
	,WBg.[TouTMsgCnt_23] AS 'TouTtlMsgCntperH_23'
	,WBg.[TotalMsgCnt_00] AS 'TotalMsgCntperH_00'
	,WBg.[TotalMsgCnt_01] AS 'TotalMsgCntperH_01'
	,WBg.[TotalMsgCnt_02] AS 'TotalMsgCntperH_02'
	,WBg.[TotalMsgCnt_03] AS 'TotalMsgCntperH_03'
	,WBg.[TotalMsgCnt_04] AS 'TotalMsgCntperH_04'
	,WBg.[TotalMsgCnt_05] AS 'TotalMsgCntperH_05'
	,WBg.[TotalMsgCnt_06] AS 'TotalMsgCntperH_06'
	,WBg.[TotalMsgCnt_07] AS 'TotalMsgCntperH_07'
	,WBg.[TotalMsgCnt_08] AS 'TotalMsgCntperH_08'
	,WBg.[TotalMsgCnt_09] AS 'TotalMsgCntperH_09'
	,WBg.[TotalMsgCnt_10] AS 'TotalMsgCntperH_10'
	,WBg.[TotalMsgCnt_11] AS 'TotalMsgCntperH_11'
	,WBg.[TotalMsgCnt_12] AS 'TotalMsgCntperH_12'
	,WBg.[TotalMsgCnt_13] AS 'TotalMsgCntperH_13'
	,WBg.[TotalMsgCnt_14] AS 'TotalMsgCntperH_14'
	,WBg.[TotalMsgCnt_15] AS 'TotalMsgCntperH_15'
	,WBg.[TotalMsgCnt_16] AS 'TotalMsgCntperH_16'
	,WBg.[TotalMsgCnt_17] AS 'TotalMsgCntperH_17'
	,WBg.[TotalMsgCnt_18] AS 'TotalMsgCntperH_18'
	,WBg.[TotalMsgCnt_19] AS 'TotalMsgCntperH_19'
	,WBg.[TotalMsgCnt_20] AS 'TotalMsgCntperH_20'
	,WBg.[TotalMsgCnt_21] AS 'TotalMsgCntperH_21'
	,WBg.[TotalMsgCnt_22] AS 'TotalMsgCntperH_22'
	,WBg.[TotalMsgCnt_23] AS 'TotalMsgCntperH_23'
	,SBC1.PointCount AS SBC1_PointCount
	,SBC2.PointCount AS SBC2_PointCount
	,SBC1.PointDensity AS SBC1_PointDensity
	,SBC2.PointDensity AS SBC2_PointDensity
	,SBC1.AvgCoh_20090328_20090408_1
	,SBC1.AvgCoh_20090328_20090419_2
	,SBC1.AvgCoh_20090328_20090511_3
	,SBC1.AvgCoh_20090328_20090522_4
	,SBC1.AvgCoh_20090328_20090602_5
	,SBC1.AvgCoh_20090328_20090624_6
	,SBC1.AvgCoh_20090408_20090419_7
	,SBC1.AvgCoh_20090408_20090511_8
	,SBC1.AvgCoh_20090408_20090522_9
	,SBC1.AvgCoh_20090408_20090602_10
	,SBC1.AvgCoh_20090419_20090511_11
	,SBC1.AvgCoh_20090419_20090522_12
	,SBC1.AvgCoh_20090419_20090602_13
	,SBC1.AvgCoh_20090419_20090624_14
	,SBC1.AvgCoh_20090511_20090522_15
	,SBC1.AvgCoh_20090511_20090602_16
	,SBC1.AvgCoh_20090511_20090624_17
	,SBC1.AvgCoh_20090522_20090602_18
	,SBC1.AvgCoh_20090522_20090624_19
	,SBC1.AvgCoh_20090624_20090829_20
	,SBC1.AvgCoh_20090624_20090920_21
	,SBC1.AvgCoh_20090829_20091012_22
	,SBC1.AvgCoh_20090829_20091023_23
	,SBC1.AvgCoh_20090920_20091012_24
	,SBC1.AvgCoh_20090920_20091023_25
	,SBC1.AvgCoh_20090920_20091114_26
	,SBC1.AvgCoh_20090920_20091206_27
	,SBC1.AvgCoh_20090920_20091217_28
	,SBC1.AvgCoh_20091012_20091023_29
	,SBC1.AvgCoh_20091012_20091114_30
	,SBC1.AvgCoh_20091012_20100108_31
	,SBC1.AvgCoh_20091023_20091114_32
	,SBC1.AvgCoh_20091023_20100108_33
	,SBC1.AvgCoh_20091023_20100119_34
	,SBC1.AvgCoh_20091114_20091206_35
	,SBC1.AvgCoh_20091114_20091217_36
	,SBC1.AvgCoh_20091114_20100108_37
	,SBC1.AvgCoh_20091114_20100119_38
	,SBC1.AvgCoh_20091114_20100130_39
	,SBC1.AvgCoh_20091206_20091217_40
	,SBC1.AvgCoh_20091206_20100108_41
	,SBC1.AvgCoh_20091206_20100119_42
	,SBC1.AvgCoh_20091217_20100108_43
	,SBC1.AvgCoh_20091217_20100119_44
	,SBC1.AvgCoh_20091228_20091206_45
	,SBC1.AvgCoh_20091228_20091217_46
	,SBC1.AvgCoh_20100108_20100119_47
	,SBC1.AvgCoh_20100108_20100130_48
	,SBC1.AvgCoh_20100119_20100130_49
	,SBC1.AvgCoh_20110916_20111008_50
	,SBC1.AvgCoh_20110916_20111213_51
	,SBC1.AvgCoh_20111008_20111213_52
	,SBC1.AvgCoh_20111008_20120104_53
	,SBC1.AvgCoh_20111121_20120104_54
	,SBC1.AvgCoh_20111121_20120206_55
	,SBC1.AvgCoh_20111213_20120310_56
	,SBC1.AvgCoh_20120104_20120206_57
	,SBC1.AvgCoh_20120104_20120310_58
	,SBC1.AvgCoh_20120104_20120401_59
	,SBC1.AvgCoh_20120206_20120310_60
	,SBC1.AvgCoh_20120206_20120401_61
	,SBC1.AvgCoh_20120310_20120401_62
	,SBC1.AvgCoh_20120310_20120515_63
	,SBC1.AvgCoh_20120401_20120515_64
	,SBC1.AvgCoh_20120401_20120628_65
	,SBC1.AvgCoh_20120515_20120628_66
	,SBC1.AvgCoh_20120515_20120811_67
	,SBC1.AvgCoh_20120628_20120811_68
	,SBC1.AvgCoh_20120628_20120902_69
	,SBC1.AvgCoh_20120720_20121005_70
	,SBC1.AvgCoh_20120811_20120902_71
	,SBC1.MaxCoh_20090328_20090408_1
	,SBC1.MaxCoh_20090328_20090419_2
	,SBC1.MaxCoh_20090328_20090511_3
	,SBC1.MaxCoh_20090328_20090522_4
	,SBC1.MaxCoh_20090328_20090602_5
	,SBC1.MaxCoh_20090328_20090624_6
	,SBC1.MaxCoh_20090408_20090419_7
	,SBC1.MaxCoh_20090408_20090511_8
	,SBC1.MaxCoh_20090408_20090522_9
	,SBC1.MaxCoh_20090408_20090602_10
	,SBC1.MaxCoh_20090419_20090511_11
	,SBC1.MaxCoh_20090419_20090522_12
	,SBC1.MaxCoh_20090419_20090602_13
	,SBC1.MaxCoh_20090419_20090624_14
	,SBC1.MaxCoh_20090511_20090522_15
	,SBC1.MaxCoh_20090511_20090602_16
	,SBC1.MaxCoh_20090511_20090624_17
	,SBC1.MaxCoh_20090522_20090602_18
	,SBC1.MaxCoh_20090522_20090624_19
	,SBC1.MaxCoh_20090624_20090829_20
	,SBC1.MaxCoh_20090624_20090920_21
	,SBC1.MaxCoh_20090829_20091012_22
	,SBC1.MaxCoh_20090829_20091023_23
	,SBC1.MaxCoh_20090920_20091012_24
	,SBC1.MaxCoh_20090920_20091023_25
	,SBC1.MaxCoh_20090920_20091114_26
	,SBC1.MaxCoh_20090920_20091206_27
	,SBC1.MaxCoh_20090920_20091217_28
	,SBC1.MaxCoh_20091012_20091023_29
	,SBC1.MaxCoh_20091012_20091114_30
	,SBC1.MaxCoh_20091012_20100108_31
	,SBC1.MaxCoh_20091023_20091114_32
	,SBC1.MaxCoh_20091023_20100108_33
	,SBC1.MaxCoh_20091023_20100119_34
	,SBC1.MaxCoh_20091114_20091206_35
	,SBC1.MaxCoh_20091114_20091217_36
	,SBC1.MaxCoh_20091114_20100108_37
	,SBC1.MaxCoh_20091114_20100119_38
	,SBC1.MaxCoh_20091114_20100130_39
	,SBC1.MaxCoh_20091206_20091217_40
	,SBC1.MaxCoh_20091206_20100108_41
	,SBC1.MaxCoh_20091206_20100119_42
	,SBC1.MaxCoh_20091217_20100108_43
	,SBC1.MaxCoh_20091217_20100119_44
	,SBC1.MaxCoh_20091228_20091206_45
	,SBC1.MaxCoh_20091228_20091217_46
	,SBC1.MaxCoh_20100108_20100119_47
	,SBC1.MaxCoh_20100108_20100130_48
	,SBC1.MaxCoh_20100119_20100130_49
	,SBC1.MaxCoh_20110916_20111008_50
	,SBC1.MaxCoh_20110916_20111213_51
	,SBC1.MaxCoh_20111008_20111213_52
	,SBC1.MaxCoh_20111008_20120104_53
	,SBC1.MaxCoh_20111121_20120104_54
	,SBC1.MaxCoh_20111121_20120206_55
	,SBC1.MaxCoh_20111213_20120310_56
	,SBC1.MaxCoh_20120104_20120206_57
	,SBC1.MaxCoh_20120104_20120310_58
	,SBC1.MaxCoh_20120104_20120401_59
	,SBC1.MaxCoh_20120206_20120310_60
	,SBC1.MaxCoh_20120206_20120401_61
	,SBC1.MaxCoh_20120310_20120401_62
	,SBC1.MaxCoh_20120310_20120515_63
	,SBC1.MaxCoh_20120401_20120515_64
	,SBC1.MaxCoh_20120401_20120628_65
	,SBC1.MaxCoh_20120515_20120628_66
	,SBC1.MaxCoh_20120515_20120811_67
	,SBC1.MaxCoh_20120628_20120811_68
	,SBC1.MaxCoh_20120628_20120902_69
	,SBC1.MaxCoh_20120720_20121005_70
	,SBC1.MaxCoh_20120811_20120902_71
	,SBC1.MinCoh_20090328_20090408_1
	,SBC1.MinCoh_20090328_20090419_2
	,SBC1.MinCoh_20090328_20090511_3
	,SBC1.MinCoh_20090328_20090522_4
	,SBC1.MinCoh_20090328_20090602_5
	,SBC1.MinCoh_20090328_20090624_6
	,SBC1.MinCoh_20090408_20090419_7
	,SBC1.MinCoh_20090408_20090511_8
	,SBC1.MinCoh_20090408_20090522_9
	,SBC1.MinCoh_20090408_20090602_10
	,SBC1.MinCoh_20090419_20090511_11
	,SBC1.MinCoh_20090419_20090522_12
	,SBC1.MinCoh_20090419_20090602_13
	,SBC1.MinCoh_20090419_20090624_14
	,SBC1.MinCoh_20090511_20090522_15
	,SBC1.MinCoh_20090511_20090602_16
	,SBC1.MinCoh_20090511_20090624_17
	,SBC1.MinCoh_20090522_20090602_18
	,SBC1.MinCoh_20090522_20090624_19
	,SBC1.MinCoh_20090624_20090829_20
	,SBC1.MinCoh_20090624_20090920_21
	,SBC1.MinCoh_20090829_20091012_22
	,SBC1.MinCoh_20090829_20091023_23
	,SBC1.MinCoh_20090920_20091012_24
	,SBC1.MinCoh_20090920_20091023_25
	,SBC1.MinCoh_20090920_20091114_26
	,SBC1.MinCoh_20090920_20091206_27
	,SBC1.MinCoh_20090920_20091217_28
	,SBC1.MinCoh_20091012_20091023_29
	,SBC1.MinCoh_20091012_20091114_30
	,SBC1.MinCoh_20091012_20100108_31
	,SBC1.MinCoh_20091023_20091114_32
	,SBC1.MinCoh_20091023_20100108_33
	,SBC1.MinCoh_20091023_20100119_34
	,SBC1.MinCoh_20091114_20091206_35
	,SBC1.MinCoh_20091114_20091217_36
	,SBC1.MinCoh_20091114_20100108_37
	,SBC1.MinCoh_20091114_20100119_38
	,SBC1.MinCoh_20091114_20100130_39
	,SBC1.MinCoh_20091206_20091217_40
	,SBC1.MinCoh_20091206_20100108_41
	,SBC1.MinCoh_20091206_20100119_42
	,SBC1.MinCoh_20091217_20100108_43
	,SBC1.MinCoh_20091217_20100119_44
	,SBC1.MinCoh_20091228_20091206_45
	,SBC1.MinCoh_20091228_20091217_46
	,SBC1.MinCoh_20100108_20100119_47
	,SBC1.MinCoh_20100108_20100130_48
	,SBC1.MinCoh_20100119_20100130_49
	,SBC1.MinCoh_20110916_20111008_50
	,SBC1.MinCoh_20110916_20111213_51
	,SBC1.MinCoh_20111008_20111213_52
	,SBC1.MinCoh_20111008_20120104_53
	,SBC1.MinCoh_20111121_20120104_54
	,SBC1.MinCoh_20111121_20120206_55
	,SBC1.MinCoh_20111213_20120310_56
	,SBC1.MinCoh_20120104_20120206_57
	,SBC1.MinCoh_20120104_20120310_58
	,SBC1.MinCoh_20120104_20120401_59
	,SBC1.MinCoh_20120206_20120310_60
	,SBC1.MinCoh_20120206_20120401_61
	,SBC1.MinCoh_20120310_20120401_62
	,SBC1.MinCoh_20120310_20120515_63
	,SBC1.MinCoh_20120401_20120515_64
	,SBC1.MinCoh_20120401_20120628_65
	,SBC1.MinCoh_20120515_20120628_66
	,SBC1.MinCoh_20120515_20120811_67
	,SBC1.MinCoh_20120628_20120811_68
	,SBC1.MinCoh_20120628_20120902_69
	,SBC1.MinCoh_20120720_20121005_70
	,SBC1.MinCoh_20120811_20120902_71
	,SBC1.StDevCoh_20090328_20090408_1
	,SBC1.StDevCoh_20090328_20090419_2
	,SBC1.StDevCoh_20090328_20090511_3
	,SBC1.StDevCoh_20090328_20090522_4
	,SBC1.StDevCoh_20090328_20090602_5
	,SBC1.StDevCoh_20090328_20090624_6
	,SBC1.StDevCoh_20090408_20090419_7
	,SBC1.StDevCoh_20090408_20090511_8
	,SBC1.StDevCoh_20090408_20090522_9
	,SBC1.StDevCoh_20090408_20090602_10
	,SBC1.StDevCoh_20090419_20090511_11
	,SBC1.StDevCoh_20090419_20090522_12
	,SBC1.StDevCoh_20090419_20090602_13
	,SBC1.StDevCoh_20090419_20090624_14
	,SBC1.StDevCoh_20090511_20090522_15
	,SBC1.StDevCoh_20090511_20090602_16
	,SBC1.StDevCoh_20090511_20090624_17
	,SBC1.StDevCoh_20090522_20090602_18
	,SBC1.StDevCoh_20090522_20090624_19
	,SBC1.StDevCoh_20090624_20090829_20
	,SBC1.StDevCoh_20090624_20090920_21
	,SBC1.StDevCoh_20090829_20091012_22
	,SBC1.StDevCoh_20090829_20091023_23
	,SBC1.StDevCoh_20090920_20091012_24
	,SBC1.StDevCoh_20090920_20091023_25
	,SBC1.StDevCoh_20090920_20091114_26
	,SBC1.StDevCoh_20090920_20091206_27
	,SBC1.StDevCoh_20090920_20091217_28
	,SBC1.StDevCoh_20091012_20091023_29
	,SBC1.StDevCoh_20091012_20091114_30
	,SBC1.StDevCoh_20091012_20100108_31
	,SBC1.StDevCoh_20091023_20091114_32
	,SBC1.StDevCoh_20091023_20100108_33
	,SBC1.StDevCoh_20091023_20100119_34
	,SBC1.StDevCoh_20091114_20091206_35
	,SBC1.StDevCoh_20091114_20091217_36
	,SBC1.StDevCoh_20091114_20100108_37
	,SBC1.StDevCoh_20091114_20100119_38
	,SBC1.StDevCoh_20091114_20100130_39
	,SBC1.StDevCoh_20091206_20091217_40
	,SBC1.StDevCoh_20091206_20100108_41
	,SBC1.StDevCoh_20091206_20100119_42
	,SBC1.StDevCoh_20091217_20100108_43
	,SBC1.StDevCoh_20091217_20100119_44
	,SBC1.StDevCoh_20091228_20091206_45
	,SBC1.StDevCoh_20091228_20091217_46
	,SBC1.StDevCoh_20100108_20100119_47
	,SBC1.StDevCoh_20100108_20100130_48
	,SBC1.StDevCoh_20100119_20100130_49
	,SBC1.StDevCoh_20110916_20111008_50
	,SBC1.StDevCoh_20110916_20111213_51
	,SBC1.StDevCoh_20111008_20111213_52
	,SBC1.StDevCoh_20111008_20120104_53
	,SBC1.StDevCoh_20111121_20120104_54
	,SBC1.StDevCoh_20111121_20120206_55
	,SBC1.StDevCoh_20111213_20120310_56
	,SBC1.StDevCoh_20120104_20120206_57
	,SBC1.StDevCoh_20120104_20120310_58
	,SBC1.StDevCoh_20120104_20120401_59
	,SBC1.StDevCoh_20120206_20120310_60
	,SBC1.StDevCoh_20120206_20120401_61
	,SBC1.StDevCoh_20120310_20120401_62
	,SBC1.StDevCoh_20120310_20120515_63
	,SBC1.StDevCoh_20120401_20120515_64
	,SBC1.StDevCoh_20120401_20120628_65
	,SBC1.StDevCoh_20120515_20120628_66
	,SBC1.StDevCoh_20120515_20120811_67
	,SBC1.StDevCoh_20120628_20120811_68
	,SBC1.StDevCoh_20120628_20120902_69
	,SBC1.StDevCoh_20120720_20121005_70
	,SBC1.StDevCoh_20120811_20120902_71
	,SBC1.StDevPCoh_20090328_20090408_1
	,SBC1.StDevPCoh_20090328_20090419_2
	,SBC1.StDevPCoh_20090328_20090511_3
	,SBC1.StDevPCoh_20090328_20090522_4
	,SBC1.StDevPCoh_20090328_20090602_5
	,SBC1.StDevPCoh_20090328_20090624_6
	,SBC1.StDevPCoh_20090408_20090419_7
	,SBC1.StDevPCoh_20090408_20090511_8
	,SBC1.StDevPCoh_20090408_20090522_9
	,SBC1.StDevPCoh_20090408_20090602_10
	,SBC1.StDevPCoh_20090419_20090511_11
	,SBC1.StDevPCoh_20090419_20090522_12
	,SBC1.StDevPCoh_20090419_20090602_13
	,SBC1.StDevPCoh_20090419_20090624_14
	,SBC1.StDevPCoh_20090511_20090522_15
	,SBC1.StDevPCoh_20090511_20090602_16
	,SBC1.StDevPCoh_20090511_20090624_17
	,SBC1.StDevPCoh_20090522_20090602_18
	,SBC1.StDevPCoh_20090522_20090624_19
	,SBC1.StDevPCoh_20090624_20090829_20
	,SBC1.StDevPCoh_20090624_20090920_21
	,SBC1.StDevPCoh_20090829_20091012_22
	,SBC1.StDevPCoh_20090829_20091023_23
	,SBC1.StDevPCoh_20090920_20091012_24
	,SBC1.StDevPCoh_20090920_20091023_25
	,SBC1.StDevPCoh_20090920_20091114_26
	,SBC1.StDevPCoh_20090920_20091206_27
	,SBC1.StDevPCoh_20090920_20091217_28
	,SBC1.StDevPCoh_20091012_20091023_29
	,SBC1.StDevPCoh_20091012_20091114_30
	,SBC1.StDevPCoh_20091012_20100108_31
	,SBC1.StDevPCoh_20091023_20091114_32
	,SBC1.StDevPCoh_20091023_20100108_33
	,SBC1.StDevPCoh_20091023_20100119_34
	,SBC1.StDevPCoh_20091114_20091206_35
	,SBC1.StDevPCoh_20091114_20091217_36
	,SBC1.StDevPCoh_20091114_20100108_37
	,SBC1.StDevPCoh_20091114_20100119_38
	,SBC1.StDevPCoh_20091114_20100130_39
	,SBC1.StDevPCoh_20091206_20091217_40
	,SBC1.StDevPCoh_20091206_20100108_41
	,SBC1.StDevPCoh_20091206_20100119_42
	,SBC1.StDevPCoh_20091217_20100108_43
	,SBC1.StDevPCoh_20091217_20100119_44
	,SBC1.StDevPCoh_20091228_20091206_45
	,SBC1.StDevPCoh_20091228_20091217_46
	,SBC1.StDevPCoh_20100108_20100119_47
	,SBC1.StDevPCoh_20100108_20100130_48
	,SBC1.StDevPCoh_20100119_20100130_49
	,SBC1.StDevPCoh_20110916_20111008_50
	,SBC1.StDevPCoh_20110916_20111213_51
	,SBC1.StDevPCoh_20111008_20111213_52
	,SBC1.StDevPCoh_20111008_20120104_53
	,SBC1.StDevPCoh_20111121_20120104_54
	,SBC1.StDevPCoh_20111121_20120206_55
	,SBC1.StDevPCoh_20111213_20120310_56
	,SBC1.StDevPCoh_20120104_20120206_57
	,SBC1.StDevPCoh_20120104_20120310_58
	,SBC1.StDevPCoh_20120104_20120401_59
	,SBC1.StDevPCoh_20120206_20120310_60
	,SBC1.StDevPCoh_20120206_20120401_61
	,SBC1.StDevPCoh_20120310_20120401_62
	,SBC1.StDevPCoh_20120310_20120515_63
	,SBC1.StDevPCoh_20120401_20120515_64
	,SBC1.StDevPCoh_20120401_20120628_65
	,SBC1.StDevPCoh_20120515_20120628_66
	,SBC1.StDevPCoh_20120515_20120811_67
	,SBC1.StDevPCoh_20120628_20120811_68
	,SBC1.StDevPCoh_20120628_20120902_69
	,SBC1.StDevPCoh_20120720_20121005_70
	,SBC1.StDevPCoh_20120811_20120902_71
	,SBC2.AvgCoh_20130416_20130508_1
	,SBC2.AvgCoh_20130416_20130621_2
	,SBC2.AvgCoh_20130508_20130621_3
	,SBC2.AvgCoh_20130508_20130713_4
	,SBC2.AvgCoh_20130621_20130917_5
	,SBC2.AvgCoh_20130713_20130917_6
	,SBC2.AvgCoh_20130917_20131214_7
	,SBC2.AvgCoh_20131214_20140312_8
	,SBC2.AvgCoh_20140312_20140517_9
	,SBC2.AvgCoh_20140802_20140517_10
	,SBC2.AvgCoh_20140802_20140915_11
	,SBC2.AvgCoh_20140802_20141029_12
	,SBC2.AvgCoh_20141029_20141223_13
	,SBC2.AvgCoh_20150401_20150515_14
	,SBC2.MaxCoh_20130416_20130508_1
	,SBC2.MaxCoh_20130416_20130621_2
	,SBC2.MaxCoh_20130508_20130621_3
	,SBC2.MaxCoh_20130508_20130713_4
	,SBC2.MaxCoh_20130621_20130917_5
	,SBC2.MaxCoh_20130713_20130917_6
	,SBC2.MaxCoh_20130917_20131214_7
	,SBC2.MaxCoh_20131214_20140312_8
	,SBC2.MaxCoh_20140312_20140517_9
	,SBC2.MaxCoh_20140802_20140517_10
	,SBC2.MaxCoh_20140802_20140915_11
	,SBC2.MaxCoh_20140802_20141029_12
	,SBC2.MaxCoh_20141029_20141223_13
	,SBC2.MaxCoh_20150401_20150515_14
	,SBC2.MinCoh_20130416_20130508_1
	,SBC2.MinCoh_20130416_20130621_2
	,SBC2.MinCoh_20130508_20130621_3
	,SBC2.MinCoh_20130508_20130713_4
	,SBC2.MinCoh_20130621_20130917_5
	,SBC2.MinCoh_20130713_20130917_6
	,SBC2.MinCoh_20130917_20131214_7
	,SBC2.MinCoh_20131214_20140312_8
	,SBC2.MinCoh_20140312_20140517_9
	,SBC2.MinCoh_20140802_20140517_10
	,SBC2.MinCoh_20140802_20140915_11
	,SBC2.MinCoh_20140802_20141029_12
	,SBC2.MinCoh_20141029_20141223_13
	,SBC2.MinCoh_20150401_20150515_14
	,SBC2.StDevCoh_20130416_20130508_1
	,SBC2.StDevCoh_20130416_20130621_2
	,SBC2.StDevCoh_20130508_20130621_3
	,SBC2.StDevCoh_20130508_20130713_4
	,SBC2.StDevCoh_20130621_20130917_5
	,SBC2.StDevCoh_20130713_20130917_6
	,SBC2.StDevCoh_20130917_20131214_7
	,SBC2.StDevCoh_20131214_20140312_8
	,SBC2.StDevCoh_20140312_20140517_9
	,SBC2.StDevCoh_20140802_20140517_10
	,SBC2.StDevCoh_20140802_20140915_11
	,SBC2.StDevCoh_20140802_20141029_12
	,SBC2.StDevCoh_20141029_20141223_13
	,SBC2.StDevCoh_20150401_20150515_14
	,SBC2.StDevPCoh_20130416_20130508_1
	,SBC2.StDevPCoh_20130416_20130621_2
	,SBC2.StDevPCoh_20130508_20130621_3
	,SBC2.StDevPCoh_20130508_20130713_4
	,SBC2.StDevPCoh_20130621_20130917_5
	,SBC2.StDevPCoh_20130713_20130917_6
	,SBC2.StDevPCoh_20130917_20131214_7
	,SBC2.StDevPCoh_20131214_20140312_8
	,SBC2.StDevPCoh_20140312_20140517_9
	,SBC2.StDevPCoh_20140802_20140517_10
	,SBC2.StDevPCoh_20140802_20140915_11
	,SBC2.StDevPCoh_20140802_20141029_12
	,SBC2.StDevPCoh_20141029_20141223_13
	,SBC2.StDevPCoh_20150401_20150515_14
	,SBS.Shape
INTO 
	A_SHANGHAI_STEETBLOCKS_final
FROM 
	SHANGHAI_STREET_BLOCKS_ROADS_RIVERS_BORDERS AS SBS -- streetblock shape
JOIN
	[dbo].[STACK_1_EQ_STREETBLOCKS] AS SBC1 -- streetblock coherence stack 1
ON
	SBS.OBJECTID = SBC1.STREETBLOCKID
JOIN
	[dbo].[STACK_2_EQ_STREETBLOCKS] AS SBC2 -- streetblock coherence stack 2
ON
	SBS.OBJECTID = SBC2.STREETBLOCKID
LEFT OUTER JOIN
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount													AS WBa
ON
	SBS.OBJECTID = WBa.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount								AS WBb
ON
	SBS.OBJECTID = WBb.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH										AS WBc
ON
	SBS.OBJECTID = WBc.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH						AS WBd
ON
	SBS.OBJECTID = WBd.OBJECTID
LEFT OUTER JOIN 
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH						AS WBe
ON
	SBS.OBJECTID = WBe.OBJECTID
LEFT OUTER JOIN
	SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID											AS WBf
ON
	SBS.OBJECTID = WBf.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR	AS WBg
ON
	SBS.OBJECTID = WBg.OBJECTID


USE [weiboDEV]
GO

/****** Object:  Index [PK_SHANGHAI_STEETBLOCKS_final]    Script Date: 2/3/2016 5:03:45 PM ******/
ALTER TABLE [dbo].[A_SHANGHAI_STEETBLOCKS_final] ADD  CONSTRAINT [PK_A_SHANGHAI_STEETBLOCKS_final] PRIMARY KEY CLUSTERED 
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE [weiboDEV]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE SPATIAL INDEX [SpatialIndex-Shape] ON [dbo].[A_SHANGHAI_STEETBLOCKS_final]
(
	[Shape]
)USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO


				SELECT * FROM A_SHANGHAI_STEETBLOCKS_final



------------------------------------------------------------------------------------------------------
-- 4. CREATE ONE BIG TABLE FOR URBAN DISTRICTS A_SHANGHAI_URBANDISTRICTS_final
------------------------------------------------------------------------------------------------------
DROP TABLE
	A_SHANGHAI_URBANDISTRICTS_final
SELECT 
    SOURCE.CensusPointID												 AS OBJECTID
   ,MAX(CENSUS.TID)														 AS TID
   ,geography::UnionAggregate(SOURCE.Shape).STArea()                     AS AREASQM
   ,SUM(SOURCE.TotalMessageCount)                                        AS TotalMessageCount
   ,SUM(SOURCE.TotalMessageCount)/geography::UnionAggregate(SOURCE.Shape).STArea()    AS TotalMsgDensity 
   ,SUM(SOURCE.DistinctUserCount)                                        AS DistinctUserCount
   ,SUM(SOURCE.ResidentsTotalMessageCount)                               AS ResidentsTotalMessageCount
   ,SUM(SOURCE.ResidentsTotalUserCount)                                  AS ResidentsTotalUserCount
   ,SUM(SOURCE.DistinctUserCount)-SUM(SOURCE.ResidentsTotalUserCount)	 AS TouristsTotalUserCount
   ,MAX(CENSUS.AGE0)													 AS 'CensusAge0' -- MAX should be fine
   ,MAX(CENSUS.AGE15)												     AS 'CensusAge15'
   ,MAX(CENSUS.AGE65)												     AS 'CensusAge65'
   ,MAX(CENSUS.F)														 AS 'CensusF'
   ,MAX(CENSUS.M)														 AS 'CensusM'
   ,MAX(CENSUS.POP)														 AS 'CensusPOP'
   ,MAX(CENSUS.Address)													 AS 'CensusAddress'
   
   ,MAX(CENSUS.POP)/geography::UnionAggregate(SOURCE.Shape).STArea()     AS PopulationDensity

   ,SUM(SOURCE.MessageCount_201206)                                      AS 'MessageCount_201206'
   ,SUM(SOURCE.MessageCount_201207)                                      AS 'MessageCount_201207'
   ,SUM(SOURCE.MessageCount_201208)                                      AS 'MessageCount_201208'
   ,SUM(SOURCE.MessageCount_201209)                                      AS 'MessageCount_201209'
   ,SUM(SOURCE.MessageCount_201210)                                      AS 'MessageCount_201210'
   ,SUM(SOURCE.MessageCount_201211)                                      AS 'MessageCount_201211'
   ,SUM(SOURCE.MessageCount_201212)                                      AS 'MessageCount_201212'
   ,SUM(SOURCE.MessageCount_201301)                                      AS 'MessageCount_201301'
   ,SUM(SOURCE.MessageCount_201302)                                      AS 'MessageCount_201302'
   ,SUM(SOURCE.MessageCount_201303)                                      AS 'MessageCount_201303'
   ,SUM(SOURCE.MessageCount_201304)                                      AS 'MessageCount_201304'
   ,SUM(SOURCE.MessageCount_201305)                                      AS 'MessageCount_201305'
   ,SUM(SOURCE.MessageCount_201306)                                      AS 'MessageCount_201306'
   ,SUM(SOURCE.MessageCount_201307)                                      AS 'MessageCount_201307'
   ,SUM(SOURCE.MessageCount_201308)                                      AS 'MessageCount_201308'
   ,SUM(SOURCE.MessageCount_201309)                                      AS 'MessageCount_201309'
   ,SUM(SOURCE.MessageCount_201310)                                      AS 'MessageCount_201310'
   ,SUM(SOURCE.MessageCount_201311)                                      AS 'MessageCount_201311'
   ,SUM(SOURCE.MessageCount_201312)                                      AS 'MessageCount_201312'
   ,SUM(SOURCE.MessageCount_201401)                                      AS 'MessageCount_201401'
   ,SUM(SOURCE.MessageCount_201402)                                      AS 'MessageCount_201402'
   ,SUM(SOURCE.MessageCount_201403)                                      AS 'MessageCount_201403'
   ,SUM(SOURCE.MessageCount_201404)                                      AS 'MessageCount_201404'
   ,SUM(SOURCE.MessageCount_201405)                                      AS 'MessageCount_201405'
   ,SUM(SOURCE.MessageCount_201406)                                      AS 'MessageCount_201406'
   ,SUM(SOURCE.MessageCount_201407)                                      AS 'MessageCount_201407'
   ,SUM(SOURCE.MessageCount_201408)                                      AS 'MessageCount_201408'
   ,SUM(SOURCE.MessageCount_201409)                                      AS 'MessageCount_201409'
   ,SUM(SOURCE.MessageCount_201410)                                      AS 'MessageCount_201410'
   ,SUM(SOURCE.MessageCount_201411)                                      AS 'MessageCount_201411'
   ,SUM(SOURCE.MessageCount_201412)                                      AS 'MessageCount_201412'
   ,SUM(SOURCE.MessageCount_201501)                                      AS 'MessageCount_201501'
   ,SUM(SOURCE.MessageCount_201502)                                      AS 'MessageCount_201502'
   ,SUM(SOURCE.MessageCount_201503)                                      AS 'MessageCount_201503'
   ,SUM(SOURCE.MessageCount_201504)                                      AS 'MessageCount_201504'
   ,SUM(SOURCE.MessageCount_201505)                                      AS 'MessageCount_201505'
   ,SUM(SOURCE.MessageCount_201506)                                      AS 'MessageCount_201506'
   ,SUM(SOURCE.DistinctUserCount_201206)                                 AS 'DistinctUserCount_201206'
   ,SUM(SOURCE.DistinctUserCount_201207)                                 AS 'DistinctUserCount_201207'
   ,SUM(SOURCE.DistinctUserCount_201208)                                 AS 'DistinctUserCount_201208'
   ,SUM(SOURCE.DistinctUserCount_201209)                                 AS 'DistinctUserCount_201209'
   ,SUM(SOURCE.DistinctUserCount_201210)                                 AS 'DistinctUserCount_201210'
   ,SUM(SOURCE.DistinctUserCount_201211)                                 AS 'DistinctUserCount_201211'
   ,SUM(SOURCE.DistinctUserCount_201212)                                 AS 'DistinctUserCount_201212'
   ,SUM(SOURCE.DistinctUserCount_201301)                                 AS 'DistinctUserCount_201301'
   ,SUM(SOURCE.DistinctUserCount_201302)                                 AS 'DistinctUserCount_201302'
   ,SUM(SOURCE.DistinctUserCount_201303)                                 AS 'DistinctUserCount_201303'
   ,SUM(SOURCE.DistinctUserCount_201304)                                 AS 'DistinctUserCount_201304'
   ,SUM(SOURCE.DistinctUserCount_201305)                                 AS 'DistinctUserCount_201305'
   ,SUM(SOURCE.DistinctUserCount_201306)                                 AS 'DistinctUserCount_201306'
   ,SUM(SOURCE.DistinctUserCount_201307)                                 AS 'DistinctUserCount_201307'
   ,SUM(SOURCE.DistinctUserCount_201308)                                 AS 'DistinctUserCount_201308'
   ,SUM(SOURCE.DistinctUserCount_201309)                                 AS 'DistinctUserCount_201309'
   ,SUM(SOURCE.DistinctUserCount_201310)                                 AS 'DistinctUserCount_201310'
   ,SUM(SOURCE.DistinctUserCount_201311)                                 AS 'DistinctUserCount_201311'
   ,SUM(SOURCE.DistinctUserCount_201312)                                 AS 'DistinctUserCount_201312'
   ,SUM(SOURCE.DistinctUserCount_201401)                                 AS 'DistinctUserCount_201401'
   ,SUM(SOURCE.DistinctUserCount_201402)                                 AS 'DistinctUserCount_201402'
   ,SUM(SOURCE.DistinctUserCount_201403)                                 AS 'DistinctUserCount_201403'
   ,SUM(SOURCE.DistinctUserCount_201404)                                 AS 'DistinctUserCount_201404'
   ,SUM(SOURCE.DistinctUserCount_201405)                                 AS 'DistinctUserCount_201405'
   ,SUM(SOURCE.DistinctUserCount_201406)                                 AS 'DistinctUserCount_201406'
   ,SUM(SOURCE.DistinctUserCount_201407)                                 AS 'DistinctUserCount_201407'
   ,SUM(SOURCE.DistinctUserCount_201408)                                 AS 'DistinctUserCount_201408'
   ,SUM(SOURCE.DistinctUserCount_201409)                                 AS 'DistinctUserCount_201409'
   ,SUM(SOURCE.DistinctUserCount_201410)                                 AS 'DistinctUserCount_201410'
   ,SUM(SOURCE.DistinctUserCount_201411)                                 AS 'DistinctUserCount_201411'
   ,SUM(SOURCE.DistinctUserCount_201412)                                 AS 'DistinctUserCount_201412'
   ,SUM(SOURCE.DistinctUserCount_201501)                                 AS 'DistinctUserCount_201501'
   ,SUM(SOURCE.DistinctUserCount_201502)                                 AS 'DistinctUserCount_201502'
   ,SUM(SOURCE.DistinctUserCount_201503)                                 AS 'DistinctUserCount_201503'
   ,SUM(SOURCE.DistinctUserCount_201504)                                 AS 'DistinctUserCount_201504'
   ,SUM(SOURCE.DistinctUserCount_201505)                                 AS 'DistinctUserCount_201505'
   ,SUM(SOURCE.DistinctUserCount_201506)                                 AS 'DistinctUserCount_201506'
   ,SUM(SOURCE.ResidentsMsgCnt_201206)                                   AS 'ResidentsMsgCnt_201206'
   ,SUM(SOURCE.ResidentsMsgCnt_201207)                                   AS 'ResidentsMsgCnt_201207'
   ,SUM(SOURCE.ResidentsMsgCnt_201208)                                   AS 'ResidentsMsgCnt_201208'
   ,SUM(SOURCE.ResidentsMsgCnt_201209)                                   AS 'ResidentsMsgCnt_201209'
   ,SUM(SOURCE.ResidentsMsgCnt_201210)                                   AS 'ResidentsMsgCnt_201210'
   ,SUM(SOURCE.ResidentsMsgCnt_201211)                                   AS 'ResidentsMsgCnt_201211'
   ,SUM(SOURCE.ResidentsMsgCnt_201212)                                   AS 'ResidentsMsgCnt_201212'
   ,SUM(SOURCE.ResidentsMsgCnt_201301)                                   AS 'ResidentsMsgCnt_201301'
   ,SUM(SOURCE.ResidentsMsgCnt_201302)                                   AS 'ResidentsMsgCnt_201302'
   ,SUM(SOURCE.ResidentsMsgCnt_201303)                                   AS 'ResidentsMsgCnt_201303'
   ,SUM(SOURCE.ResidentsMsgCnt_201304)                                   AS 'ResidentsMsgCnt_201304'
   ,SUM(SOURCE.ResidentsMsgCnt_201305)                                   AS 'ResidentsMsgCnt_201305'
   ,SUM(SOURCE.ResidentsMsgCnt_201306)                                   AS 'ResidentsMsgCnt_201306'
   ,SUM(SOURCE.ResidentsMsgCnt_201307)                                   AS 'ResidentsMsgCnt_201307'
   ,SUM(SOURCE.ResidentsMsgCnt_201308)                                   AS 'ResidentsMsgCnt_201308'
   ,SUM(SOURCE.ResidentsMsgCnt_201309)                                   AS 'ResidentsMsgCnt_201309'
   ,SUM(SOURCE.ResidentsMsgCnt_201310)                                   AS 'ResidentsMsgCnt_201310'
   ,SUM(SOURCE.ResidentsMsgCnt_201311)                                   AS 'ResidentsMsgCnt_201311'
   ,SUM(SOURCE.ResidentsMsgCnt_201312)                                   AS 'ResidentsMsgCnt_201312'
   ,SUM(SOURCE.ResidentsMsgCnt_201401)                                   AS 'ResidentsMsgCnt_201401'
   ,SUM(SOURCE.ResidentsMsgCnt_201402)                                   AS 'ResidentsMsgCnt_201402'
   ,SUM(SOURCE.ResidentsMsgCnt_201403)                                   AS 'ResidentsMsgCnt_201403'
   ,SUM(SOURCE.ResidentsMsgCnt_201404)                                   AS 'ResidentsMsgCnt_201404'
   ,SUM(SOURCE.ResidentsMsgCnt_201405)                                   AS 'ResidentsMsgCnt_201405'
   ,SUM(SOURCE.ResidentsMsgCnt_201406)                                   AS 'ResidentsMsgCnt_201406'
   ,SUM(SOURCE.ResidentsMsgCnt_201407)                                   AS 'ResidentsMsgCnt_201407'
   ,SUM(SOURCE.ResidentsMsgCnt_201408)                                   AS 'ResidentsMsgCnt_201408'
   ,SUM(SOURCE.ResidentsMsgCnt_201409)                                   AS 'ResidentsMsgCnt_201409'
   ,SUM(SOURCE.ResidentsMsgCnt_201410)                                   AS 'ResidentsMsgCnt_201410'
   ,SUM(SOURCE.ResidentsMsgCnt_201411)                                   AS 'ResidentsMsgCnt_201411'
   ,SUM(SOURCE.ResidentsMsgCnt_201412)                                   AS 'ResidentsMsgCnt_201412'
   ,SUM(SOURCE.ResidentsMsgCnt_201501)                                   AS 'ResidentsMsgCnt_201501'
   ,SUM(SOURCE.ResidentsMsgCnt_201502)                                   AS 'ResidentsMsgCnt_201502'
   ,SUM(SOURCE.ResidentsMsgCnt_201503)                                   AS 'ResidentsMsgCnt_201503'
   ,SUM(SOURCE.ResidentsMsgCnt_201504)                                   AS 'ResidentsMsgCnt_201504'
   ,SUM(SOURCE.ResidentsMsgCnt_201505)                                   AS 'ResidentsMsgCnt_201505'
   ,SUM(SOURCE.ResidentsMsgCnt_201506)                                   AS 'ResidentsMsgCnt_201506'
   ,SUM(SOURCE.ResDistinctUsrCnt_201206)                                 AS 'ResDistinctUsrCnt_201206'
   ,SUM(SOURCE.ResDistinctUsrCnt_201207)                                 AS 'ResDistinctUsrCnt_201207'
   ,SUM(SOURCE.ResDistinctUsrCnt_201208)                                 AS 'ResDistinctUsrCnt_201208'
   ,SUM(SOURCE.ResDistinctUsrCnt_201209)                                 AS 'ResDistinctUsrCnt_201209'
   ,SUM(SOURCE.ResDistinctUsrCnt_201210)                                 AS 'ResDistinctUsrCnt_201210'
   ,SUM(SOURCE.ResDistinctUsrCnt_201211)                                 AS 'ResDistinctUsrCnt_201211'
   ,SUM(SOURCE.ResDistinctUsrCnt_201212)                                 AS 'ResDistinctUsrCnt_201212'
   ,SUM(SOURCE.ResDistinctUsrCnt_201301)                                 AS 'ResDistinctUsrCnt_201301'
   ,SUM(SOURCE.ResDistinctUsrCnt_201302)                                 AS 'ResDistinctUsrCnt_201302'
   ,SUM(SOURCE.ResDistinctUsrCnt_201303)                                 AS 'ResDistinctUsrCnt_201303'
   ,SUM(SOURCE.ResDistinctUsrCnt_201304)                                 AS 'ResDistinctUsrCnt_201304'
   ,SUM(SOURCE.ResDistinctUsrCnt_201305)                                 AS 'ResDistinctUsrCnt_201305'
   ,SUM(SOURCE.ResDistinctUsrCnt_201306)                                 AS 'ResDistinctUsrCnt_201306'
   ,SUM(SOURCE.ResDistinctUsrCnt_201307)                                 AS 'ResDistinctUsrCnt_201307'
   ,SUM(SOURCE.ResDistinctUsrCnt_201308)                                 AS 'ResDistinctUsrCnt_201308'
   ,SUM(SOURCE.ResDistinctUsrCnt_201309)                                 AS 'ResDistinctUsrCnt_201309'
   ,SUM(SOURCE.ResDistinctUsrCnt_201310)                                 AS 'ResDistinctUsrCnt_201310'
   ,SUM(SOURCE.ResDistinctUsrCnt_201311)                                 AS 'ResDistinctUsrCnt_201311'
   ,SUM(SOURCE.ResDistinctUsrCnt_201312)                                 AS 'ResDistinctUsrCnt_201312'
   ,SUM(SOURCE.ResDistinctUsrCnt_201401)                                 AS 'ResDistinctUsrCnt_201401'
   ,SUM(SOURCE.ResDistinctUsrCnt_201402)                                 AS 'ResDistinctUsrCnt_201402'
   ,SUM(SOURCE.ResDistinctUsrCnt_201403)                                 AS 'ResDistinctUsrCnt_201403'
   ,SUM(SOURCE.ResDistinctUsrCnt_201404)                                 AS 'ResDistinctUsrCnt_201404'
   ,SUM(SOURCE.ResDistinctUsrCnt_201405)                                 AS 'ResDistinctUsrCnt_201405'
   ,SUM(SOURCE.ResDistinctUsrCnt_201406)                                 AS 'ResDistinctUsrCnt_201406'
   ,SUM(SOURCE.ResDistinctUsrCnt_201407)                                 AS 'ResDistinctUsrCnt_201407'
   ,SUM(SOURCE.ResDistinctUsrCnt_201408)                                 AS 'ResDistinctUsrCnt_201408'
   ,SUM(SOURCE.ResDistinctUsrCnt_201409)                                 AS 'ResDistinctUsrCnt_201409'
   ,SUM(SOURCE.ResDistinctUsrCnt_201410)                                 AS 'ResDistinctUsrCnt_201410'
   ,SUM(SOURCE.ResDistinctUsrCnt_201411)                                 AS 'ResDistinctUsrCnt_201411'
   ,SUM(SOURCE.ResDistinctUsrCnt_201412)                                 AS 'ResDistinctUsrCnt_201412'
   ,SUM(SOURCE.ResDistinctUsrCnt_201501)                                 AS 'ResDistinctUsrCnt_201501'
   ,SUM(SOURCE.ResDistinctUsrCnt_201502)                                 AS 'ResDistinctUsrCnt_201502'
   ,SUM(SOURCE.ResDistinctUsrCnt_201503)                                 AS 'ResDistinctUsrCnt_201503'
   ,SUM(SOURCE.ResDistinctUsrCnt_201504)                                 AS 'ResDistinctUsrCnt_201504'
   ,SUM(SOURCE.ResDistinctUsrCnt_201505)                                 AS 'ResDistinctUsrCnt_201505'
   ,SUM(SOURCE.ResDistinctUsrCnt_201506)                                 AS 'ResDistinctUsrCnt_201506'
   ,SUM(SOURCE.TouristsMsgCnt_201206)                                    AS 'TouristsMsgCnt_201206'
   ,SUM(SOURCE.TouristsMsgCnt_201207)                                    AS 'TouristsMsgCnt_201207'
   ,SUM(SOURCE.TouristsMsgCnt_201208)                                    AS 'TouristsMsgCnt_201208'
   ,SUM(SOURCE.TouristsMsgCnt_201209)                                    AS 'TouristsMsgCnt_201209'
   ,SUM(SOURCE.TouristsMsgCnt_201210)                                    AS 'TouristsMsgCnt_201210'
   ,SUM(SOURCE.TouristsMsgCnt_201211)                                    AS 'TouristsMsgCnt_201211'
   ,SUM(SOURCE.TouristsMsgCnt_201212)                                    AS 'TouristsMsgCnt_201212'
   ,SUM(SOURCE.TouristsMsgCnt_201301)                                    AS 'TouristsMsgCnt_201301'
   ,SUM(SOURCE.TouristsMsgCnt_201302)                                    AS 'TouristsMsgCnt_201302'
   ,SUM(SOURCE.TouristsMsgCnt_201303)                                    AS 'TouristsMsgCnt_201303'
   ,SUM(SOURCE.TouristsMsgCnt_201304)                                    AS 'TouristsMsgCnt_201304'
   ,SUM(SOURCE.TouristsMsgCnt_201305)                                    AS 'TouristsMsgCnt_201305'
   ,SUM(SOURCE.TouristsMsgCnt_201306)                                    AS 'TouristsMsgCnt_201306'
   ,SUM(SOURCE.TouristsMsgCnt_201307)                                    AS 'TouristsMsgCnt_201307'
   ,SUM(SOURCE.TouristsMsgCnt_201308)                                    AS 'TouristsMsgCnt_201308'
   ,SUM(SOURCE.TouristsMsgCnt_201309)                                    AS 'TouristsMsgCnt_201309'
   ,SUM(SOURCE.TouristsMsgCnt_201310)                                    AS 'TouristsMsgCnt_201310'
   ,SUM(SOURCE.TouristsMsgCnt_201311)                                    AS 'TouristsMsgCnt_201311'
   ,SUM(SOURCE.TouristsMsgCnt_201312)                                    AS 'TouristsMsgCnt_201312'
   ,SUM(SOURCE.TouristsMsgCnt_201401)                                    AS 'TouristsMsgCnt_201401'
   ,SUM(SOURCE.TouristsMsgCnt_201402)                                    AS 'TouristsMsgCnt_201402'
   ,SUM(SOURCE.TouristsMsgCnt_201403)                                    AS 'TouristsMsgCnt_201403'
   ,SUM(SOURCE.TouristsMsgCnt_201404)                                    AS 'TouristsMsgCnt_201404'
   ,SUM(SOURCE.TouristsMsgCnt_201405)                                    AS 'TouristsMsgCnt_201405'
   ,SUM(SOURCE.TouristsMsgCnt_201406)                                    AS 'TouristsMsgCnt_201406'
   ,SUM(SOURCE.TouristsMsgCnt_201407)                                    AS 'TouristsMsgCnt_201407'
   ,SUM(SOURCE.TouristsMsgCnt_201408)                                    AS 'TouristsMsgCnt_201408'
   ,SUM(SOURCE.TouristsMsgCnt_201409)                                    AS 'TouristsMsgCnt_201409'
   ,SUM(SOURCE.TouristsMsgCnt_201410)                                    AS 'TouristsMsgCnt_201410'
   ,SUM(SOURCE.TouristsMsgCnt_201411)                                    AS 'TouristsMsgCnt_201411'
   ,SUM(SOURCE.TouristsMsgCnt_201412)                                    AS 'TouristsMsgCnt_201412'
   ,SUM(SOURCE.TouristsMsgCnt_201501)                                    AS 'TouristsMsgCnt_201501'
   ,SUM(SOURCE.TouristsMsgCnt_201502)                                    AS 'TouristsMsgCnt_201502'
   ,SUM(SOURCE.TouristsMsgCnt_201503)                                    AS 'TouristsMsgCnt_201503'
   ,SUM(SOURCE.TouristsMsgCnt_201504)                                    AS 'TouristsMsgCnt_201504'
   ,SUM(SOURCE.TouristsMsgCnt_201505)                                    AS 'TouristsMsgCnt_201505'
   ,SUM(SOURCE.TouristsMsgCnt_201506)                                    AS 'TouristsMsgCnt_201506'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201206)                            AS 'TouristsDistinctUsrCnt_201206'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201207)                            AS 'TouristsDistinctUsrCnt_201207'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201208)                            AS 'TouristsDistinctUsrCnt_201208'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201209)                            AS 'TouristsDistinctUsrCnt_201209'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201210)                            AS 'TouristsDistinctUsrCnt_201210'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201211)                            AS 'TouristsDistinctUsrCnt_201211'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201212)                            AS 'TouristsDistinctUsrCnt_201212'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201301)                            AS 'TouristsDistinctUsrCnt_201301'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201302)                            AS 'TouristsDistinctUsrCnt_201302'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201303)                            AS 'TouristsDistinctUsrCnt_201303'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201304)                            AS 'TouristsDistinctUsrCnt_201304'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201305)                            AS 'TouristsDistinctUsrCnt_201305'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201306)                            AS 'TouristsDistinctUsrCnt_201306'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201307)                            AS 'TouristsDistinctUsrCnt_201307'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201308)                            AS 'TouristsDistinctUsrCnt_201308'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201309)                            AS 'TouristsDistinctUsrCnt_201309'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201310)                            AS 'TouristsDistinctUsrCnt_201310'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201311)                            AS 'TouristsDistinctUsrCnt_201311'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201312)                            AS 'TouristsDistinctUsrCnt_201312'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201401)                            AS 'TouristsDistinctUsrCnt_201401'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201402)                            AS 'TouristsDistinctUsrCnt_201402'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201403)                            AS 'TouristsDistinctUsrCnt_201403'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201404)                            AS 'TouristsDistinctUsrCnt_201404'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201405)                            AS 'TouristsDistinctUsrCnt_201405'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201406)                            AS 'TouristsDistinctUsrCnt_201406'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201407)                            AS 'TouristsDistinctUsrCnt_201407'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201408)                            AS 'TouristsDistinctUsrCnt_201408'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201409)                            AS 'TouristsDistinctUsrCnt_201409'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201410)                            AS 'TouristsDistinctUsrCnt_201410'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201411)                            AS 'TouristsDistinctUsrCnt_201411'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201412)                            AS 'TouristsDistinctUsrCnt_201412'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201501)                            AS 'TouristsDistinctUsrCnt_201501'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201502)                            AS 'TouristsDistinctUsrCnt_201502'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201503)                            AS 'TouristsDistinctUsrCnt_201503'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201504)                            AS 'TouristsDistinctUsrCnt_201504'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201505)                            AS 'TouristsDistinctUsrCnt_201505'
   ,SUM(SOURCE.TouristsDistinctUsrCnt_201506)                            AS 'TouristsDistinctUsrCnt_201506'
   ,SUM(SOURCE.ResTtlMsgCntperH_00)                                      AS 'ResTtlMsgCntperH_00'
   ,SUM(SOURCE.ResTtlMsgCntperH_01)                                      AS 'ResTtlMsgCntperH_01'
   ,SUM(SOURCE.ResTtlMsgCntperH_02)                                      AS 'ResTtlMsgCntperH_02'
   ,SUM(SOURCE.ResTtlMsgCntperH_03)                                      AS 'ResTtlMsgCntperH_03'
   ,SUM(SOURCE.ResTtlMsgCntperH_04)                                      AS 'ResTtlMsgCntperH_04'
   ,SUM(SOURCE.ResTtlMsgCntperH_05)                                      AS 'ResTtlMsgCntperH_05'
   ,SUM(SOURCE.ResTtlMsgCntperH_06)                                      AS 'ResTtlMsgCntperH_06'
   ,SUM(SOURCE.ResTtlMsgCntperH_07)                                      AS 'ResTtlMsgCntperH_07'
   ,SUM(SOURCE.ResTtlMsgCntperH_08)                                      AS 'ResTtlMsgCntperH_08'
   ,SUM(SOURCE.ResTtlMsgCntperH_09)                                      AS 'ResTtlMsgCntperH_09'
   ,SUM(SOURCE.ResTtlMsgCntperH_10)                                      AS 'ResTtlMsgCntperH_10'
   ,SUM(SOURCE.ResTtlMsgCntperH_11)                                      AS 'ResTtlMsgCntperH_11'
   ,SUM(SOURCE.ResTtlMsgCntperH_12)                                      AS 'ResTtlMsgCntperH_12'
   ,SUM(SOURCE.ResTtlMsgCntperH_13)                                      AS 'ResTtlMsgCntperH_13'
   ,SUM(SOURCE.ResTtlMsgCntperH_14)                                      AS 'ResTtlMsgCntperH_14'
   ,SUM(SOURCE.ResTtlMsgCntperH_15)                                      AS 'ResTtlMsgCntperH_15'
   ,SUM(SOURCE.ResTtlMsgCntperH_16)                                      AS 'ResTtlMsgCntperH_16'
   ,SUM(SOURCE.ResTtlMsgCntperH_17)                                      AS 'ResTtlMsgCntperH_17'
   ,SUM(SOURCE.ResTtlMsgCntperH_18)                                      AS 'ResTtlMsgCntperH_18'
   ,SUM(SOURCE.ResTtlMsgCntperH_19)                                      AS 'ResTtlMsgCntperH_19'
   ,SUM(SOURCE.ResTtlMsgCntperH_20)                                      AS 'ResTtlMsgCntperH_20'
   ,SUM(SOURCE.ResTtlMsgCntperH_21)                                      AS 'ResTtlMsgCntperH_21'
   ,SUM(SOURCE.ResTtlMsgCntperH_22)                                      AS 'ResTtlMsgCntperH_22'
   ,SUM(SOURCE.ResTtlMsgCntperH_23)                                      AS 'ResTtlMsgCntperH_23'
   ,SUM(SOURCE.TouTtlMsgCntperH_00)                                      AS 'TouTtlMsgCntperH_00'
   ,SUM(SOURCE.TouTtlMsgCntperH_01)                                      AS 'TouTtlMsgCntperH_01'
   ,SUM(SOURCE.TouTtlMsgCntperH_02)                                      AS 'TouTtlMsgCntperH_02'
   ,SUM(SOURCE.TouTtlMsgCntperH_03)                                      AS 'TouTtlMsgCntperH_03'
   ,SUM(SOURCE.TouTtlMsgCntperH_04)                                      AS 'TouTtlMsgCntperH_04'
   ,SUM(SOURCE.TouTtlMsgCntperH_05)                                      AS 'TouTtlMsgCntperH_05'
   ,SUM(SOURCE.TouTtlMsgCntperH_06)                                      AS 'TouTtlMsgCntperH_06'
   ,SUM(SOURCE.TouTtlMsgCntperH_07)                                      AS 'TouTtlMsgCntperH_07'
   ,SUM(SOURCE.TouTtlMsgCntperH_08)                                      AS 'TouTtlMsgCntperH_08'
   ,SUM(SOURCE.TouTtlMsgCntperH_09)                                      AS 'TouTtlMsgCntperH_09'
   ,SUM(SOURCE.TouTtlMsgCntperH_10)                                      AS 'TouTtlMsgCntperH_10'
   ,SUM(SOURCE.TouTtlMsgCntperH_11)                                      AS 'TouTtlMsgCntperH_11'
   ,SUM(SOURCE.TouTtlMsgCntperH_12)                                      AS 'TouTtlMsgCntperH_12'
   ,SUM(SOURCE.TouTtlMsgCntperH_13)                                      AS 'TouTtlMsgCntperH_13'
   ,SUM(SOURCE.TouTtlMsgCntperH_14)                                      AS 'TouTtlMsgCntperH_14'
   ,SUM(SOURCE.TouTtlMsgCntperH_15)                                      AS 'TouTtlMsgCntperH_15'
   ,SUM(SOURCE.TouTtlMsgCntperH_16)                                      AS 'TouTtlMsgCntperH_16'
   ,SUM(SOURCE.TouTtlMsgCntperH_17)                                      AS 'TouTtlMsgCntperH_17'
   ,SUM(SOURCE.TouTtlMsgCntperH_18)                                      AS 'TouTtlMsgCntperH_18'
   ,SUM(SOURCE.TouTtlMsgCntperH_19)                                      AS 'TouTtlMsgCntperH_19'
   ,SUM(SOURCE.TouTtlMsgCntperH_20)                                      AS 'TouTtlMsgCntperH_20'
   ,SUM(SOURCE.TouTtlMsgCntperH_21)                                      AS 'TouTtlMsgCntperH_21'
   ,SUM(SOURCE.TouTtlMsgCntperH_22)                                      AS 'TouTtlMsgCntperH_22'
   ,SUM(SOURCE.TouTtlMsgCntperH_23)                                      AS 'TouTtlMsgCntperH_23'
   ,SUM(SOURCE.TotalMsgCntperH_00)                                       AS 'TotalMsgCntperH_00'
   ,SUM(SOURCE.TotalMsgCntperH_01)                                       AS 'TotalMsgCntperH_01'
   ,SUM(SOURCE.TotalMsgCntperH_02)                                       AS 'TotalMsgCntperH_02'
   ,SUM(SOURCE.TotalMsgCntperH_03)                                       AS 'TotalMsgCntperH_03'
   ,SUM(SOURCE.TotalMsgCntperH_04)                                       AS 'TotalMsgCntperH_04'
   ,SUM(SOURCE.TotalMsgCntperH_05)                                       AS 'TotalMsgCntperH_05'
   ,SUM(SOURCE.TotalMsgCntperH_06)                                       AS 'TotalMsgCntperH_06'
   ,SUM(SOURCE.TotalMsgCntperH_07)                                       AS 'TotalMsgCntperH_07'
   ,SUM(SOURCE.TotalMsgCntperH_08)                                       AS 'TotalMsgCntperH_08'
   ,SUM(SOURCE.TotalMsgCntperH_09)                                       AS 'TotalMsgCntperH_09'
   ,SUM(SOURCE.TotalMsgCntperH_10)                                       AS 'TotalMsgCntperH_10'
   ,SUM(SOURCE.TotalMsgCntperH_11)                                       AS 'TotalMsgCntperH_11'
   ,SUM(SOURCE.TotalMsgCntperH_12)                                       AS 'TotalMsgCntperH_12'
   ,SUM(SOURCE.TotalMsgCntperH_13)                                       AS 'TotalMsgCntperH_13'
   ,SUM(SOURCE.TotalMsgCntperH_14)                                       AS 'TotalMsgCntperH_14'
   ,SUM(SOURCE.TotalMsgCntperH_15)                                       AS 'TotalMsgCntperH_15'
   ,SUM(SOURCE.TotalMsgCntperH_16)                                       AS 'TotalMsgCntperH_16'
   ,SUM(SOURCE.TotalMsgCntperH_17)                                       AS 'TotalMsgCntperH_17'
   ,SUM(SOURCE.TotalMsgCntperH_18)                                       AS 'TotalMsgCntperH_18'
   ,SUM(SOURCE.TotalMsgCntperH_19)                                       AS 'TotalMsgCntperH_19'
   ,SUM(SOURCE.TotalMsgCntperH_20)                                       AS 'TotalMsgCntperH_20'
   ,SUM(SOURCE.TotalMsgCntperH_21)                                       AS 'TotalMsgCntperH_21'
   ,SUM(SOURCE.TotalMsgCntperH_22)                                       AS 'TotalMsgCntperH_22'
   ,SUM(SOURCE.TotalMsgCntperH_23)                                       AS 'TotalMsgCntperH_23'
   ,SUM(SOURCE.SBC1_PointCount)                                          AS 'SBC1_PointCount'
   ,SUM(SOURCE.SBC2_PointCount)                                          AS 'SBC2_PointCount'
   ,SUM(SOURCE.SBC1_PointCount)/SUM(SOURCE.AREASQM)                      AS 'SBC1_PointDensity'
   ,SUM(SOURCE.SBC2_PointCount)/SUM(SOURCE.AREASQM)                      AS 'SBC2_PointDensity'
   ,AVG(SOURCE.AvgCoh_20090328_20090408_1)                               AS 'AvgCoh_20090328_20090408_1'
   ,AVG(SOURCE.AvgCoh_20090328_20090419_2)                               AS 'AvgCoh_20090328_20090419_2'
   ,AVG(SOURCE.AvgCoh_20090328_20090511_3)                               AS 'AvgCoh_20090328_20090511_3'
   ,AVG(SOURCE.AvgCoh_20090328_20090522_4)                               AS 'AvgCoh_20090328_20090522_4'
   ,AVG(SOURCE.AvgCoh_20090328_20090602_5)                               AS 'AvgCoh_20090328_20090602_5'
   ,AVG(SOURCE.AvgCoh_20090328_20090624_6)                               AS 'AvgCoh_20090328_20090624_6'
   ,AVG(SOURCE.AvgCoh_20090408_20090419_7)                               AS 'AvgCoh_20090408_20090419_7'
   ,AVG(SOURCE.AvgCoh_20090408_20090511_8)                               AS 'AvgCoh_20090408_20090511_8'
   ,AVG(SOURCE.AvgCoh_20090408_20090522_9)                               AS 'AvgCoh_20090408_20090522_9'
   ,AVG(SOURCE.AvgCoh_20090408_20090602_10)                              AS 'AvgCoh_20090408_20090602_10'
   ,AVG(SOURCE.AvgCoh_20090419_20090511_11)                              AS 'AvgCoh_20090419_20090511_11'
   ,AVG(SOURCE.AvgCoh_20090419_20090522_12)                              AS 'AvgCoh_20090419_20090522_12'
   ,AVG(SOURCE.AvgCoh_20090419_20090602_13)                              AS 'AvgCoh_20090419_20090602_13'
   ,AVG(SOURCE.AvgCoh_20090419_20090624_14)                              AS 'AvgCoh_20090419_20090624_14'
   ,AVG(SOURCE.AvgCoh_20090511_20090522_15)                              AS 'AvgCoh_20090511_20090522_15'
   ,AVG(SOURCE.AvgCoh_20090511_20090602_16)                              AS 'AvgCoh_20090511_20090602_16'
   ,AVG(SOURCE.AvgCoh_20090511_20090624_17)                              AS 'AvgCoh_20090511_20090624_17'
   ,AVG(SOURCE.AvgCoh_20090522_20090602_18)                              AS 'AvgCoh_20090522_20090602_18'
   ,AVG(SOURCE.AvgCoh_20090522_20090624_19)                              AS 'AvgCoh_20090522_20090624_19'
   ,AVG(SOURCE.AvgCoh_20090624_20090829_20)                              AS 'AvgCoh_20090624_20090829_20'
   ,AVG(SOURCE.AvgCoh_20090624_20090920_21)                              AS 'AvgCoh_20090624_20090920_21'
   ,AVG(SOURCE.AvgCoh_20090829_20091012_22)                              AS 'AvgCoh_20090829_20091012_22'
   ,AVG(SOURCE.AvgCoh_20090829_20091023_23)                              AS 'AvgCoh_20090829_20091023_23'
   ,AVG(SOURCE.AvgCoh_20090920_20091012_24)                              AS 'AvgCoh_20090920_20091012_24'
   ,AVG(SOURCE.AvgCoh_20090920_20091023_25)                              AS 'AvgCoh_20090920_20091023_25'
   ,AVG(SOURCE.AvgCoh_20090920_20091114_26)                              AS 'AvgCoh_20090920_20091114_26'
   ,AVG(SOURCE.AvgCoh_20090920_20091206_27)                              AS 'AvgCoh_20090920_20091206_27'
   ,AVG(SOURCE.AvgCoh_20090920_20091217_28)                              AS 'AvgCoh_20090920_20091217_28'
   ,AVG(SOURCE.AvgCoh_20091012_20091023_29)                              AS 'AvgCoh_20091012_20091023_29'
   ,AVG(SOURCE.AvgCoh_20091012_20091114_30)                              AS 'AvgCoh_20091012_20091114_30'
   ,AVG(SOURCE.AvgCoh_20091012_20100108_31)                              AS 'AvgCoh_20091012_20100108_31'
   ,AVG(SOURCE.AvgCoh_20091023_20091114_32)                              AS 'AvgCoh_20091023_20091114_32'
   ,AVG(SOURCE.AvgCoh_20091023_20100108_33)                              AS 'AvgCoh_20091023_20100108_33'
   ,AVG(SOURCE.AvgCoh_20091023_20100119_34)                              AS 'AvgCoh_20091023_20100119_34'
   ,AVG(SOURCE.AvgCoh_20091114_20091206_35)                              AS 'AvgCoh_20091114_20091206_35'
   ,AVG(SOURCE.AvgCoh_20091114_20091217_36)                              AS 'AvgCoh_20091114_20091217_36'
   ,AVG(SOURCE.AvgCoh_20091114_20100108_37)                              AS 'AvgCoh_20091114_20100108_37'
   ,AVG(SOURCE.AvgCoh_20091114_20100119_38)                              AS 'AvgCoh_20091114_20100119_38'
   ,AVG(SOURCE.AvgCoh_20091114_20100130_39)                              AS 'AvgCoh_20091114_20100130_39'
   ,AVG(SOURCE.AvgCoh_20091206_20091217_40)                              AS 'AvgCoh_20091206_20091217_40'
   ,AVG(SOURCE.AvgCoh_20091206_20100108_41)                              AS 'AvgCoh_20091206_20100108_41'
   ,AVG(SOURCE.AvgCoh_20091206_20100119_42)                              AS 'AvgCoh_20091206_20100119_42'
   ,AVG(SOURCE.AvgCoh_20091217_20100108_43)                              AS 'AvgCoh_20091217_20100108_43'
   ,AVG(SOURCE.AvgCoh_20091217_20100119_44)                              AS 'AvgCoh_20091217_20100119_44'
   ,AVG(SOURCE.AvgCoh_20091228_20091206_45)                              AS 'AvgCoh_20091228_20091206_45'
   ,AVG(SOURCE.AvgCoh_20091228_20091217_46)                              AS 'AvgCoh_20091228_20091217_46'
   ,AVG(SOURCE.AvgCoh_20100108_20100119_47)                              AS 'AvgCoh_20100108_20100119_47'
   ,AVG(SOURCE.AvgCoh_20100108_20100130_48)                              AS 'AvgCoh_20100108_20100130_48'
   ,AVG(SOURCE.AvgCoh_20100119_20100130_49)                              AS 'AvgCoh_20100119_20100130_49'
   ,AVG(SOURCE.AvgCoh_20110916_20111008_50)                              AS 'AvgCoh_20110916_20111008_50'
   ,AVG(SOURCE.AvgCoh_20110916_20111213_51)                              AS 'AvgCoh_20110916_20111213_51'
   ,AVG(SOURCE.AvgCoh_20111008_20111213_52)                              AS 'AvgCoh_20111008_20111213_52'
   ,AVG(SOURCE.AvgCoh_20111008_20120104_53)                              AS 'AvgCoh_20111008_20120104_53'
   ,AVG(SOURCE.AvgCoh_20111121_20120104_54)                              AS 'AvgCoh_20111121_20120104_54'
   ,AVG(SOURCE.AvgCoh_20111121_20120206_55)                              AS 'AvgCoh_20111121_20120206_55'
   ,AVG(SOURCE.AvgCoh_20111213_20120310_56)                              AS 'AvgCoh_20111213_20120310_56'
   ,AVG(SOURCE.AvgCoh_20120104_20120206_57)                              AS 'AvgCoh_20120104_20120206_57'
   ,AVG(SOURCE.AvgCoh_20120104_20120310_58)                              AS 'AvgCoh_20120104_20120310_58'
   ,AVG(SOURCE.AvgCoh_20120104_20120401_59)                              AS 'AvgCoh_20120104_20120401_59'
   ,AVG(SOURCE.AvgCoh_20120206_20120310_60)                              AS 'AvgCoh_20120206_20120310_60'
   ,AVG(SOURCE.AvgCoh_20120206_20120401_61)                              AS 'AvgCoh_20120206_20120401_61'
   ,AVG(SOURCE.AvgCoh_20120310_20120401_62)                              AS 'AvgCoh_20120310_20120401_62'
   ,AVG(SOURCE.AvgCoh_20120310_20120515_63)                              AS 'AvgCoh_20120310_20120515_63'
   ,AVG(SOURCE.AvgCoh_20120401_20120515_64)                              AS 'AvgCoh_20120401_20120515_64'
   ,AVG(SOURCE.AvgCoh_20120401_20120628_65)                              AS 'AvgCoh_20120401_20120628_65'
   ,AVG(SOURCE.AvgCoh_20120515_20120628_66)                              AS 'AvgCoh_20120515_20120628_66'
   ,AVG(SOURCE.AvgCoh_20120515_20120811_67)                              AS 'AvgCoh_20120515_20120811_67'
   ,AVG(SOURCE.AvgCoh_20120628_20120811_68)                              AS 'AvgCoh_20120628_20120811_68'
   ,AVG(SOURCE.AvgCoh_20120628_20120902_69)                              AS 'AvgCoh_20120628_20120902_69'
   ,AVG(SOURCE.AvgCoh_20120720_20121005_70)                              AS 'AvgCoh_20120720_20121005_70'
   ,AVG(SOURCE.AvgCoh_20120811_20120902_71)                              AS 'AvgCoh_20120811_20120902_71'
   ,MAX(SOURCE.MaxCoh_20090328_20090408_1)                               AS 'MaxCoh_20090328_20090408_1'
   ,MAX(SOURCE.MaxCoh_20090328_20090419_2)                               AS 'MaxCoh_20090328_20090419_2'
   ,MAX(SOURCE.MaxCoh_20090328_20090511_3)                               AS 'MaxCoh_20090328_20090511_3'
   ,MAX(SOURCE.MaxCoh_20090328_20090522_4)                               AS 'MaxCoh_20090328_20090522_4'
   ,MAX(SOURCE.MaxCoh_20090328_20090602_5)                               AS 'MaxCoh_20090328_20090602_5'
   ,MAX(SOURCE.MaxCoh_20090328_20090624_6)                               AS 'MaxCoh_20090328_20090624_6'
   ,MAX(SOURCE.MaxCoh_20090408_20090419_7)                               AS 'MaxCoh_20090408_20090419_7'
   ,MAX(SOURCE.MaxCoh_20090408_20090511_8)                               AS 'MaxCoh_20090408_20090511_8'
   ,MAX(SOURCE.MaxCoh_20090408_20090522_9)                               AS 'MaxCoh_20090408_20090522_9'
   ,MAX(SOURCE.MaxCoh_20090408_20090602_10)                              AS 'MaxCoh_20090408_20090602_10'
   ,MAX(SOURCE.MaxCoh_20090419_20090511_11)                              AS 'MaxCoh_20090419_20090511_11'
   ,MAX(SOURCE.MaxCoh_20090419_20090522_12)                              AS 'MaxCoh_20090419_20090522_12'
   ,MAX(SOURCE.MaxCoh_20090419_20090602_13)                              AS 'MaxCoh_20090419_20090602_13'
   ,MAX(SOURCE.MaxCoh_20090419_20090624_14)                              AS 'MaxCoh_20090419_20090624_14'
   ,MAX(SOURCE.MaxCoh_20090511_20090522_15)                              AS 'MaxCoh_20090511_20090522_15'
   ,MAX(SOURCE.MaxCoh_20090511_20090602_16)                              AS 'MaxCoh_20090511_20090602_16'
   ,MAX(SOURCE.MaxCoh_20090511_20090624_17)                              AS 'MaxCoh_20090511_20090624_17'
   ,MAX(SOURCE.MaxCoh_20090522_20090602_18)                              AS 'MaxCoh_20090522_20090602_18'
   ,MAX(SOURCE.MaxCoh_20090522_20090624_19)                              AS 'MaxCoh_20090522_20090624_19'
   ,MAX(SOURCE.MaxCoh_20090624_20090829_20)                              AS 'MaxCoh_20090624_20090829_20'
   ,MAX(SOURCE.MaxCoh_20090624_20090920_21)                              AS 'MaxCoh_20090624_20090920_21'
   ,MAX(SOURCE.MaxCoh_20090829_20091012_22)                              AS 'MaxCoh_20090829_20091012_22'
   ,MAX(SOURCE.MaxCoh_20090829_20091023_23)                              AS 'MaxCoh_20090829_20091023_23'
   ,MAX(SOURCE.MaxCoh_20090920_20091012_24)                              AS 'MaxCoh_20090920_20091012_24'
   ,MAX(SOURCE.MaxCoh_20090920_20091023_25)                              AS 'MaxCoh_20090920_20091023_25'
   ,MAX(SOURCE.MaxCoh_20090920_20091114_26)                              AS 'MaxCoh_20090920_20091114_26'
   ,MAX(SOURCE.MaxCoh_20090920_20091206_27)                              AS 'MaxCoh_20090920_20091206_27'
   ,MAX(SOURCE.MaxCoh_20090920_20091217_28)                              AS 'MaxCoh_20090920_20091217_28'
   ,MAX(SOURCE.MaxCoh_20091012_20091023_29)                              AS 'MaxCoh_20091012_20091023_29'
   ,MAX(SOURCE.MaxCoh_20091012_20091114_30)                              AS 'MaxCoh_20091012_20091114_30'
   ,MAX(SOURCE.MaxCoh_20091012_20100108_31)                              AS 'MaxCoh_20091012_20100108_31'
   ,MAX(SOURCE.MaxCoh_20091023_20091114_32)                              AS 'MaxCoh_20091023_20091114_32'
   ,MAX(SOURCE.MaxCoh_20091023_20100108_33)                              AS 'MaxCoh_20091023_20100108_33'
   ,MAX(SOURCE.MaxCoh_20091023_20100119_34)                              AS 'MaxCoh_20091023_20100119_34'
   ,MAX(SOURCE.MaxCoh_20091114_20091206_35)                              AS 'MaxCoh_20091114_20091206_35'
   ,MAX(SOURCE.MaxCoh_20091114_20091217_36)                              AS 'MaxCoh_20091114_20091217_36'
   ,MAX(SOURCE.MaxCoh_20091114_20100108_37)                              AS 'MaxCoh_20091114_20100108_37'
   ,MAX(SOURCE.MaxCoh_20091114_20100119_38)                              AS 'MaxCoh_20091114_20100119_38'
   ,MAX(SOURCE.MaxCoh_20091114_20100130_39)                              AS 'MaxCoh_20091114_20100130_39'
   ,MAX(SOURCE.MaxCoh_20091206_20091217_40)                              AS 'MaxCoh_20091206_20091217_40'
   ,MAX(SOURCE.MaxCoh_20091206_20100108_41)                              AS 'MaxCoh_20091206_20100108_41'
   ,MAX(SOURCE.MaxCoh_20091206_20100119_42)                              AS 'MaxCoh_20091206_20100119_42'
   ,MAX(SOURCE.MaxCoh_20091217_20100108_43)                              AS 'MaxCoh_20091217_20100108_43'
   ,MAX(SOURCE.MaxCoh_20091217_20100119_44)                              AS 'MaxCoh_20091217_20100119_44'
   ,MAX(SOURCE.MaxCoh_20091228_20091206_45)                              AS 'MaxCoh_20091228_20091206_45'
   ,MAX(SOURCE.MaxCoh_20091228_20091217_46)                              AS 'MaxCoh_20091228_20091217_46'
   ,MAX(SOURCE.MaxCoh_20100108_20100119_47)                              AS 'MaxCoh_20100108_20100119_47'
   ,MAX(SOURCE.MaxCoh_20100108_20100130_48)                              AS 'MaxCoh_20100108_20100130_48'
   ,MAX(SOURCE.MaxCoh_20100119_20100130_49)                              AS 'MaxCoh_20100119_20100130_49'
   ,MAX(SOURCE.MaxCoh_20110916_20111008_50)                              AS 'MaxCoh_20110916_20111008_50'
   ,MAX(SOURCE.MaxCoh_20110916_20111213_51)                              AS 'MaxCoh_20110916_20111213_51'
   ,MAX(SOURCE.MaxCoh_20111008_20111213_52)                              AS 'MaxCoh_20111008_20111213_52'
   ,MAX(SOURCE.MaxCoh_20111008_20120104_53)                              AS 'MaxCoh_20111008_20120104_53'
   ,MAX(SOURCE.MaxCoh_20111121_20120104_54)                              AS 'MaxCoh_20111121_20120104_54'
   ,MAX(SOURCE.MaxCoh_20111121_20120206_55)                              AS 'MaxCoh_20111121_20120206_55'
   ,MAX(SOURCE.MaxCoh_20111213_20120310_56)                              AS 'MaxCoh_20111213_20120310_56'
   ,MAX(SOURCE.MaxCoh_20120104_20120206_57)                              AS 'MaxCoh_20120104_20120206_57'
   ,MAX(SOURCE.MaxCoh_20120104_20120310_58)                              AS 'MaxCoh_20120104_20120310_58'
   ,MAX(SOURCE.MaxCoh_20120104_20120401_59)                              AS 'MaxCoh_20120104_20120401_59'
   ,MAX(SOURCE.MaxCoh_20120206_20120310_60)                              AS 'MaxCoh_20120206_20120310_60'
   ,MAX(SOURCE.MaxCoh_20120206_20120401_61)                              AS 'MaxCoh_20120206_20120401_61'
   ,MAX(SOURCE.MaxCoh_20120310_20120401_62)                              AS 'MaxCoh_20120310_20120401_62'
   ,MAX(SOURCE.MaxCoh_20120310_20120515_63)                              AS 'MaxCoh_20120310_20120515_63'
   ,MAX(SOURCE.MaxCoh_20120401_20120515_64)                              AS 'MaxCoh_20120401_20120515_64'
   ,MAX(SOURCE.MaxCoh_20120401_20120628_65)                              AS 'MaxCoh_20120401_20120628_65'
   ,MAX(SOURCE.MaxCoh_20120515_20120628_66)                              AS 'MaxCoh_20120515_20120628_66'
   ,MAX(SOURCE.MaxCoh_20120515_20120811_67)                              AS 'MaxCoh_20120515_20120811_67'
   ,MAX(SOURCE.MaxCoh_20120628_20120811_68)                              AS 'MaxCoh_20120628_20120811_68'
   ,MAX(SOURCE.MaxCoh_20120628_20120902_69)                              AS 'MaxCoh_20120628_20120902_69'
   ,MAX(SOURCE.MaxCoh_20120720_20121005_70)                              AS 'MaxCoh_20120720_20121005_70'
   ,MAX(SOURCE.MaxCoh_20120811_20120902_71)                              AS 'MaxCoh_20120811_20120902_71'
   ,MIN(SOURCE.MinCoh_20090328_20090408_1)                               AS 'MinCoh_20090328_20090408_1'
   ,MIN(SOURCE.MinCoh_20090328_20090419_2)                               AS 'MinCoh_20090328_20090419_2'
   ,MIN(SOURCE.MinCoh_20090328_20090511_3)                               AS 'MinCoh_20090328_20090511_3'
   ,MIN(SOURCE.MinCoh_20090328_20090522_4)                               AS 'MinCoh_20090328_20090522_4'
   ,MIN(SOURCE.MinCoh_20090328_20090602_5)                               AS 'MinCoh_20090328_20090602_5'
   ,MIN(SOURCE.MinCoh_20090328_20090624_6)                               AS 'MinCoh_20090328_20090624_6'
   ,MIN(SOURCE.MinCoh_20090408_20090419_7)                               AS 'MinCoh_20090408_20090419_7'
   ,MIN(SOURCE.MinCoh_20090408_20090511_8)                               AS 'MinCoh_20090408_20090511_8'
   ,MIN(SOURCE.MinCoh_20090408_20090522_9)                               AS 'MinCoh_20090408_20090522_9'
   ,MIN(SOURCE.MinCoh_20090408_20090602_10)                              AS 'MinCoh_20090408_20090602_10'
   ,MIN(SOURCE.MinCoh_20090419_20090511_11)                              AS 'MinCoh_20090419_20090511_11'
   ,MIN(SOURCE.MinCoh_20090419_20090522_12)                              AS 'MinCoh_20090419_20090522_12'
   ,MIN(SOURCE.MinCoh_20090419_20090602_13)                              AS 'MinCoh_20090419_20090602_13'
   ,MIN(SOURCE.MinCoh_20090419_20090624_14)                              AS 'MinCoh_20090419_20090624_14'
   ,MIN(SOURCE.MinCoh_20090511_20090522_15)                              AS 'MinCoh_20090511_20090522_15'
   ,MIN(SOURCE.MinCoh_20090511_20090602_16)                              AS 'MinCoh_20090511_20090602_16'
   ,MIN(SOURCE.MinCoh_20090511_20090624_17)                              AS 'MinCoh_20090511_20090624_17'
   ,MIN(SOURCE.MinCoh_20090522_20090602_18)                              AS 'MinCoh_20090522_20090602_18'
   ,MIN(SOURCE.MinCoh_20090522_20090624_19)                              AS 'MinCoh_20090522_20090624_19'
   ,MIN(SOURCE.MinCoh_20090624_20090829_20)                              AS 'MinCoh_20090624_20090829_20'
   ,MIN(SOURCE.MinCoh_20090624_20090920_21)                              AS 'MinCoh_20090624_20090920_21'
   ,MIN(SOURCE.MinCoh_20090829_20091012_22)                              AS 'MinCoh_20090829_20091012_22'
   ,MIN(SOURCE.MinCoh_20090829_20091023_23)                              AS 'MinCoh_20090829_20091023_23'
   ,MIN(SOURCE.MinCoh_20090920_20091012_24)                              AS 'MinCoh_20090920_20091012_24'
   ,MIN(SOURCE.MinCoh_20090920_20091023_25)                              AS 'MinCoh_20090920_20091023_25'
   ,MIN(SOURCE.MinCoh_20090920_20091114_26)                              AS 'MinCoh_20090920_20091114_26'
   ,MIN(SOURCE.MinCoh_20090920_20091206_27)                              AS 'MinCoh_20090920_20091206_27'
   ,MIN(SOURCE.MinCoh_20090920_20091217_28)                              AS 'MinCoh_20090920_20091217_28'
   ,MIN(SOURCE.MinCoh_20091012_20091023_29)                              AS 'MinCoh_20091012_20091023_29'
   ,MIN(SOURCE.MinCoh_20091012_20091114_30)                              AS 'MinCoh_20091012_20091114_30'
   ,MIN(SOURCE.MinCoh_20091012_20100108_31)                              AS 'MinCoh_20091012_20100108_31'
   ,MIN(SOURCE.MinCoh_20091023_20091114_32)                              AS 'MinCoh_20091023_20091114_32'
   ,MIN(SOURCE.MinCoh_20091023_20100108_33)                              AS 'MinCoh_20091023_20100108_33'
   ,MIN(SOURCE.MinCoh_20091023_20100119_34)                              AS 'MinCoh_20091023_20100119_34'
   ,MIN(SOURCE.MinCoh_20091114_20091206_35)                              AS 'MinCoh_20091114_20091206_35'
   ,MIN(SOURCE.MinCoh_20091114_20091217_36)                              AS 'MinCoh_20091114_20091217_36'
   ,MIN(SOURCE.MinCoh_20091114_20100108_37)                              AS 'MinCoh_20091114_20100108_37'
   ,MIN(SOURCE.MinCoh_20091114_20100119_38)                              AS 'MinCoh_20091114_20100119_38'
   ,MIN(SOURCE.MinCoh_20091114_20100130_39)                              AS 'MinCoh_20091114_20100130_39'
   ,MIN(SOURCE.MinCoh_20091206_20091217_40)                              AS 'MinCoh_20091206_20091217_40'
   ,MIN(SOURCE.MinCoh_20091206_20100108_41)                              AS 'MinCoh_20091206_20100108_41'
   ,MIN(SOURCE.MinCoh_20091206_20100119_42)                              AS 'MinCoh_20091206_20100119_42'
   ,MIN(SOURCE.MinCoh_20091217_20100108_43)                              AS 'MinCoh_20091217_20100108_43'
   ,MIN(SOURCE.MinCoh_20091217_20100119_44)                              AS 'MinCoh_20091217_20100119_44'
   ,MIN(SOURCE.MinCoh_20091228_20091206_45)                              AS 'MinCoh_20091228_20091206_45'
   ,MIN(SOURCE.MinCoh_20091228_20091217_46)                              AS 'MinCoh_20091228_20091217_46'
   ,MIN(SOURCE.MinCoh_20100108_20100119_47)                              AS 'MinCoh_20100108_20100119_47'
   ,MIN(SOURCE.MinCoh_20100108_20100130_48)                              AS 'MinCoh_20100108_20100130_48'
   ,MIN(SOURCE.MinCoh_20100119_20100130_49)                              AS 'MinCoh_20100119_20100130_49'
   ,MIN(SOURCE.MinCoh_20110916_20111008_50)                              AS 'MinCoh_20110916_20111008_50'
   ,MIN(SOURCE.MinCoh_20110916_20111213_51)                              AS 'MinCoh_20110916_20111213_51'
   ,MIN(SOURCE.MinCoh_20111008_20111213_52)                              AS 'MinCoh_20111008_20111213_52'
   ,MIN(SOURCE.MinCoh_20111008_20120104_53)                              AS 'MinCoh_20111008_20120104_53'
   ,MIN(SOURCE.MinCoh_20111121_20120104_54)                              AS 'MinCoh_20111121_20120104_54'
   ,MIN(SOURCE.MinCoh_20111121_20120206_55)                              AS 'MinCoh_20111121_20120206_55'
   ,MIN(SOURCE.MinCoh_20111213_20120310_56)                              AS 'MinCoh_20111213_20120310_56'
   ,MIN(SOURCE.MinCoh_20120104_20120206_57)                              AS 'MinCoh_20120104_20120206_57'
   ,MIN(SOURCE.MinCoh_20120104_20120310_58)                              AS 'MinCoh_20120104_20120310_58'
   ,MIN(SOURCE.MinCoh_20120104_20120401_59)                              AS 'MinCoh_20120104_20120401_59'
   ,MIN(SOURCE.MinCoh_20120206_20120310_60)                              AS 'MinCoh_20120206_20120310_60'
   ,MIN(SOURCE.MinCoh_20120206_20120401_61)                              AS 'MinCoh_20120206_20120401_61'
   ,MIN(SOURCE.MinCoh_20120310_20120401_62)                              AS 'MinCoh_20120310_20120401_62'
   ,MIN(SOURCE.MinCoh_20120310_20120515_63)                              AS 'MinCoh_20120310_20120515_63'
   ,MIN(SOURCE.MinCoh_20120401_20120515_64)                              AS 'MinCoh_20120401_20120515_64'
   ,MIN(SOURCE.MinCoh_20120401_20120628_65)                              AS 'MinCoh_20120401_20120628_65'
   ,MIN(SOURCE.MinCoh_20120515_20120628_66)                              AS 'MinCoh_20120515_20120628_66'
   ,MIN(SOURCE.MinCoh_20120515_20120811_67)                              AS 'MinCoh_20120515_20120811_67'
   ,MIN(SOURCE.MinCoh_20120628_20120811_68)                              AS 'MinCoh_20120628_20120811_68'
   ,MIN(SOURCE.MinCoh_20120628_20120902_69)                              AS 'MinCoh_20120628_20120902_69'
   ,MIN(SOURCE.MinCoh_20120720_20121005_70)                              AS 'MinCoh_20120720_20121005_70'
   ,MIN(SOURCE.MinCoh_20120811_20120902_71)                              AS 'MinCoh_20120811_20120902_71'
   ,STDEV(SOURCE.AvgCoh_20090328_20090408_1)                             AS 'StDevCoh_20090328_20090408_1' 
   ,STDEV(SOURCE.AvgCoh_20090328_20090419_2)                             AS 'StDevCoh_20090328_20090419_2' 
   ,STDEV(SOURCE.AvgCoh_20090328_20090511_3)                             AS 'StDevCoh_20090328_20090511_3' 
   ,STDEV(SOURCE.AvgCoh_20090328_20090522_4)                             AS 'StDevCoh_20090328_20090522_4' 
   ,STDEV(SOURCE.AvgCoh_20090328_20090602_5)                             AS 'StDevCoh_20090328_20090602_5' 
   ,STDEV(SOURCE.AvgCoh_20090328_20090624_6)                             AS 'StDevCoh_20090328_20090624_6' 
   ,STDEV(SOURCE.AvgCoh_20090408_20090419_7)                             AS 'StDevCoh_20090408_20090419_7' 
   ,STDEV(SOURCE.AvgCoh_20090408_20090511_8)                             AS 'StDevCoh_20090408_20090511_8' 
   ,STDEV(SOURCE.AvgCoh_20090408_20090522_9)                             AS 'StDevCoh_20090408_20090522_9' 
   ,STDEV(SOURCE.AvgCoh_20090408_20090602_10)                            AS 'StDevCoh_20090408_20090602_10'
   ,STDEV(SOURCE.AvgCoh_20090419_20090511_11)                            AS 'StDevCoh_20090419_20090511_11'
   ,STDEV(SOURCE.AvgCoh_20090419_20090522_12)                            AS 'StDevCoh_20090419_20090522_12'
   ,STDEV(SOURCE.AvgCoh_20090419_20090602_13)                            AS 'StDevCoh_20090419_20090602_13'
   ,STDEV(SOURCE.AvgCoh_20090419_20090624_14)                            AS 'StDevCoh_20090419_20090624_14'
   ,STDEV(SOURCE.AvgCoh_20090511_20090522_15)                            AS 'StDevCoh_20090511_20090522_15'
   ,STDEV(SOURCE.AvgCoh_20090511_20090602_16)                            AS 'StDevCoh_20090511_20090602_16'
   ,STDEV(SOURCE.AvgCoh_20090511_20090624_17)                            AS 'StDevCoh_20090511_20090624_17'
   ,STDEV(SOURCE.AvgCoh_20090522_20090602_18)                            AS 'StDevCoh_20090522_20090602_18'
   ,STDEV(SOURCE.AvgCoh_20090522_20090624_19)                            AS 'StDevCoh_20090522_20090624_19'
   ,STDEV(SOURCE.AvgCoh_20090624_20090829_20)                            AS 'StDevCoh_20090624_20090829_20'
   ,STDEV(SOURCE.AvgCoh_20090624_20090920_21)                            AS 'StDevCoh_20090624_20090920_21'
   ,STDEV(SOURCE.AvgCoh_20090829_20091012_22)                            AS 'StDevCoh_20090829_20091012_22'
   ,STDEV(SOURCE.AvgCoh_20090829_20091023_23)                            AS 'StDevCoh_20090829_20091023_23'
   ,STDEV(SOURCE.AvgCoh_20090920_20091012_24)                            AS 'StDevCoh_20090920_20091012_24'
   ,STDEV(SOURCE.AvgCoh_20090920_20091023_25)                            AS 'StDevCoh_20090920_20091023_25'
   ,STDEV(SOURCE.AvgCoh_20090920_20091114_26)                            AS 'StDevCoh_20090920_20091114_26'
   ,STDEV(SOURCE.AvgCoh_20090920_20091206_27)                            AS 'StDevCoh_20090920_20091206_27'
   ,STDEV(SOURCE.AvgCoh_20090920_20091217_28)                            AS 'StDevCoh_20090920_20091217_28'
   ,STDEV(SOURCE.AvgCoh_20091012_20091023_29)                            AS 'StDevCoh_20091012_20091023_29'
   ,STDEV(SOURCE.AvgCoh_20091012_20091114_30)                            AS 'StDevCoh_20091012_20091114_30'
   ,STDEV(SOURCE.AvgCoh_20091012_20100108_31)                            AS 'StDevCoh_20091012_20100108_31'
   ,STDEV(SOURCE.AvgCoh_20091023_20091114_32)                            AS 'StDevCoh_20091023_20091114_32'
   ,STDEV(SOURCE.AvgCoh_20091023_20100108_33)                            AS 'StDevCoh_20091023_20100108_33'
   ,STDEV(SOURCE.AvgCoh_20091023_20100119_34)                            AS 'StDevCoh_20091023_20100119_34'
   ,STDEV(SOURCE.AvgCoh_20091114_20091206_35)                            AS 'StDevCoh_20091114_20091206_35'
   ,STDEV(SOURCE.AvgCoh_20091114_20091217_36)                            AS 'StDevCoh_20091114_20091217_36'
   ,STDEV(SOURCE.AvgCoh_20091114_20100108_37)                            AS 'StDevCoh_20091114_20100108_37'
   ,STDEV(SOURCE.AvgCoh_20091114_20100119_38)                            AS 'StDevCoh_20091114_20100119_38'
   ,STDEV(SOURCE.AvgCoh_20091114_20100130_39)                            AS 'StDevCoh_20091114_20100130_39'
   ,STDEV(SOURCE.AvgCoh_20091206_20091217_40)                            AS 'StDevCoh_20091206_20091217_40'
   ,STDEV(SOURCE.AvgCoh_20091206_20100108_41)                            AS 'StDevCoh_20091206_20100108_41'
   ,STDEV(SOURCE.AvgCoh_20091206_20100119_42)                            AS 'StDevCoh_20091206_20100119_42'
   ,STDEV(SOURCE.AvgCoh_20091217_20100108_43)                            AS 'StDevCoh_20091217_20100108_43'
   ,STDEV(SOURCE.AvgCoh_20091217_20100119_44)                            AS 'StDevCoh_20091217_20100119_44'
   ,STDEV(SOURCE.AvgCoh_20091228_20091206_45)                            AS 'StDevCoh_20091228_20091206_45'
   ,STDEV(SOURCE.AvgCoh_20091228_20091217_46)                            AS 'StDevCoh_20091228_20091217_46'
   ,STDEV(SOURCE.AvgCoh_20100108_20100119_47)                            AS 'StDevCoh_20100108_20100119_47'
   ,STDEV(SOURCE.AvgCoh_20100108_20100130_48)                            AS 'StDevCoh_20100108_20100130_48'
   ,STDEV(SOURCE.AvgCoh_20100119_20100130_49)                            AS 'StDevCoh_20100119_20100130_49'
   ,STDEV(SOURCE.AvgCoh_20110916_20111008_50)                            AS 'StDevCoh_20110916_20111008_50'
   ,STDEV(SOURCE.AvgCoh_20110916_20111213_51)                            AS 'StDevCoh_20110916_20111213_51'
   ,STDEV(SOURCE.AvgCoh_20111008_20111213_52)                            AS 'StDevCoh_20111008_20111213_52'
   ,STDEV(SOURCE.AvgCoh_20111008_20120104_53)                            AS 'StDevCoh_20111008_20120104_53'
   ,STDEV(SOURCE.AvgCoh_20111121_20120104_54)                            AS 'StDevCoh_20111121_20120104_54'
   ,STDEV(SOURCE.AvgCoh_20111121_20120206_55)                            AS 'StDevCoh_20111121_20120206_55'
   ,STDEV(SOURCE.AvgCoh_20111213_20120310_56)                            AS 'StDevCoh_20111213_20120310_56'
   ,STDEV(SOURCE.AvgCoh_20120104_20120206_57)                            AS 'StDevCoh_20120104_20120206_57'
   ,STDEV(SOURCE.AvgCoh_20120104_20120310_58)                            AS 'StDevCoh_20120104_20120310_58'
   ,STDEV(SOURCE.AvgCoh_20120104_20120401_59)                            AS 'StDevCoh_20120104_20120401_59'
   ,STDEV(SOURCE.AvgCoh_20120206_20120310_60)                            AS 'StDevCoh_20120206_20120310_60'
   ,STDEV(SOURCE.AvgCoh_20120206_20120401_61)                            AS 'StDevCoh_20120206_20120401_61'
   ,STDEV(SOURCE.AvgCoh_20120310_20120401_62)                            AS 'StDevCoh_20120310_20120401_62'
   ,STDEV(SOURCE.AvgCoh_20120310_20120515_63)                            AS 'StDevCoh_20120310_20120515_63'
   ,STDEV(SOURCE.AvgCoh_20120401_20120515_64)                            AS 'StDevCoh_20120401_20120515_64'
   ,STDEV(SOURCE.AvgCoh_20120401_20120628_65)                            AS 'StDevCoh_20120401_20120628_65'
   ,STDEV(SOURCE.AvgCoh_20120515_20120628_66)                            AS 'StDevCoh_20120515_20120628_66'
   ,STDEV(SOURCE.AvgCoh_20120515_20120811_67)                            AS 'StDevCoh_20120515_20120811_67'
   ,STDEV(SOURCE.AvgCoh_20120628_20120811_68)                            AS 'StDevCoh_20120628_20120811_68'
   ,STDEV(SOURCE.AvgCoh_20120628_20120902_69)                            AS 'StDevCoh_20120628_20120902_69'
   ,STDEV(SOURCE.AvgCoh_20120720_20121005_70)                            AS 'StDevCoh_20120720_20121005_70'
   ,STDEV(SOURCE.AvgCoh_20120811_20120902_71)                            AS 'StDevCoh_20120811_20120902_71'
   ,STDEVP(SOURCE.AvgCoh_20090328_20090408_1)                            AS 'StDevPCoh_20090328_20090408_1' 
   ,STDEVP(SOURCE.AvgCoh_20090328_20090419_2)                            AS 'StDevPCoh_20090328_20090419_2' 
   ,STDEVP(SOURCE.AvgCoh_20090328_20090511_3)                            AS 'StDevPCoh_20090328_20090511_3' 
   ,STDEVP(SOURCE.AvgCoh_20090328_20090522_4)                            AS 'StDevPCoh_20090328_20090522_4' 
   ,STDEVP(SOURCE.AvgCoh_20090328_20090602_5)                            AS 'StDevPCoh_20090328_20090602_5' 
   ,STDEVP(SOURCE.AvgCoh_20090328_20090624_6)                            AS 'StDevPCoh_20090328_20090624_6' 
   ,STDEVP(SOURCE.AvgCoh_20090408_20090419_7)                            AS 'StDevPCoh_20090408_20090419_7' 
   ,STDEVP(SOURCE.AvgCoh_20090408_20090511_8)                            AS 'StDevPCoh_20090408_20090511_8' 
   ,STDEVP(SOURCE.AvgCoh_20090408_20090522_9)                            AS 'StDevPCoh_20090408_20090522_9' 
   ,STDEVP(SOURCE.AvgCoh_20090408_20090602_10)                           AS 'StDevPCoh_20090408_20090602_10'
   ,STDEVP(SOURCE.AvgCoh_20090419_20090511_11)                           AS 'StDevPCoh_20090419_20090511_11'
   ,STDEVP(SOURCE.AvgCoh_20090419_20090522_12)                           AS 'StDevPCoh_20090419_20090522_12'
   ,STDEVP(SOURCE.AvgCoh_20090419_20090602_13)                           AS 'StDevPCoh_20090419_20090602_13'
   ,STDEVP(SOURCE.AvgCoh_20090419_20090624_14)                           AS 'StDevPCoh_20090419_20090624_14'
   ,STDEVP(SOURCE.AvgCoh_20090511_20090522_15)                           AS 'StDevPCoh_20090511_20090522_15'
   ,STDEVP(SOURCE.AvgCoh_20090511_20090602_16)                           AS 'StDevPCoh_20090511_20090602_16'
   ,STDEVP(SOURCE.AvgCoh_20090511_20090624_17)                           AS 'StDevPCoh_20090511_20090624_17'
   ,STDEVP(SOURCE.AvgCoh_20090522_20090602_18)                           AS 'StDevPCoh_20090522_20090602_18'
   ,STDEVP(SOURCE.AvgCoh_20090522_20090624_19)                           AS 'StDevPCoh_20090522_20090624_19'
   ,STDEVP(SOURCE.AvgCoh_20090624_20090829_20)                           AS 'StDevPCoh_20090624_20090829_20'
   ,STDEVP(SOURCE.AvgCoh_20090624_20090920_21)                           AS 'StDevPCoh_20090624_20090920_21'
   ,STDEVP(SOURCE.AvgCoh_20090829_20091012_22)                           AS 'StDevPCoh_20090829_20091012_22'
   ,STDEVP(SOURCE.AvgCoh_20090829_20091023_23)                           AS 'StDevPCoh_20090829_20091023_23'
   ,STDEVP(SOURCE.AvgCoh_20090920_20091012_24)                           AS 'StDevPCoh_20090920_20091012_24'
   ,STDEVP(SOURCE.AvgCoh_20090920_20091023_25)                           AS 'StDevPCoh_20090920_20091023_25'
   ,STDEVP(SOURCE.AvgCoh_20090920_20091114_26)                           AS 'StDevPCoh_20090920_20091114_26'
   ,STDEVP(SOURCE.AvgCoh_20090920_20091206_27)                           AS 'StDevPCoh_20090920_20091206_27'
   ,STDEVP(SOURCE.AvgCoh_20090920_20091217_28)                           AS 'StDevPCoh_20090920_20091217_28'
   ,STDEVP(SOURCE.AvgCoh_20091012_20091023_29)                           AS 'StDevPCoh_20091012_20091023_29'
   ,STDEVP(SOURCE.AvgCoh_20091012_20091114_30)                           AS 'StDevPCoh_20091012_20091114_30'
   ,STDEVP(SOURCE.AvgCoh_20091012_20100108_31)                           AS 'StDevPCoh_20091012_20100108_31'
   ,STDEVP(SOURCE.AvgCoh_20091023_20091114_32)                           AS 'StDevPCoh_20091023_20091114_32'
   ,STDEVP(SOURCE.AvgCoh_20091023_20100108_33)                           AS 'StDevPCoh_20091023_20100108_33'
   ,STDEVP(SOURCE.AvgCoh_20091023_20100119_34)                           AS 'StDevPCoh_20091023_20100119_34'
   ,STDEVP(SOURCE.AvgCoh_20091114_20091206_35)                           AS 'StDevPCoh_20091114_20091206_35'
   ,STDEVP(SOURCE.AvgCoh_20091114_20091217_36)                           AS 'StDevPCoh_20091114_20091217_36'
   ,STDEVP(SOURCE.AvgCoh_20091114_20100108_37)                           AS 'StDevPCoh_20091114_20100108_37'
   ,STDEVP(SOURCE.AvgCoh_20091114_20100119_38)                           AS 'StDevPCoh_20091114_20100119_38'
   ,STDEVP(SOURCE.AvgCoh_20091114_20100130_39)                           AS 'StDevPCoh_20091114_20100130_39'
   ,STDEVP(SOURCE.AvgCoh_20091206_20091217_40)                           AS 'StDevPCoh_20091206_20091217_40'
   ,STDEVP(SOURCE.AvgCoh_20091206_20100108_41)                           AS 'StDevPCoh_20091206_20100108_41'
   ,STDEVP(SOURCE.AvgCoh_20091206_20100119_42)                           AS 'StDevPCoh_20091206_20100119_42'
   ,STDEVP(SOURCE.AvgCoh_20091217_20100108_43)                           AS 'StDevPCoh_20091217_20100108_43'
   ,STDEVP(SOURCE.AvgCoh_20091217_20100119_44)                           AS 'StDevPCoh_20091217_20100119_44'
   ,STDEVP(SOURCE.AvgCoh_20091228_20091206_45)                           AS 'StDevPCoh_20091228_20091206_45'
   ,STDEVP(SOURCE.AvgCoh_20091228_20091217_46)                           AS 'StDevPCoh_20091228_20091217_46'
   ,STDEVP(SOURCE.AvgCoh_20100108_20100119_47)                           AS 'StDevPCoh_20100108_20100119_47'
   ,STDEVP(SOURCE.AvgCoh_20100108_20100130_48)                           AS 'StDevPCoh_20100108_20100130_48'
   ,STDEVP(SOURCE.AvgCoh_20100119_20100130_49)                           AS 'StDevPCoh_20100119_20100130_49'
   ,STDEVP(SOURCE.AvgCoh_20110916_20111008_50)                           AS 'StDevPCoh_20110916_20111008_50'
   ,STDEVP(SOURCE.AvgCoh_20110916_20111213_51)                           AS 'StDevPCoh_20110916_20111213_51'
   ,STDEVP(SOURCE.AvgCoh_20111008_20111213_52)                           AS 'StDevPCoh_20111008_20111213_52'
   ,STDEVP(SOURCE.AvgCoh_20111008_20120104_53)                           AS 'StDevPCoh_20111008_20120104_53'
   ,STDEVP(SOURCE.AvgCoh_20111121_20120104_54)                           AS 'StDevPCoh_20111121_20120104_54'
   ,STDEVP(SOURCE.AvgCoh_20111121_20120206_55)                           AS 'StDevPCoh_20111121_20120206_55'
   ,STDEVP(SOURCE.AvgCoh_20111213_20120310_56)                           AS 'StDevPCoh_20111213_20120310_56'
   ,STDEVP(SOURCE.AvgCoh_20120104_20120206_57)                           AS 'StDevPCoh_20120104_20120206_57'
   ,STDEVP(SOURCE.AvgCoh_20120104_20120310_58)                           AS 'StDevPCoh_20120104_20120310_58'
   ,STDEVP(SOURCE.AvgCoh_20120104_20120401_59)                           AS 'StDevPCoh_20120104_20120401_59'
   ,STDEVP(SOURCE.AvgCoh_20120206_20120310_60)                           AS 'StDevPCoh_20120206_20120310_60'
   ,STDEVP(SOURCE.AvgCoh_20120206_20120401_61)                           AS 'StDevPCoh_20120206_20120401_61'
   ,STDEVP(SOURCE.AvgCoh_20120310_20120401_62)                           AS 'StDevPCoh_20120310_20120401_62'
   ,STDEVP(SOURCE.AvgCoh_20120310_20120515_63)                           AS 'StDevPCoh_20120310_20120515_63'
   ,STDEVP(SOURCE.AvgCoh_20120401_20120515_64)                           AS 'StDevPCoh_20120401_20120515_64'
   ,STDEVP(SOURCE.AvgCoh_20120401_20120628_65)                           AS 'StDevPCoh_20120401_20120628_65'
   ,STDEVP(SOURCE.AvgCoh_20120515_20120628_66)                           AS 'StDevPCoh_20120515_20120628_66'
   ,STDEVP(SOURCE.AvgCoh_20120515_20120811_67)                           AS 'StDevPCoh_20120515_20120811_67'
   ,STDEVP(SOURCE.AvgCoh_20120628_20120811_68)                           AS 'StDevPCoh_20120628_20120811_68'
   ,STDEVP(SOURCE.AvgCoh_20120628_20120902_69)                           AS 'StDevPCoh_20120628_20120902_69'
   ,STDEVP(SOURCE.AvgCoh_20120720_20121005_70)                           AS 'StDevPCoh_20120720_20121005_70'
   ,STDEVP(SOURCE.AvgCoh_20120811_20120902_71)                           AS 'StDevPCoh_20120811_20120902_71'
   ,AVG(SOURCE.AvgCoh_20130416_20130508_1)                               AS 'AvgCoh_20130416_20130508_1'
   ,AVG(SOURCE.AvgCoh_20130416_20130621_2)                               AS 'AvgCoh_20130416_20130621_2'
   ,AVG(SOURCE.AvgCoh_20130508_20130621_3)                               AS 'AvgCoh_20130508_20130621_3'
   ,AVG(SOURCE.AvgCoh_20130508_20130713_4)                               AS 'AvgCoh_20130508_20130713_4'
   ,AVG(SOURCE.AvgCoh_20130621_20130917_5)                               AS 'AvgCoh_20130621_20130917_5'
   ,AVG(SOURCE.AvgCoh_20130713_20130917_6)                               AS 'AvgCoh_20130713_20130917_6'
   ,AVG(SOURCE.AvgCoh_20130917_20131214_7)                               AS 'AvgCoh_20130917_20131214_7'
   ,AVG(SOURCE.AvgCoh_20131214_20140312_8)                               AS 'AvgCoh_20131214_20140312_8'
   ,AVG(SOURCE.AvgCoh_20140312_20140517_9)                               AS 'AvgCoh_20140312_20140517_9'
   ,AVG(SOURCE.AvgCoh_20140802_20140517_10)                              AS 'AvgCoh_20140802_20140517_10'
   ,AVG(SOURCE.AvgCoh_20140802_20140915_11)                              AS 'AvgCoh_20140802_20140915_11'
   ,AVG(SOURCE.AvgCoh_20140802_20141029_12)                              AS 'AvgCoh_20140802_20141029_12'
   ,AVG(SOURCE.AvgCoh_20141029_20141223_13)                              AS 'AvgCoh_20141029_20141223_13'
   ,AVG(SOURCE.AvgCoh_20150401_20150515_14)                              AS 'AvgCoh_20150401_20150515_14'
   ,MAX(SOURCE.MaxCoh_20130416_20130508_1)                               AS 'MaxCoh_20130416_20130508_1' 
   ,MAX(SOURCE.MaxCoh_20130416_20130621_2)                               AS 'MaxCoh_20130416_20130621_2' 
   ,MAX(SOURCE.MaxCoh_20130508_20130621_3)                               AS 'MaxCoh_20130508_20130621_3' 
   ,MAX(SOURCE.MaxCoh_20130508_20130713_4)                               AS 'MaxCoh_20130508_20130713_4' 
   ,MAX(SOURCE.MaxCoh_20130621_20130917_5)                               AS 'MaxCoh_20130621_20130917_5' 
   ,MAX(SOURCE.MaxCoh_20130713_20130917_6)                               AS 'MaxCoh_20130713_20130917_6' 
   ,MAX(SOURCE.MaxCoh_20130917_20131214_7)                               AS 'MaxCoh_20130917_20131214_7'
   ,MAX(SOURCE.MaxCoh_20131214_20140312_8)                               AS 'MaxCoh_20131214_20140312_8'
   ,MAX(SOURCE.MaxCoh_20140312_20140517_9)                               AS 'MaxCoh_20140312_20140517_9'
   ,MAX(SOURCE.MaxCoh_20140802_20140517_10)                              AS 'MaxCoh_20140802_20140517_10'
   ,MAX(SOURCE.MaxCoh_20140802_20140915_11)                              AS 'MaxCoh_20140802_20140915_11'
   ,MAX(SOURCE.MaxCoh_20140802_20141029_12)                              AS 'MaxCoh_20140802_20141029_12'
   ,MAX(SOURCE.MaxCoh_20141029_20141223_13)                              AS 'MaxCoh_20141029_20141223_13'
   ,MAX(SOURCE.MaxCoh_20150401_20150515_14)                              AS 'MaxCoh_20150401_20150515_14'
   ,MIN(SOURCE.MinCoh_20130416_20130508_1)                               AS 'MinCoh_20130416_20130508_1' 
   ,MIN(SOURCE.MinCoh_20130416_20130621_2)                               AS 'MinCoh_20130416_20130621_2' 
   ,MIN(SOURCE.MinCoh_20130508_20130621_3)                               AS 'MinCoh_20130508_20130621_3' 
   ,MIN(SOURCE.MinCoh_20130508_20130713_4)                               AS 'MinCoh_20130508_20130713_4' 
   ,MIN(SOURCE.MinCoh_20130621_20130917_5)                               AS 'MinCoh_20130621_20130917_5' 
   ,MIN(SOURCE.MinCoh_20130713_20130917_6)                               AS 'MinCoh_20130713_20130917_6' 
   ,MIN(SOURCE.MinCoh_20130917_20131214_7)                               AS 'MinCoh_20130917_20131214_7'
   ,MIN(SOURCE.MinCoh_20131214_20140312_8)                               AS 'MinCoh_20131214_20140312_8'
   ,MIN(SOURCE.MinCoh_20140312_20140517_9)                               AS 'MinCoh_20140312_20140517_9'
   ,MIN(SOURCE.MinCoh_20140802_20140517_10)                              AS 'MinCoh_20140802_20140517_10'
   ,MIN(SOURCE.MinCoh_20140802_20140915_11)                              AS 'MinCoh_20140802_20140915_11'
   ,MIN(SOURCE.MinCoh_20140802_20141029_12)                              AS 'MinCoh_20140802_20141029_12'
   ,MIN(SOURCE.MinCoh_20141029_20141223_13)                              AS 'MinCoh_20141029_20141223_13'
   ,MIN(SOURCE.MinCoh_20150401_20150515_14)                              AS 'MinCoh_20150401_20150515_14'
   ,STDEV(SOURCE.AvgCoh_20130416_20130508_1)                             AS 'StDevCoh_20130416_20130508_1'
   ,STDEV(SOURCE.AvgCoh_20130416_20130621_2)                             AS 'StDevCoh_20130416_20130621_2'
   ,STDEV(SOURCE.AvgCoh_20130508_20130621_3)                             AS 'StDevCoh_20130508_20130621_3'
   ,STDEV(SOURCE.AvgCoh_20130508_20130713_4)                             AS 'StDevCoh_20130508_20130713_4'
   ,STDEV(SOURCE.AvgCoh_20130621_20130917_5)                             AS 'StDevCoh_20130621_20130917_5'
   ,STDEV(SOURCE.AvgCoh_20130713_20130917_6)                             AS 'StDevCoh_20130713_20130917_6'
   ,STDEV(SOURCE.AvgCoh_20130917_20131214_7)                             AS 'StDevCoh_20130917_20131214_7'
   ,STDEV(SOURCE.AvgCoh_20131214_20140312_8)                             AS 'StDevCoh_20131214_20140312_8'
   ,STDEV(SOURCE.AvgCoh_20140312_20140517_9)                             AS 'StDevCoh_20140312_20140517_9'
   ,STDEV(SOURCE.AvgCoh_20140802_20140517_10)                            AS 'StDevCoh_20140802_20140517_10'
   ,STDEV(SOURCE.AvgCoh_20140802_20140915_11)                            AS 'StDevCoh_20140802_20140915_11'
   ,STDEV(SOURCE.AvgCoh_20140802_20141029_12)                            AS 'StDevCoh_20140802_20141029_12'
   ,STDEV(SOURCE.AvgCoh_20141029_20141223_13)                            AS 'StDevCoh_20141029_20141223_13'
   ,STDEV(SOURCE.AvgCoh_20150401_20150515_14)                            AS 'StDevCoh_20150401_20150515_14'
   ,STDEVP(SOURCE.AvgCoh_20130416_20130508_1)                           AS 'StDevPCoh_20130416_20130508_1'
   ,STDEVP(SOURCE.AvgCoh_20130416_20130621_2)                           AS 'StDevPCoh_20130416_20130621_2'
   ,STDEVP(SOURCE.AvgCoh_20130508_20130621_3)                           AS 'StDevPCoh_20130508_20130621_3'
   ,STDEVP(SOURCE.AvgCoh_20130508_20130713_4)                           AS 'StDevPCoh_20130508_20130713_4'
   ,STDEVP(SOURCE.AvgCoh_20130621_20130917_5)                           AS 'StDevPCoh_20130621_20130917_5'
   ,STDEVP(SOURCE.AvgCoh_20130713_20130917_6)                           AS 'StDevPCoh_20130713_20130917_6'
   ,STDEVP(SOURCE.AvgCoh_20130917_20131214_7)                           AS 'StDevPCoh_20130917_20131214_7'
   ,STDEVP(SOURCE.AvgCoh_20131214_20140312_8)                           AS 'StDevPCoh_20131214_20140312_8'
   ,STDEVP(SOURCE.AvgCoh_20140312_20140517_9)                           AS 'StDevPCoh_20140312_20140517_9'
   ,STDEVP(SOURCE.AvgCoh_20140802_20140517_10)                          AS 'StDevPCoh_20140802_20140517_10'
   ,STDEVP(SOURCE.AvgCoh_20140802_20140915_11)                          AS 'StDevPCoh_20140802_20140915_11'
   ,STDEVP(SOURCE.AvgCoh_20140802_20141029_12)                          AS 'StDevPCoh_20140802_20141029_12'
   ,STDEVP(SOURCE.AvgCoh_20141029_20141223_13)                          AS 'StDevPCoh_20141029_20141223_13'
   ,STDEVP(SOURCE.AvgCoh_20150401_20150515_14)                          AS 'StDevPCoh_20150401_20150515_14'
   ,geography::UnionAggregate(SOURCE.Shape)							    AS 'Shape'
INTO
	A_SHANGHAI_URBANDISTRICTS_final
FROM 
	A_SHANGHAI_STEETBLOCKS_final AS SOURCE
LEFT OUTER JOIN
	CHINA_CENSUS_POPCENSUS2010_TOWNSHIP AS CENSUS
ON
	SOURCE.CensusPointID = CENSUS.OBJECTID
GROUP BY
	SOURCE.CensusPointID	


USE [weiboDEV]
GO
alter table [dbo].[A_SHANGHAI_URBANDISTRICTS_final] alter column OBJECTID int not null

USE [weiboDEV]
GO
/****** Object:  Index [PK_SHANGHAI_STEETBLOCKS_final]    Script Date: 2/3/2016 5:03:45 PM ******/
ALTER TABLE [dbo].[A_SHANGHAI_URBANDISTRICTS_final] ADD  CONSTRAINT [PK_A_SHANGHAI_URBANDISTRICTS_final] PRIMARY KEY CLUSTERED 
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE [weiboDEV]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE SPATIAL INDEX [SpatialIndex-Shape] ON [dbo].[A_SHANGHAI_URBANDISTRICTS_final]
(
	[Shape]
)USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO


				SELECT * FROM A_SHANGHAI_URBANDISTRICTS_final
				SELECT * FROM CHINA_CENSUS_POPCENSUS2010_TOWNSHIP



