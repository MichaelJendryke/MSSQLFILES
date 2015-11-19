-------------------------------------------------------------------
--  0   	STACK 1 OR 2
-------------------------------------------------------------------
use weiboDEV
go
truncate table [dbo].[BIG_FULL]
SELECT top 0 * into [dbo].[BIG_FULL] FROM [dbo].[BIG_FULL_STACK_1_template]
SELECT top 0 * into [dbo].[BIG_FULL] FROM [dbo].[BIG_FULL_STACK_2_template]


-------------------------------------------------------------------
--  1   	LOAD DATA FROM MATLAB's CSV FILES INTO SQL SERVER
-------------------------------------------------------------------
--
--			RENAME if necessary!
--
USE [weiboDEV]
GO
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_1.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_2.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_3.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_4.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_5.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_6.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_7.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_8.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_9.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_10.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_11.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_12.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_13.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_14.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_15.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_16.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_17.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_18.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_19.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_20.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_21.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_22.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_23.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_24.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_25.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_26.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\2_Stack_SH\SM\SBAsubsets\resultfilteredEQFULL_27.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)


-------------------------------------------------------------------
--  2   	ADD AN INDEX COLUMN PK and SI
-------------------------------------------------------------------
-- ID
USE [weiboDEV]
GO
ALTER TABLE 
	BIG_FULL 
ADD 
	ID int IDENTITY(1,1)

ALTER TABLE [dbo].[BIG_FULL] ADD  CONSTRAINT [PK_BIG_FULL3] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
-- SPATIAL
USE [weiboDEV]
GO
ALTER TABLE 
	[weiboDEV].[dbo].[BIG_FULL]
ADD
	shape  geography NULL;
GO
UPDATE
	[weiboDEV].[dbo].[BIG_FULL]
SET shape = geography::STGeomFromText('POINT('+convert(varchar(20),lon)+' '+convert(varchar(20),lat)+')',4326);
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE SPATIAL INDEX [SpatialIndex_BIG_FULL] ON [weiboDEV].[dbo].[BIG_FULL]
(
	[shape]
)USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 4000, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


-------------------------------------------------------------------
--  3   	RENAMING
-------------------------------------------------------------------
--
--			RENAME IS NECESSARY!
--
declare @st nvarchar(14), @stPK nvarchar(14), @stSI nvarchar(14)
set @st = 'STACK2_rfEQ'
set @stPK = 'PK_' + @st
set @stSI = 'SI_' + @st
--EXEC sp_rename N'BIG_FULL', @st
EXEC sp_rename N'weiboDEV.dbo.STACK2_rfEQ.PK_BIG_FULL3',          @stPK, N'INDEX'; 
EXEC sp_rename N'weiboDEV.dbo.STACK2_rfEQ.SpatialIndex_BIG_FULL', @stSI, N'INDEX'; 

sp_rename BIG_FULL_ID_TO_STREETBLOCKID, STACK2_LINK_ID_to_STREETBLOOKID
EXEC sp_rename N'weiboDEV.dbo.STACK2_LINK_ID_to_STREETBLOOKID.PK_BIG_FULL_ID_TO_STREETBLOCKID',    N'PK_STACK2_ID',      N'INDEX'; 
EXEC sp_rename N'weiboDEV.dbo.STACK2_LINK_ID_to_STREETBLOOKID.ClusteredIndex-On-ID',               N'CL_STACK2_ID',      N'INDEX';
EXEC sp_rename N'weiboDEV.dbo.STACK2_LINK_ID_to_STREETBLOOKID.NonClusteredIndex-On-STREETBLOCKID', N'nonCL_STACK2_SBID', N'INDEX';


-------------------------------------------------------------------
--  4   	LINK THE POINTS WITH THE STREETBLOCKS
-------------------------------------------------------------------
--
--			RENAME if necessary!
--
USE 
weiboDEV
GO
DROP TABLE 
	-- the link between street blocks and messages!!!
	STACK1_LINK_ID_to_STREETBLOOKID
Select 
	[ID],
	[STREETBLOCKID]-- this is equal to the target_id from the spatial join tool in ArcMAP
INTO
    -- the link between street blocks and messages!!! 
	STACK1_LINK_ID_to_STREETBLOOKID
FROM 
	-- the original points
	[dbo].[STACK1_rfEQ] as point 
WITH(nolock,INDEX([SI_STACK1_rfEQ]))
JOIN 
	-- the street block layer
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA] as polygon
ON 
	point.shape.STIntersects(polygon.Shape) =1
WHERE
	polygon.GADM_ID_2 = 262;
GO


-------------------------------------------------------------------
--  5   	CREATE INDICES for the LINK Table
-------------------------------------------------------------------
--
--			RENAME if necessary!
--
USE [weiboDEV]
GO
CREATE UNIQUE CLUSTERED INDEX [CL_STACK1_ID] ON [dbo].[STACK1_LINK_ID_to_STREETBLOOKID]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
USE [weiboDEV]
GO

CREATE NONCLUSTERED INDEX [nonCL_STACK1_STREETBLOCKID] ON [dbo].[STACK1_LINK_ID_to_STREETBLOOKID]
(
	[STREETBLOCKID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
USE [weiboDEV]
GO

ALTER TABLE [dbo].[STACK1_LINK_ID_to_STREETBLOOKID] ADD  CONSTRAINT [PK_STACK1_ID] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


-------------------------------------------------------------------
--  6   	Create Average Tables
-------------------------------------------------------------------
--
--	Open: GT_STACK1_StreetBlockStatistics
--	      GT_STACK2_StreetBlockStatistics	
--