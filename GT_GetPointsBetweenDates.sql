USE 
	weiboDEV
Go
SELECT 
	[userID]
    ,Count([msgID]) AS messagecount
from 
	[dbo].[Points_Shanghai_262]
GROUP BY
	[userID]
ORDER BY
	messagecount DESC


3,629,865

USE 
	weiboDEV
GO
SELECT 
	Count([dbo].[Points_Shanghai_262].[msgID]) AS messagecount
FROM 
	[dbo].[Points_Shanghai_262]
JOIN
	[dbo].[NBT4_exact_copy]
ON
	[dbo].[Points_Shanghai_262].[msgID] = [dbo].[NBT4_exact_copy].[msgID]
WHERE
	[dbo].[Points_Shanghai_262].[createdAT] > '2014.1.1'
	AND
	[dbo].[Points_Shanghai_262].[createdAT] < '2014.6.1'
	AND
	[userprovince] = 31




USE 
	weiboDEV
GO
SELECT 
TOP 100
	[dbo].[NBT4_exact_copy].userprovince
FROM 
	[dbo].[Points_Shanghai_262]
JOIN
	[dbo].[NBT4_exact_copy]
ON
	[dbo].[Points_Shanghai_262].[msgID] = [dbo].[NBT4_exact_copy].[msgID]



