use weiboDEV
go
truncate table [dbo].[BIG_FULL]

DROP INDEX [SpatialIndex_BIG_FULL] ON [dbo].[BIG_FULL]
ALTER TABLE [dbo].[BIG_FULL] DROP CONSTRAINT [PK_BIG_FULL]
alter table [dbo].[BIG_FULL] DROP COLUMN ID
alter table [dbo].[BIG_FULL] DROP COLUMN shape

BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_1.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_2.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_3.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_4.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_5.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_6.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_7.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_8.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_9.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_10.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_11.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_12.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_13.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_14.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_15.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_16.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_17.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_18.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_19.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_20.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_21.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_22.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_23.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_24.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)
BULK INSERT BIG_FULL FROM 'F:\LINUX\1_Stack_SH\SM\SBAsubsets\resultfilteredFULL_25.csv' WITH(FIRSTROW = 1,FIELDTERMINATOR = ',',ROWTERMINATOR = '#', TABLOCK)

-- ADD AN INDEX COLUMN
-- ALTER TABLE BIG_FULL DROP COLUMN  ID;
ALTER TABLE BIG_FULL ADD ID int IDENTITY(1,1);

alter table [weiboDEV].[dbo].[BIG_FULL]
add shape  geography NULL;

update [weiboDEV].[dbo].[BIG_FULL]
  set shape = geography::STGeomFromText('POINT('+convert(varchar(20),lon)+' '+convert(varchar(20),lat)+')',4326);

USE [weiboDEV]
GO
ALTER TABLE [dbo].[BIG_FULL] ADD  CONSTRAINT [PK_BIG_FULL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
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

/****** Object:  Index [SpatialIndex-20150619-114940]    Script Date: 11/11/2015 2:33:06 PM ******/
CREATE SPATIAL INDEX [SpatialIndex_BIG_FULL] ON [weiboDEV].[dbo].[BIG_FULL]
(
	[shape]
)USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 4000, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [weiboDEV]
GO
SELECT top 1000 *
  FROM [dbo].[BIG_FULL]
GO