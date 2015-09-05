use weiboDEV
GO
DECLARE @oid INT = 1036;
SELECT
[dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID,
[dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID, 
createdAT
from [dbo].[LINK_Points_Shanghai_262_to_OID_OSM]
Join [dbo].[Points_Shanghai_262]
ON [dbo].[Points_Shanghai_262].msgID = [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID
Where [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID = @oid

--Histogram by 15 minutes
use weiboDEV
GO
DECLARE @oid INT = 18986;
SELECT
RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) AS HHMM,
count([dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID) as NumberOfMessages
from [dbo].[LINK_Points_Shanghai_262_to_OID_OSM]
Join [dbo].[Points_Shanghai_262]
ON [dbo].[Points_Shanghai_262].msgID = [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID
Where [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID = @oid
Group by RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2)
Order by RIGHT(100 + DATEPART(HOUR, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) + RIGHT(100 + DATEPART(MINUTE, dateadd(minute, datediff(minute,0,dateadd(hour,8,createdAT)) / 15 * 15, 0)) , 2) ASC


--Histogram by 60 minutes
use weiboDEV
GO
DECLARE @oid INT = 24015;
SELECT
RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)), 2) AS HH,
count([dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID) as NumberOfMessages
from [dbo].[LINK_Points_Shanghai_262_to_OID_OSM]
Join [dbo].[Points_Shanghai_262]
ON [dbo].[Points_Shanghai_262].msgID = [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].msgID
Where [dbo].[LINK_Points_Shanghai_262_to_OID_OSM].OBJECTID = @oid
Group by RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)), 2)
Order by RIGHT(100 + DATEPART(HOUR, dateadd(hour,8,createdAT)), 2) ASC


7218
7223
7231
7232
7234
7245
7259
7265
7271
7275
7280
7281
7294
7300
7332
7368
7412
7442
7444
7470
7473
7506
7536
7565
7691
7762
7830
7937
8045
8167
8215
8328
8407
8408
8410
8486
8487
8488
8496
8506
8508
8511
8513
8579
8612
8628
8637
8648
8654
8678
8920
8937
9650
9808

