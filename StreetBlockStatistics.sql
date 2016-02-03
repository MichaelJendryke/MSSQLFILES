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


------------------------------------------------------------------------------------------------------
-- 3. GET DATA FROM COHERENCE TO STREET BLOCKS
------------------------------------------------------------------------------------------------------
-- Consider the results produced with 
-- GT_STACK1_StreetBlockStatistics.sql
-- GT_STACK2_StreetBlockStatistics.sql



SELECT
	SBS.OBJECTID
	,WBa.TotalMessageCount AS TotalMessageCount
	,WBa.DistinctUserCount AS DistinctUserCount
	,WBb.ResidentsMessageCount AS ResidentsMessageCount
	,WBb.ResidentsUserCount AS ResidentsUserCount
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
JOIN
	STEET_BLOCK_TotalMessageCount_and_DistinctUserCount AS WBa
ON
	SBS.OBJECTID = WBa.OBJECTID
JOIN
	STEET_BLOCK_ResidentsTotalMessageCount_and_ResidentsDistinctUserCount as WBb
ON
	SBS.OBJECTID = WBb.OBJECTID
WHERE
	SBC2.STREETBLOCKID = 18969










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
