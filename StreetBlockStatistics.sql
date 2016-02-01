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
-- 1. Create Table that links msgID and objectID from STREET_BLOCK_DISSOLVED_THIESSEN_ID polygons  ---
------------------------------------------------------------------------------------------------------
-- around 2h runtime for Shanghai with over 30000 polygons
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


USE 
	[weiboDEV]
GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20150905-141653] ON [dbo].[SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCKID]
(
	[msgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


------------------------------------------------------------------------------------------------------
-- 2. Count RESIDETNS Message Count and Distict User Count from Shanghai  ---
------------------------------------------------------------------------------------------------------
USE
	weiboDEV
GO
drop table temp1
SELECT
	[STREETBLOCKID], -- unique id of each Street Block polygon
	COUNT (LINK1.[msgID]) AS MessageCount,
	Count(Distinct LINK1.[userID]) AS UserCount
INTO
	temp1
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCKID as LINK1
GROUP BY
	[STREETBLOCKID]


SELECT
	[Input_FID],
	COUNT (LINK1.[msgID]) AS ResidentsMessageCount,
	Count(Distinct LINK1.[userID]) AS ResidentsUserCount
INTO
	temp2
FROM
	LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262 as LINK1
JOIN
	[dbo].[NBT4_exact_copy]
ON
	LINK1.msgID = [dbo].[NBT4_exact_copy].[msgID]
WHERE
	[dbo].[NBT4_exact_copy].userprovince = 31
GROUP BY
	[Input_FID]


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
