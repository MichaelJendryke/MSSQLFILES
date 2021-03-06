select top 10 [RandomID],[TimesHarvested],[TotalCollected],[TotalInserted],[LAT],[LON],[ratio] from [weibo].[dbo].[HEXAGONPOINTS] Where [taken]=0;

Select COUNT(*) from [weibo].[dbo].[HEXAGONPOINTS] where [taken]=1;


update [weibo].[dbo].[HEXAGONPOINTS] set [taken]=1 WHERE [RandomID]IN(5, 6, 7, 8, 9, 10, 11, 12, 13, 14);

update [weibo].[dbo].[HEXAGONPOINTS] set [TimesHarvested]=99,  [TotalCollected]=1000 Where [RandomID]=1

--reset ALL!!
-- update [weibo].[dbo].[HEXAGONPOINTS] set [TimesHarvested]=0,[TotalCollected]=0,[TotalInserted]=0,[ratio]=0.01,[taken]=0;

-- reset taken HEXAGONS
update [weibo].[dbo].[HEXAGONPOINTS] set [taken]=0;

-- reset harvester API keys
update [weibo].[dbo].APPKEYS
	set [Harvester_TakenBySeason]=0, 
		[Harvester_IPInUse]=0, 
		[Harvester_InUseCount]=0,
		[Harvester_Status]='inactive';

-- calculate Average
update [weibo].[dbo].[HEXAGONPOINTS] set [AvgResult]=cast(([TotalCollected]/[TimesHarvested]) as int) Where TotalCollected>0;
 
-- number of field for 16 harvesters
select (COUNT(*)/20)+1 as FieldsPerHarvester  from [weibo].[dbo].[HEXAGONPOINTS] Where [MainlandChina]=1;


-- how many fields are taken?
select COUNT(*) from [weibo].[dbo].[HEXAGONPOINTS] Where [taken]=1;
select COUNT(*) from [weibo].[dbo].[HEXAGONPOINTS] Where [MainlandChina]=1;
Select COUNT(*) from [weibo].[dbo].[HEXAGONPOINTS] Where [TimesHarvested]<1 AND [MainlandChina]=1;

update  [weibo].[dbo].[HEXAGONPOINTS] 
set [ratio]=0.99 
where [TimesHarvested]<1 AND [MainlandChina]=1;

-- SUMs, average insert and ratio
select sum([TimesHarvested]) as 'SUM_TimesHarvested', 
	   sum([TotalCollected]) as 'SUM_TotalCollected', 
	   sum([TotalInserted]) as 'SUM_TotalInserted',
	   CONCAT(Cast((sum([TotalInserted]) / CAST(sum([TotalCollected]) AS DECIMAL (12,2)))*100 as decimal(4,2)),'%')  as 'Insert success',
	   150*50*20*24*Cast((sum([TotalInserted]) / CAST(sum([TotalCollected]) AS DECIMAL (12,2))) as decimal(4,2)) as 'Prediction for next 24 hours'
from [weibotest2].[dbo].[HEXAGONPOINTS];

select top 1000000 [idNearByTimeLine] from weibo.dbo.NBT2 Where [location] IS NULL;

Execute weibo.dbo.CountAllMessages;
-- Create SPATIAL INDEX IDX_location ON weibo.dbo.NBT2(location) USING GEOGRAPHY_AUTO_GRID with (MAXDOP = 4);

select count([idNearByTimeLine]) from weibotest2.dbo.NBT4;

113.460 E-113.846E; 34.606 N-34.909 N

-- select by bounding box
select * Into weiboDEV.dbo.GEOminimalZhengzhou_2 from weiboDEV.dbo.GEOminimal 
where [WGSLongitudeY]>=113.460
AND [WGSLongitudeY]<=113.846
AND [WGSLatitudeX]>=34.606
AND [WGSLatitudeX]<=34.909;

-- Select Points in Polygon (boundingbox of any Polygon is created)
SELECT COUNT(*) FROM weiboDEV.dbo.GEOminimal Where location.STWithin(( Select geography::STPolyFromText(geometry::UnionAggregate ( geometry::STGeomFromText(cast([Shape] as varchar(max)), 4326)  ).STEnvelope().STAsText(),4326) FROM [weiboDEV].[dbo].[GADM_CHN_ADM2] WHERE OBJECTID = 262)) = 1;



-- select by bounding box
select top 1000000 [idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY] from weiboDEV.dbo.GEOminimal 
where [WGSLongitudeY]>=113.460
AND [WGSLongitudeY]<=113.846
AND [WGSLatitudeX]>=34.606
AND [WGSLatitudeX]<=34.848
AND location.STGeometryType() = 'POINT'
;

select [msgID],[msgtext] Into weiboDEV.dbo.MSGTEXTminimal from weibotest2.dbo.NBT4;


select top 100 [createdAT],[msgID],[userID],[location] from weiboDEV.dbo.GEOminimal 



SELECT TOP 10 [idNearByTimeLine],[geoLAT],[geoLOG] FROM [weibo].[dbo].[NBT2] Where [location] is NULL;


truncate table [weiboDEV].[dbo].[ShanghaiADM2_262];
SET IDENTITY_INSERT [weiboDEV].[dbo].[GEOminimal_foo] ON;
-- Select Points in Polygon (Geography)

DECLARE @ID INT = 3019;
DECLARE @Shape GEOGRAPHY = (select [Shape] from weiboDEV.[dbo].[GADM_CHN_ADM3_SINGLE] where OBJECTID=@ID);
-- DECLARE @SQLString NVARCHAR(500)= N'SELECT INTO [weiboDEV].[dbo].[ShanghaiADM2_262] FROM weiboDEV.dbo.GEOminimal WHERE location.STWithin(@Shape) = 1';
-- DECLARE @SQLString2 NVARCHAR(500)= N'Insert INTO [weiboDEV].[dbo].[ShanghaiADM2_262] ([idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location]) SELECT * FROM weiboDEV.dbo.GEOminimal WHERE location.STWithin(@Shape) = 1';
DECLARE @SQLString2 NVARCHAR(500)= N'INSERT INTO [weiboDEV].[dbo].[GEOminimal_foo]([idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location],[AMD3_ID]) SELECT [idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location] , @ID AS AMD3_ID FROM [weiboDEV].[dbo].[GEOminimal] WHERE ([location]).STWithin(@Shape) = 1;';
DECLARE @ParmDefinition NVARCHAR(500) = N'@ID INT, @Shape geography';
EXECUTE sp_executesql @SQLString2, @ParmDefinition, @ID, @Shape;


SELECT top 10 [msgID],[location], 10 AS AMD3_ID FROM [weiboDEV].[dbo].[GEOminimal]


 