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
   ,COUNT (LINK1.[msgID]) AS ResidentsMessageCount
   ,COUNT(DISTINCT LINK1.[userID]) AS ResidentsUserCount
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

-- c) MessageCount and distinct user count per month per street-block
DROP TABLE
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS MessageCount
   ,COUNT(DISTINCT LINK1.userID) AS DistinctUserCount
INTO
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount_PER_MONTH
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

-- d) RESIDENTS MessageCount and DistinctUserCount per month per street-block
DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS ResidentsMessageCount
   ,COUNT(DISTINCT LINK1.userID) AS ResidentsDistinctUserCount
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount_PER_MONTH
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

-- e) TOURISTS MessageCount and DistinctUserCount per month per street-block
DROP TABLE
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
SELECT
	LINK1.OBJECTID
   ,YEAR(POINTS.[createdAT]) AS YEAR
   ,MONTH(POINTS.[createdAT]) AS MONTH
   ,COUNT(LINK1.[msgID]) AS TouristsMessageCount
   ,COUNT(DISTINCT LINK1.userID) AS TouristsDistinctUserCount
INTO
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
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

-- f LINK STREET BLOCK to nearest CENSUS POINT
SELECT 
	SB.OBJECTID
   ,SB.JOIN_FID as  CensusPointID
INTO
	SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID
FROM
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA] as SB





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
