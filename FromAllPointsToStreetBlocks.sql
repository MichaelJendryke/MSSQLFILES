-- Create Table that links msgID and objectID from polygon
--truncate table msgID_OBJECTID	
Insert INTO msgID_to_GADM_CHN_ADM3_SINGLE_OBJECTID
Select [msgID], [OBJECTID]
From [dbo].[NBT4_exact_copy_GEO] as point WITH(nolock,INDEX([SpatialIndex-20150619-114940]))
Join [dbo].[GADM_CHN_ADM3_SINGLE] as polygon
   On point.location.STIntersects(polygon.Shape) =1

--LINK msgID and userID to OID of OSM (for Shanghai around 15minutes runtime)
use weiboDEV
GO
drop table Shanghai_262_neighborhood
Select top 0 * into Shanghai_262_neighborhood from  [dbo].[LINK_msgID_to_GADM_CHN_ADM3_SINGLE_OBJECTID]
-- Create Table that links msgID and objectID from polygon
--truncate table msgID_OBJECTID	
use weiboDEV
go
drop table Points_Shanghai_262_LINK_OSM_OID
Select [msgID],[userID],[OID]
INTO Points_Shanghai_262_LINK_OSM_OID
From [dbo].[Points_Shanghai_262] as point WITH(nolock,INDEX([location_SpatialIndex-20150624-142054]))
Join [dbo].[SHANGHAI_262_OSM_ROADS_POLYGONS] as polygon
On point.location.STIntersects(polygon.Shape) =1



SELECT
[dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID,
[dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID, 
createdAT,
dateadd(hour,8,createdAT),
cast(createdAT as time) as TIME
from [dbo].[LINK_Points_Shanghai_262_to_OID_OSM]
Join [dbo].[Points_Shanghai_262]
ON [dbo].[Points_Shanghai_262].msgID = [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID
Where [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID = 1036


drop table SHANGHAI_262_OSM_ROADS_POLYGONS_avgTime
use weiboDEV
go
SELECT
[dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID,
count([dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID) as MsgCount,
cast('2000-01-01 ' + cast(AVG(DATEPART(hh,dateadd(hour,8,createdAT))) as varchar) + ':'+ cast(AVG(DATEPART(mm,dateadd(hour,8,createdAT))) as varchar) + ':00' as datetime) as dt,
cast(RIGHT('0'+ rtrim(AVG(DATEPART(hh,dateadd(hour,8,createdAT)))),2) + 
RIGHT('0'+ rtrim(AVG(DATEPART(mm,dateadd(hour,8,createdAT)))),2) as varchar)as miltime,
RIGHT('0'+ rtrim(AVG(DATEPART(hh,dateadd(hour,8,createdAT)))),2) as hh
--Cast('2009-1-1' AS datetime)
into SHANGHAI_262_OSM_ROADS_POLYGONS_avgTime
from [dbo].[LINK_Points_Shanghai_262_to_OID_OSM]
Join [dbo].[Points_Shanghai_262]
ON [dbo].[Points_Shanghai_262].msgID = [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID
group by [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID
select * from SHANGHAI_262_OSM_ROADS_POLYGONS_avgTime Order by OBJECTID

Select RIGHT('00000'+ rtrim('te'),3) 