use weiboDEV
go
select distinct location.Lat, location.Long from (SELECT top 10000000 * from[dbo].[Points_Beijing_18]) as t

use weiboDEV
go
drop table clusters
Select ROW_NUMBER() OVER(ORDER BY msgID DESC) as ID
	 , msgID
	 , location
	 , CLUSTER.[Column 1] as cl1
	 , CLUSTER.[Column 2] as cl2
	 , CLUSTER.[Column 3] as cl3
INTO
	clusters
from [dbo].[NBT4_exact_copy_GEO] as ORIG
JOIN [dbo].[labels_matrix] as CLUSTER
ON ORIG.msgID = CLUSTER.[Column 0]