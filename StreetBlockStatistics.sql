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


------------------------------------------------------------------------------------------------------
-- 2. Create Table that links msgID and objectID from STREET_BLOCK_DISSOLVED_THIESSEN_ID polygons  ---
------------------------------------------------------------------------------------------------------
SELECT
	[Input_FID],
	Count([msgID]) as MessageCount,
	Count(Distinct [userID]) as UserCount
FROM
	LINK_msgID_userID_to_STREET_BLOCKS_Input_FID_Shanghai_262
GROUP BY
	[Input_FID]





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
