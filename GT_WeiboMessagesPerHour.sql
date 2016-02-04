DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT]) AS HOUR
   ,COUNT(LINK1.[msgID]) AS TotalMessageCount
INTO
	STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
JOIN
	[dbo].[NBT4_exact_copy] as AllAttributes -- only this one has userprovince information
ON
	LINK1.msgID = AllAttributes.msgID
WHERE
	AllAttributes.userprovince = 31
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC

SELECT * FROM STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp1
SELECT   [OBJECTID]
		,[201206] AS '201206_TouristsMessageCount'
		,[201207] AS '201207_TouristsMessageCount'
		,[201208] AS '201208_TouristsMessageCount'
		,[201209] AS '201209_TouristsMessageCount'
		,[201210] AS '201210_TouristsMessageCount'
		,[201211] AS '201211_TouristsMessageCount'
		,[201212] AS '201212_TouristsMessageCount'
		,[201301] AS '201301_TouristsMessageCount'
		,[201302] AS '201302_TouristsMessageCount'
		,[201303] AS '201303_TouristsMessageCount'
		,[201304] AS '201304_TouristsMessageCount'
		,[201305] AS '201305_TouristsMessageCount'
		,[201306] AS '201306_TouristsMessageCount'
		,[201307] AS '201307_TouristsMessageCount'
		,[201308] AS '201308_TouristsMessageCount'
		,[201309] AS '201309_TouristsMessageCount'
		,[201310] AS '201310_TouristsMessageCount'
		,[201311] AS '201311_TouristsMessageCount'
		,[201312] AS '201312_TouristsMessageCount'
		,[201401] AS '201401_TouristsMessageCount'
		,[201402] AS '201402_TouristsMessageCount'
		,[201403] AS '201403_TouristsMessageCount'
		,[201404] AS '201404_TouristsMessageCount'
		,[201405] AS '201405_TouristsMessageCount'
		,[201406] AS '201406_TouristsMessageCount'
		,[201407] AS '201407_TouristsMessageCount'
		,[201408] AS '201408_TouristsMessageCount'
		,[201409] AS '201409_TouristsMessageCount'
		,[201410] AS '201410_TouristsMessageCount'
		,[201411] AS '201411_TouristsMessageCount'
		,[201412] AS '201412_TouristsMessageCount'
		,[201501] AS '201501_TouristsMessageCount'
		,[201502] AS '201502_TouristsMessageCount'
		,[201503] AS '201503_TouristsMessageCount'
		,[201504] AS '201504_TouristsMessageCount'
		,[201505] AS '201505_TouristsMessageCount'
		,[201506] AS '201506_TouristsMessageCount'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		,D.TouristsMessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(TouristsMessageCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp1

DROP TABLE
	temp2
SELECT 
	[OBJECTID]
	,[201206] AS '201206_TouristsDistinctUserCount'
	,[201207] AS '201207_TouristsDistinctUserCount'
	,[201208] AS '201208_TouristsDistinctUserCount'
	,[201209] AS '201209_TouristsDistinctUserCount'
	,[201210] AS '201210_TouristsDistinctUserCount'
	,[201211] AS '201211_TouristsDistinctUserCount'
	,[201212] AS '201212_TouristsDistinctUserCount'
	,[201301] AS '201301_TouristsDistinctUserCount'
	,[201302] AS '201302_TouristsDistinctUserCount'
	,[201303] AS '201303_TouristsDistinctUserCount'
	,[201304] AS '201304_TouristsDistinctUserCount'
	,[201305] AS '201305_TouristsDistinctUserCount'
	,[201306] AS '201306_TouristsDistinctUserCount'
	,[201307] AS '201307_TouristsDistinctUserCount'
	,[201308] AS '201308_TouristsDistinctUserCount'
	,[201309] AS '201309_TouristsDistinctUserCount'
	,[201310] AS '201310_TouristsDistinctUserCount'
	,[201311] AS '201311_TouristsDistinctUserCount'
	,[201312] AS '201312_TouristsDistinctUserCount'
	,[201401] AS '201401_TouristsDistinctUserCount'
	,[201402] AS '201402_TouristsDistinctUserCount'
	,[201403] AS '201403_TouristsDistinctUserCount'
	,[201404] AS '201404_TouristsDistinctUserCount'
	,[201405] AS '201405_TouristsDistinctUserCount'
	,[201406] AS '201406_TouristsDistinctUserCount'
	,[201407] AS '201407_TouristsDistinctUserCount'
	,[201408] AS '201408_TouristsDistinctUserCount'
	,[201409] AS '201409_TouristsDistinctUserCount'
	,[201410] AS '201410_TouristsDistinctUserCount'
	,[201411] AS '201411_TouristsDistinctUserCount'
	,[201412] AS '201412_TouristsDistinctUserCount'
	,[201501] AS '201501_TouristsDistinctUserCount'
	,[201502] AS '201502_TouristsDistinctUserCount'
	,[201503] AS '201503_TouristsDistinctUserCount'
	,[201504] AS '201504_TouristsDistinctUserCount'
	,[201505] AS '201505_TouristsDistinctUserCount'
	,[201506] AS '201506_TouristsDistinctUserCount'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,concat(D.[YEAR],FORMAT(D.[MONTH],'0#')) AS YYYYMM
		--,D.MessageCount
		,D.TouristsDistinctUserCount
	FROM
		STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH_rowformat as D
) src
pivot
(
  sum(TouristsDistinctUserCount)
  for YYYYMM in ([201206],[201207],[201208],[201209],[201210],[201211],[201212],[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312],[201401],[201402],[201403],[201404],[201405],[201406],[201407],[201408],[201409],[201410],[201411],[201412],[201501],[201502],[201503],[201504],[201505],[201506])
) piv;
SELECT * FROM temp2

