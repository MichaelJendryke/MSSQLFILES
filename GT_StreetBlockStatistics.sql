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
-- a) Total message count and number of unique users
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

-- b) Total message count and number of unique users that said that they are from province 31 (Shanghai)
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

-- c) MessageCount and DistinctUserCount user count per month per street-block
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

-- d) RESIDENTS MessageCount and DistinctUserCount per month per street-block
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

-- e) TOURISTS MessageCount and DistinctUserCount per month per street-block
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

-- f LINK STREET BLOCK to nearest CENSUS POINT
SELECT 
	SB.OBJECTID
   ,SB.JOIN_FID as  CensusPointID
INTO
	SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID
FROM
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA] as SB

-- g Number of messages of Residents and tourists per streetblock per HOUR


------------------------------------------------------------------------------------------------------
-- 3. GET DATA FROM COHERENCE TO STREET BLOCKS
------------------------------------------------------------------------------------------------------
-- Consider the results produced with 
-- GT_STACK1_StreetBlockStatistics.sql
-- GT_STACK2_StreetBlockStatistics.sql

DROP TABLE
	A_SHANGHAI_STEETBLOCKS_final
SELECT
	SBS.OBJECTID
	,WBa.TotalMessageCount AS TotalMessageCount
	,WBa.TotalMessageCount/(SBS.Shape.STArea() * 1.3660165585202479473772673948682) AS TotalMsgDensity
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
	,SBS.Shape.STArea() AS AREASQM
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
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount AS WBa
ON
	SBS.OBJECTID = WBa.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount as WBb
ON
	SBS.OBJECTID = WBb.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH as WBc
ON
	SBS.OBJECTID = WBc.OBJECTID
LEFT OUTER JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH as WBd
ON
	SBS.OBJECTID = WBd.OBJECTID
LEFT OUTER JOIN 
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH as WBe
ON
	SBS.OBJECTID = WBe.OBJECTID

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
-- 3. GET DATA FROM WEIBO TO STREET BLOCKS
------------------------------------------------------------------------------------------------------

-- master
drop table temp3
Select  
	Polygon.[OBJECTID],
	Polygon.[Input_FID],
	[ADM_2],
	CENSUS.POP									as TotalPopulation,
	CENSUS.M									as MalePopulation,
	CENSUS.F									as FemalePopulation,
	CENSUS.AGE0									as AGE0Population,
	CENSUS.AGE15								as AGE15Population,
	CENSUS.AGE65								as AGE65Population,
	CENSUS.Address								as PopulationAddress,
	MessageCount,
	MessageCount/CENSUS.POP						as MessagesPerTotalPop,
	ResidentsMessageCount,
	ResidentsMessageCount/CENSUS.POP			as ResidentMessagesPerTotalPop,
	UserCount,
	UserCount/CENSUS.POP						as UsersPerTotalPop,
	ResidentsUserCount,
	ResidentsUserCount/CENSUS.POP				as ResidentUsersPerTotalPop,
	CENSUS.POP/ResidentsUserCount/Polygon.Shape.STArea()				as ResUsrPerTotalPopPerArea,
	Polygon.Shape.STArea()						as AREA_in_SQM,
	CENSUS.POP/Polygon.Shape.STArea()			as PopulationDensity,
	ResidentsUserCount/(CENSUS.POP/Polygon.Shape.STArea())			as ResUsrCntPerPopDens,
	MessageCount/Polygon.Shape.STArea()			as MessageDensity,
	ResidentsUserCount/Polygon.Shape.STArea()	as WeiboResidentsDensity,
	Polygon.Shape
INTO 
	temp3
FROM
	[dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID] as Polygon

LEFT OUTER JOIN
	temp1
ON	
	temp1.[Input_FID] = Polygon.[Input_FID]
LEFT OUTER JOIN
	temp2
ON	
	temp2.[Input_FID] = Polygon.[Input_FID]
LEFT OUTER JOIN
	CHINA_CENSUS_POPCENSUS2010_TOWNSHIP_THIESSEN as CENSUS
ON	
	CENSUS.[OBJECTID] = Polygon.[Input_FID]
WHERE 
	Polygon.ADM_2 = 262


select distinct Shape.STSrid from [dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID]



-- THE FOLLOWING HAS TO BE REVISED, Probably OK but output unknown

-------------------
-- 3.
-------------------
SELECT        dbo.Points_Shanghai_262.*, dbo.Points_Shanghai_262_msgID_LINK_OSM_OID.*, dbo.SHANGHAI_262_OSM_ROADS_POLYGONS.*
FROM            dbo.Points_Shanghai_262 INNER JOIN
                         dbo.Points_Shanghai_262_msgID_LINK_OSM_OID ON dbo.Points_Shanghai_262.msgID = dbo.Points_Shanghai_262_msgID_LINK_OSM_OID.msgID INNER JOIN
                         dbo.SHANGHAI_262_OSM_ROADS_POLYGONS ON dbo.Points_Shanghai_262_msgID_LINK_OSM_OID.OID = dbo.SHANGHAI_262_OSM_ROADS_POLYGONS.OID




---- CREATE 
-- LINK_msgID_to_STREET_BLOCKS_Input_FID

----STEP 1
-- Create Table that links msgID and objectID from STREET_BLOCK_DISSOLVED_THIESSEN_ID polygons
------------------------------------------------------------------------------------------------------
-- 0. UPDATE STREET BLOCKS with ADM IDs  -------------------------------------------------------------
------------------------------------------------------------------------------------------------------
USE 
	weiboDEV
GO
UPDATE  
	[dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID]
SET
	[dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID].[ADM_2] = 262
FROM 
	[dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID] as STREETBLOCK
JOIN
	[dbo].[GADM_CHN_ADM3_SINGLE] as polyADM
ON  
	polyADM.Shape.STIntersects(STREETBLOCK.Shape) =1
WHERE
	[ID_2] = 262
