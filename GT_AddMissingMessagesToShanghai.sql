

Select
	*
INTO foo
FROM 
	-- the original points (use already subsetted Points)
	[dbo].[NBT4_exact_copy_GEO] as point WITH(nolock,INDEX([SpatialIndex-20150619-114940]))
JOIN 
	-- the street block layer
	[SH_AREATOADD] as polygon
ON 
	point.location.STIntersects(polygon.Shape) =1

	Select * from foo

Select COUNT(msgID) from [dbo].[Points_Shanghai_262]
	--11794007
	--11798607

INSERT INTO [dbo].[Points_Shanghai_262] (
		[idNearByTimeLine]
      ,[msgID]
      ,[userID]
      ,[createdAT]
      ,[WGSLatitudeX]
      ,[WGSLongitudeY]
      ,[location]
      ,[OBJECTID]
	  )  SELECT [idNearByTimeLine]
      ,[msgID]
      ,[userID]
      ,[createdAT]
      ,[WGSLatitudeX]
      ,[WGSLongitudeY]
      ,[location]
      ,[OBJECTID] FROM foo