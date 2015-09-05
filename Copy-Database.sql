-- copy data between different databases

SELECT top 100 [idNearByTimeLine],[createdAT],[msgID],[msgtext],[distance],[userID],[userscreen_name],[userprovince],[usercity],[userlocation],[usercreated_at],[WGSLatitudeX],[WGSLongitudeY],[location]
INTO [weiboDEV].[dbo].[GEOsmall]
from [weibotest2].[dbo].[NBT2];

CREATE CLUSTERED INDEX cIDX ON [weiboDEV].[dbo].[GEOsmall] ([idNearByTimeLine]);

ALTER TABLE [weiboDEV].[dbo].[GEOsmall] ADD CONSTRAINT PK_idNearByTimeLine PRIMARY KEY CLUSTERED ([idNearByTimeLine]);

SET ANSI_PADDING ON;

Create SPATIAL INDEX IDX_location ON weiboDEV.dbo.GEOsmall(location) USING GEOGRAPHY_AUTO_GRID with (MAXDOP = 4);

Select count(*) from weibotest2.dbo.NBT2;