DROP TABLE
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
SELECT 
		 A.[OBJECTID]
		,A.[201206_TouristsMessageCount]
		,A.[201207_TouristsMessageCount]
		,A.[201208_TouristsMessageCount]
		,A.[201209_TouristsMessageCount]
		,A.[201210_TouristsMessageCount]
		,A.[201211_TouristsMessageCount]
		,A.[201212_TouristsMessageCount]
		,A.[201301_TouristsMessageCount]
		,A.[201302_TouristsMessageCount]
		,A.[201303_TouristsMessageCount]
		,A.[201304_TouristsMessageCount]
		,A.[201305_TouristsMessageCount]
		,A.[201306_TouristsMessageCount]
		,A.[201307_TouristsMessageCount]
		,A.[201308_TouristsMessageCount]
		,A.[201309_TouristsMessageCount]
		,A.[201310_TouristsMessageCount]
		,A.[201311_TouristsMessageCount]
		,A.[201312_TouristsMessageCount]
		,A.[201401_TouristsMessageCount]
		,A.[201402_TouristsMessageCount]
		,A.[201403_TouristsMessageCount]
		,A.[201404_TouristsMessageCount]
		,A.[201405_TouristsMessageCount]
		,A.[201406_TouristsMessageCount]
		,A.[201407_TouristsMessageCount]
		,A.[201408_TouristsMessageCount]
		,A.[201409_TouristsMessageCount]
		,A.[201410_TouristsMessageCount]
		,A.[201411_TouristsMessageCount]
		,A.[201412_TouristsMessageCount]
		,A.[201501_TouristsMessageCount]
		,A.[201502_TouristsMessageCount]
		,A.[201503_TouristsMessageCount]
		,A.[201504_TouristsMessageCount]
		,A.[201505_TouristsMessageCount]
		,A.[201506_TouristsMessageCount]
		,B.[201206_TouristsDistinctUserCount]
		  ,B.[201207_TouristsDistinctUserCount]
		  ,B.[201208_TouristsDistinctUserCount]
		  ,B.[201209_TouristsDistinctUserCount]
		  ,B.[201210_TouristsDistinctUserCount]
		  ,B.[201211_TouristsDistinctUserCount]
		  ,B.[201212_TouristsDistinctUserCount]
		  ,B.[201301_TouristsDistinctUserCount]
		  ,B.[201302_TouristsDistinctUserCount]
		  ,B.[201303_TouristsDistinctUserCount]
		  ,B.[201304_TouristsDistinctUserCount]
		  ,B.[201305_TouristsDistinctUserCount]
		  ,B.[201306_TouristsDistinctUserCount]
		  ,B.[201307_TouristsDistinctUserCount]
		  ,B.[201308_TouristsDistinctUserCount]
		  ,B.[201309_TouristsDistinctUserCount]
		  ,B.[201310_TouristsDistinctUserCount]
		  ,B.[201311_TouristsDistinctUserCount]
		  ,B.[201312_TouristsDistinctUserCount]
		  ,B.[201401_TouristsDistinctUserCount]
		  ,B.[201402_TouristsDistinctUserCount]
		  ,B.[201403_TouristsDistinctUserCount]
		  ,B.[201404_TouristsDistinctUserCount]
		  ,B.[201405_TouristsDistinctUserCount]
		  ,B.[201406_TouristsDistinctUserCount]
		  ,B.[201407_TouristsDistinctUserCount]
		  ,B.[201408_TouristsDistinctUserCount]
		  ,B.[201409_TouristsDistinctUserCount]
		  ,B.[201410_TouristsDistinctUserCount]
		  ,B.[201411_TouristsDistinctUserCount]
		  ,B.[201412_TouristsDistinctUserCount]
		  ,B.[201501_TouristsDistinctUserCount]
		  ,B.[201502_TouristsDistinctUserCount]
		  ,B.[201503_TouristsDistinctUserCount]
		  ,B.[201504_TouristsDistinctUserCount]
		  ,B.[201505_TouristsDistinctUserCount]
		  ,B.[201506_TouristsDistinctUserCount]
INTO
	STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID
SELECT * FROM STEET_BLOCK_TouristsTotalMessageCount_and_TouristsDistinctUserCount_PER_MONTH

-- f LINK STREET BLOCK to nearest CENSUS POINT
SELECT 
	SB.OBJECTID
   ,SB.JOIN_FID as  CensusPointID
INTO
	SHANGHAI_LINK_STREETBLOCK_OBJECTID_to_CENSUSPOINTOBJECTID
FROM
	[dbo].[ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA] as SB