-- Step by step Guide to create weiboDEV from RAW data in weibotest2.dbo.NBT4

use weibotest2;
Select Count(*) FROM NBT4;
use weibotest2;

Select Count(*) FROM NBT2;

-- Make an exact copy of weibotest2.dbo.NBT4

Select * 
Into weiboDEV.dbo.NBT4_exact_copy 
from weibotest2.dbo.NBT4;
--(106679458 row(s) affected)  LONG RUNTIME 41mins.


-- Reduce to smaller Table with only the important fields
use weiboDEV
Select [idNearByTimeLine],[msgID],[userID],[createdAT],[WGSLatitudeX],[WGSLongitudeY],[location]
Into weiboDEV.dbo.NBT4_exact_copy_GEO
FROM weiboDEV.dbo.NBT4_exact_copy;
--(106679458 row(s) affected) RUNTIME 29mins.

-- create index on NBT4_exact_copy_GEO
USE [weiboDEV]
GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20150615-165659] ON [dbo].[NBT4_exact_copy_GEO]
(
	[msgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-- Stored procedure to select points by Polygon IN ID

CREATE PROCEDURE test @ID INT 
AS 

SET IDENTITY_INSERT [weiboDEV].[dbo].[GEOminimal_foo] ON;
-- Select Points in Polygon (Geography)

-- DECLARE @ID INT = 3019;
DECLARE @Shape GEOGRAPHY = (select [Shape] from weiboDEV.[dbo].[GADM_CHN_ADM3_SINGLE] where OBJECTID=@ID);
-- DECLARE @SQLString NVARCHAR(500)= N'SELECT INTO [weiboDEV].[dbo].[ShanghaiADM2_262] FROM weiboDEV.dbo.GEOminimal WHERE location.STWithin(@Shape) = 1';
-- DECLARE @SQLString2 NVARCHAR(500)= N'Insert INTO [weiboDEV].[dbo].[ShanghaiADM2_262] ([idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location]) SELECT * FROM weiboDEV.dbo.GEOminimal WHERE location.STWithin(@Shape) = 1';
DECLARE @SQLString2 NVARCHAR(500)= N'INSERT INTO [weiboDEV].[dbo].[GEOminimal_foo]([idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location],[AMD3_ID]) SELECT [idNearByTimeLine],[createdAT],[msgID],[userID],[WGSLatitudeX],[WGSLongitudeY],[location] , @ID AS AMD3_ID FROM [weiboDEV].[dbo].[GEOminimal] WHERE ([location]).STWithin(@Shape) = 1;';
DECLARE @ParmDefinition NVARCHAR(500) = N'@ID INT, @Shape geography';
EXECUTE sp_executesql @SQLString2, @ParmDefinition, @ID, @Shape;


GO

exec test @ID=1
 


 USE [weiboDEV]
GO

/****** Object:  Index [PK__GEOminimal__C94A0D69DA7650BF]    Script Date: 6/17/2015 1:59:27 PM ******/
ALTER TABLE [dbo].[NBT4_exact_copy_GEO] ADD  CONSTRAINT [PK__NBT4_exact_copy_GEO] PRIMARY KEY CLUSTERED 
(
	[msgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO







-- Select based on AMD ID_2
use weiboDEV
SELECT top 0 * into dbo.Beijing FROM [dbo].[Shanghai_262]

--count number of messages in ADM ID2
Select COUNT(*) FROM [msgID_to_GADM]
use weiboDEV
GO
Select CONCAT( [NAME_2],'_',[ID_2]) as idname, COUNT(*) as NbrOfMsg 
FROM [msgID_to_GADM] 
Group by CONCAT( [NAME_2],'_',[ID_2])
ORDER BY COUNT(*) DESC


-- Select by ID2 
declare @ID2 int = 18
Select [idNearByTimeLine],[dbo].[msgID_to_GADM].[msgID],[userID],[createdAT],[WGSLatitudeX],[WGSLongitudeY],[location],[msgID_to_GADM].[ID_2]
into [dbo].[Beijing_18]
From [dbo].[NBT4_exact_copy_GEO] as data
Join [dbo].[msgID_to_GADM]
on data.msgID = [dbo].[msgID_to_GADM].msgID
WHERE [dbo].[msgID_to_GADM].[ID_2] =@ID2;
--OR
EXEC [dbo].[SelectPointsByADM2ID] 270, 'Taiyuan'


-- Select for LinFang
use
weiboDEV
go
declare @ID2 int = 262
Select top 100 
[idNearByTimeLine],
[createdAT],
DATEDIFF(SECOND, '19700101', createdAT) as 'createdATUnixTime',
[msgID],
[msgmid],
[msgtext],
[msgin_reply_to_status_id],
[msgin_reply_to_user_id],
[msgin_reply_to_screen_name],
[msgfavorited],
[msgsource],
[geoTYPE],
[distance],
[userID],
[userscreen_name],
[userprovince],
[usercity],
[userlocation],
[userdescription],
[userfollowers_count],
[userfriends_count],
[userstatuses_count],
[userfavourites_count],
[usercreated_at],
[usergeo_enabled],
[userverified],
[userbi_followers_count],
[userlang],
[userclient_mblogid],
[location].Lat as WGS84Latitude,
[location].Long as WGS84Longitude,
[NAME_1],
[NAME_2],
[NAME_3]
From [dbo].[NBT4_exact_copy] as data
Join [dbo].[msgID_to_GADM]
on data.msgID = [dbo].[msgID_to_GADM].[messageID]
WHERE [dbo].[msgID_to_GADM].[ID_2] = @ID2;





 
-- create a datetable http://www.kodyaz.com/t-sql/create-date-time-intervals-table-in-sql-server.aspx
declare @date datetime = '20120630'
SELECT
 number+1 No,
 dateadd(dd,number,@date) [date]
 into datetable
FROM master..spt_values
WHERE
 Type = 'P'
 AND dateadd(dd,number,@date) < dateadd(yy,3,@date)
ORDER BY Number


-- create histogram
use weiboDEV
GO
drop table #foo
Select count(msgID) as NbrOfMsg, Convert(datetime, DATEDIFF(DAY, 0, [createdAT])) as dateday 
into #foo
from [dbo].[NBT4_exact_copy_GEO]
group by Convert(datetime, DATEDIFF(DAY, 0, [createdAT]))
order by Convert(datetime, DATEDIFF(DAY, 0, [createdAT]))
Select * from #foo order by dateday asc
declare @sd datetime = (Select min(dateday) from #foo)
declare @ed datetime = (Select max(dateday) from #foo)

--SELECT a.IndividualDate,NbrOfMsg
DROP TABLE #foo2
SELECT CONVERT(VARCHAR(10),CONVERT(datetime, a.IndividualDate,   1), 112) AS dateday, datename(dw,a.IndividualDate) as WEEKDAYname,  NbrOfMsg
into #foo2
FROM DateRange('d', CONVERT(VARCHAR(10),CONVERT(datetime, @sd,   1), 112), CONVERT(VARCHAR(10),CONVERT(datetime, @ed,   1), 112)) as a 
LEFT JOIN #foo as b on a.IndividualDate = b.dateday
order by a.IndividualDate


ALTER TABLE #foo2
ADD CONSTRAINT col_c1_def DEFAULT 0 FOR NbrOfMsg

UPDATE #foo2
SET NbrOfMsg = 0
WHERE NbrOfMsg IS NULL

select * 
Into MessagesPerDayAll
from #foo2
order by dateday asc


-- CONVERT GEOGRAPHY TO GEOMETRY
Update dbo.Shanghai_262 
Set locationgeom = geometry:: STGeomFromText('POINT(' + CAST(CAST(location.Long AS decimal(17, 13)) AS varchar) + ' ' + CAST(CAST(location.Lat AS decimal(17, 13)) AS varchar) + ')', 4326)
--where msgID = 3154515945889755


-- create an empty table like table X
use weiboDEV
GO
sp_rename [TempTriangleDotNetOutput], [Shanghai_262_all_msg_Edges];
use weiboDEV
GO
SELECT top 0 * into TempTriangleDotNetOutput FROM Shanghai_262_all_msg_Edges

-- give the mean of a column
use weiboDEV
GO
Select AVG([edgeLength]) FROM [dbo].[Shanghai_262_all_msg_Edges]


--classify by HeadTail Breaks
use weiboDEV
GO
DECLARE @average smallint = (Select AVG([edgeLength]) FROM [dbo].[Shanghai_262_all_msg_Edges] Where [HeadTailBreakClass] = 0)
Update [dbo].[Shanghai_262_all_msg_Edges]
SET [HeadTailBreakClass] = 1
Where [edgeLength] < @average AND [HeadTailBreakClass] = 0

Update [dbo].[Shanghai_262_all_msg_Edges]
SET [HeadTailBreakClass] = 0

Select count(*),[HeadTailBreakClass] from [dbo].[Shanghai_262_all_msg_Edges] group by [HeadTailBreakClass]

Select * into FOO_CLASS1 from [dbo].[Shanghai_262_all_msg_Edges] Where [HeadTailBreakClass]=1;

Select [edgeLength],Count(*) from [dbo].[Shanghai_262_all_msg_Edges] group by [edgeLength] order by [edgeLength] asc



--classify voronoi polygon area by HeadTail Breaks
use weiboDEV
GO
Select AVG([Area]) FROM [dbo].[Shanghai_262_DISSOLVED_THIESSEN]

Update [dbo].[Shanghai_262_DISSOLVED_THIESSEN]
SET [HTclass] = 0


use weiboDEV
GO
DECLARE @class int =7;
DECLARE @average float = (Select AVG([AreaSQM]) FROM [dbo].[Shanghai_262_DISSOLVED_THIESSEN] Where [HTclass] =@class-1)
Update [dbo].[Shanghai_262_DISSOLVED_THIESSEN]
SET [HTclass] = @class
Where [AreaSQM] < @average AND [HTclass] = @class-1;

Select [HTclass],count(*) as Counted from [dbo].[Shanghai_262_DISSOLVED_THIESSEN] group by [HTclass];

Select MAX([AreaSQM]) FROM [dbo].[Shanghai_262_DISSOLVED_THIESSEN]


-- SELECT BY AMD2 or AMD3
EXEC [SelectPointsByADM2ID] 175, 'Zhenjiang'
EXEC [SelectPointsByADM3ID] 1467, 'Erenhot'





SELECT        COUNT_BIG(*) AS CountMsg,dbo.msgID_to_GADM.NAME_2, CONVERT(VARCHAR(10),CONVERT(datetime, dbo.NBT4_exact_copy_GEO.createdAT,   1), 112) as DateDay
FROM            dbo.NBT4_exact_copy_GEO LEFT OUTER JOIN
                         dbo.msgID_to_GADM ON dbo.NBT4_exact_copy_GEO.msgID = dbo.msgID_to_GADM.messageID
GROUP BY CONVERT(VARCHAR(10),CONVERT(datetime, dbo.NBT4_exact_copy_GEO.createdAT,   1), 112),dbo.msgID_to_GADM.NAME_2



