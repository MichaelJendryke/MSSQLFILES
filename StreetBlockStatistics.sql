-- How to sort Points of any City into Polygons of OpenStreetMap OSM
-- 1. Link msgID of the Points to the Input_FID of DISSOLVED Thiessen Street blocks
--    a link table will be generated
-- 2. Select Point table and join with Linktable



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

------------------------------------------------------------------------------------------------------
-- 1. Create Table that links msgID and objectID from STREET_BLOCK_DISSOLVED_THIESSEN_ID polygons  ---
------------------------------------------------------------------------------------------------------
USE 
	weiboDEV
GO
DROP TABLE 
	LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262
Select 
	[OBJECTID],
	[Input_FID],
	[msgID],
	[userID]
INTO 
	LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262
FROM 
	[dbo].[NBT4_exact_copy_GEO] as point 
WITH(nolock,INDEX([SpatialIndex-20150619-114940]))
JOIN 
	[dbo].[CHINA_STREET_BLOCK_DISSOLVED_BY_THIESSEN_ID] as polygon
ON 
	point.location.STIntersects(polygon.Shape) =1
WHERE
	polygon.ADM_2 = 262

USE [weiboDEV]

GO

CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20150905-141653] ON [dbo].[LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262]
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
SELECT
	[Input_FID],
	COUNT (LINK1.[msgID]) AS MessageCount,
	Count(Distinct LINK1.[userID]) AS UserCount
INTO
	temp1
FROM
	LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262 as LINK1
GROUP BY
	[Input_FID]


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
	MessageCount/CENSUS.POP						as MessagesPerTotalPopulation,
	ResidentsMessageCount,
	ResidentsMessageCount/CENSUS.POP			as ResidentMessagesPerTotalPopulation,
	UserCount,
	UserCount/CENSUS.POP						as UsersPerTotalPopulation,
	ResidentsUserCount,
	ResidentsUserCount/CENSUS.POP				as ResidentUsersPerTotalPopulation,
	Polygon.Shape.STArea()						as AREA_in_SQM,
	CENSUS.POP/Polygon.Shape.STArea()			as PopulationDensity,
	MessageCount/Polygon.Shape.STArea()			as MessageDensity,
	ResidentsUserCount/Polygon.Shape.STArea()	as WeiboResidtesDensity,
	Polygon.Shape
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
