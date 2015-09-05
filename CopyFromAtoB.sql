/****** Script for SelectTopNRows command from SSMS  ******/
SET IDENTITY_INSERT [weiboDEV].[dbo].[GEOminimal]  ON;
Insert Into [weiboDEV].[dbo].[GEOminimal] 
(		[idNearByTimeLine],
		[createdAT],
		[msgID],
		[userID],
		[WGSLatitudeX],
		[WGSLongitudeY],
		[location]
      )
Select
      	[idNearByTimeLine],
		[createdAT],
		[msgID],
		[userID],
		[WGSLatitudeX],
		[WGSLongitudeY],
		[location]
FROM [weibotest2].[dbo].[NBT2]
SET IDENTITY_INSERT [weiboDEV].[dbo].[GEOminimal]  OFF;



