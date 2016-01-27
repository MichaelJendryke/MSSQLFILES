/****** Script for SelectTopNRows command from SSMS  ******/
use weiboDEV
go
SELECT
[dbo].[NBT4_MSGTEXTminimal].[msgID],
[dbo].[NBT4_MSGTEXTminimal].[msgtext],
geo.[userID],
geo.createdAT,
geo.[location]
FROM [weiboDEV].[dbo].[NBT4_MSGTEXTminimal]

JOIN [dbo].[NBT4_exact_copy_GEO] as geo
ON [dbo].[NBT4_MSGTEXTminimal].[msgID] = geo.[msgID]
WHERE [msgtext] LIKE N'%酷%' AND
				NOT [msgtext] LIKE N'%残酷%'