DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS ResidentsTotalMessageCount
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat
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


				SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp1
SELECT   
     [OBJECTID]
    ,[00] AS 'ResTMsgCnt_00'
    ,[01] AS 'ResTMsgCnt_01'
    ,[02] AS 'ResTMsgCnt_02'
    ,[03] AS 'ResTMsgCnt_03'
    ,[04] AS 'ResTMsgCnt_04'
    ,[05] AS 'ResTMsgCnt_05'
    ,[06] AS 'ResTMsgCnt_06'
    ,[07] AS 'ResTMsgCnt_07'
    ,[08] AS 'ResTMsgCnt_08'
    ,[09] AS 'ResTMsgCnt_09'
    ,[10] AS 'ResTMsgCnt_10'
    ,[11] AS 'ResTMsgCnt_11'
    ,[12] AS 'ResTMsgCnt_12'
    ,[13] AS 'ResTMsgCnt_13'
    ,[14] AS 'ResTMsgCnt_14'
    ,[15] AS 'ResTMsgCnt_15'
    ,[16] AS 'ResTMsgCnt_16'
    ,[17] AS 'ResTMsgCnt_17'
    ,[18] AS 'ResTMsgCnt_18'
    ,[19] AS 'ResTMsgCnt_19'
    ,[20] AS 'ResTMsgCnt_20'
    ,[21] AS 'ResTMsgCnt_21'
    ,[22] AS 'ResTMsgCnt_22'
    ,[23] AS 'ResTMsgCnt_23'
INTO temp1
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.ResidentsTotalMessageCount
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_ResidentsTotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(ResidentsTotalMessageCount)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;


				SELECT * FROM temp1



DROP TABLE
	STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS TouristTotalMessageCount
INTO
	STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat
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
	AllAttributes.userprovince <> 31 -- all messages from users that do not state provicen 31 in their profile
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC


				SELECT * FROM STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp2
SELECT 
	 [OBJECTID]
	,[00] AS 'TouTMsgCnt_00'
	,[01] AS 'TouTMsgCnt_01'
	,[02] AS 'TouTMsgCnt_02'
	,[03] AS 'TouTMsgCnt_03'
	,[04] AS 'TouTMsgCnt_04'
	,[05] AS 'TouTMsgCnt_05'
	,[06] AS 'TouTMsgCnt_06'
	,[07] AS 'TouTMsgCnt_07'
	,[08] AS 'TouTMsgCnt_08'
	,[09] AS 'TouTMsgCnt_09'
	,[10] AS 'TouTMsgCnt_10'
	,[11] AS 'TouTMsgCnt_11'
	,[12] AS 'TouTMsgCnt_12'
	,[13] AS 'TouTMsgCnt_13'
	,[14] AS 'TouTMsgCnt_14'
	,[15] AS 'TouTMsgCnt_15'
	,[16] AS 'TouTMsgCnt_16'
	,[17] AS 'TouTMsgCnt_17'
	,[18] AS 'TouTMsgCnt_18'
	,[19] AS 'TouTMsgCnt_19'
	,[20] AS 'TouTMsgCnt_20'
	,[21] AS 'TouTMsgCnt_21'
	,[22] AS 'TouTMsgCnt_22'
	,[23] AS 'TouTMsgCnt_23'
INTO temp2
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.TouristTotalMessageCount
	FROM
		STEET_BLOCK_TouristTotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(TouristTotalMessageCount)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;


				SELECT * FROM temp2


DROP TABLE
	STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat
SELECT
	LINK1.OBJECTID
   ,FORMAT(DATEPART(HOUR, POINTS.[createdAT]),'0#') AS HOUR
   ,COUNT(LINK1.[msgID]) AS TotalMessageCountPerHour
INTO
	STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat
FROM
	SHANGHAI_262_LINK_msgID_userID_TO_STREETBLOCK_OBJECTID AS LINK1
JOIN
	[dbo].[Points_Shanghai_262] AS POINTS
ON
	LINK1.msgID = POINTS.msgID
GROUP BY
	LINK1.OBJECTID
   ,DATEPART(HOUR, POINTS.[createdAT])
ORDER BY
	LINK1.OBJECTID ASC
   ,DATEPART(HOUR, POINTS.[createdAT]) ASC


				SELECT * FROM STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat


DROP TABLE
	temp3
SELECT   
     [OBJECTID]
	,[00] AS 'TotalMsgCnt_00'
	,[01] AS 'TotalMsgCnt_01'
	,[02] AS 'TotalMsgCnt_02'
	,[03] AS 'TotalMsgCnt_03'
	,[04] AS 'TotalMsgCnt_04'
	,[05] AS 'TotalMsgCnt_05'
	,[06] AS 'TotalMsgCnt_06'
	,[07] AS 'TotalMsgCnt_07'
	,[08] AS 'TotalMsgCnt_08'
	,[09] AS 'TotalMsgCnt_09'
	,[10] AS 'TotalMsgCnt_10'
	,[11] AS 'TotalMsgCnt_11'
	,[12] AS 'TotalMsgCnt_12'
	,[13] AS 'TotalMsgCnt_13'
	,[14] AS 'TotalMsgCnt_14'
	,[15] AS 'TotalMsgCnt_15'
	,[16] AS 'TotalMsgCnt_16'
	,[17] AS 'TotalMsgCnt_17'
	,[18] AS 'TotalMsgCnt_18'
	,[19] AS 'TotalMsgCnt_19'
	,[20] AS 'TotalMsgCnt_20'
	,[21] AS 'TotalMsgCnt_21'
	,[22] AS 'TotalMsgCnt_22'
	,[23] AS 'TotalMsgCnt_23'
INTO temp3
FROM 
(
	SELECT 
		D.OBJECTID
		,D.HOUR AS HOUR
		,D.TotalMessageCountPerHour
		--,D.DistinctUserCount
	FROM
		STEET_BLOCK_TotalMessageCount_PER_HOUR_rowformat as D
) src
pivot
(
  sum(TotalMessageCountPerHour)
  for HOUR in ([00],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
) piv;


				SELECT * FROM temp3



DROP TABLE
	STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR
SELECT 
		 A.[OBJECTID]
		,A.[ResTMsgCnt_00]
		,A.[ResTMsgCnt_01]
		,A.[ResTMsgCnt_02]
		,A.[ResTMsgCnt_03]
		,A.[ResTMsgCnt_04]
		,A.[ResTMsgCnt_05]
		,A.[ResTMsgCnt_06]
		,A.[ResTMsgCnt_07]
		,A.[ResTMsgCnt_08]
		,A.[ResTMsgCnt_09]
		,A.[ResTMsgCnt_10]
		,A.[ResTMsgCnt_11]
		,A.[ResTMsgCnt_12]
		,A.[ResTMsgCnt_13]
		,A.[ResTMsgCnt_14]
		,A.[ResTMsgCnt_15]
		,A.[ResTMsgCnt_16]
		,A.[ResTMsgCnt_17]
		,A.[ResTMsgCnt_18]
		,A.[ResTMsgCnt_19]
		,A.[ResTMsgCnt_20]
		,A.[ResTMsgCnt_21]
		,A.[ResTMsgCnt_22]
		,A.[ResTMsgCnt_23]
		,B.[TouTMsgCnt_00]
		,B.[TouTMsgCnt_01]
		,B.[TouTMsgCnt_02]
		,B.[TouTMsgCnt_03]
		,B.[TouTMsgCnt_04]
		,B.[TouTMsgCnt_05]
		,B.[TouTMsgCnt_06]
		,B.[TouTMsgCnt_07]
		,B.[TouTMsgCnt_08]
		,B.[TouTMsgCnt_09]
		,B.[TouTMsgCnt_10]
		,B.[TouTMsgCnt_11]
		,B.[TouTMsgCnt_12]
		,B.[TouTMsgCnt_13]
		,B.[TouTMsgCnt_14]
		,B.[TouTMsgCnt_15]
		,B.[TouTMsgCnt_16]
		,B.[TouTMsgCnt_17]
		,B.[TouTMsgCnt_18]
		,B.[TouTMsgCnt_19]
		,B.[TouTMsgCnt_20]
		,B.[TouTMsgCnt_21]
		,B.[TouTMsgCnt_22]
		,B.[TouTMsgCnt_23]
		,C.[TotalMsgCnt_00]
		,C.[TotalMsgCnt_01]
		,C.[TotalMsgCnt_02]
		,C.[TotalMsgCnt_03]
		,C.[TotalMsgCnt_04]
		,C.[TotalMsgCnt_05]
		,C.[TotalMsgCnt_06]
		,C.[TotalMsgCnt_07]
		,C.[TotalMsgCnt_08]
		,C.[TotalMsgCnt_09]
		,C.[TotalMsgCnt_10]
		,C.[TotalMsgCnt_11]
		,C.[TotalMsgCnt_12]
		,C.[TotalMsgCnt_13]
		,C.[TotalMsgCnt_14]
		,C.[TotalMsgCnt_15]
		,C.[TotalMsgCnt_16]
		,C.[TotalMsgCnt_17]
		,C.[TotalMsgCnt_18]
		,C.[TotalMsgCnt_19]
		,C.[TotalMsgCnt_20]
		,C.[TotalMsgCnt_21]
		,C.[TotalMsgCnt_22]
		,C.[TotalMsgCnt_23]
		
INTO
	STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR
FROM
	temp1 AS A 
JOIN
	temp2 AS B
ON 
	A.OBJECTID = B.OBJECTID
JOIN 
	temp3 AS C
ON
	A.OBJECTID = C.OBJECTID


				SELECT * FROM STEET_BLOCK_ResidentsTotalMessageCount_and_TouristTotalMessageCount_and_TotalMessageCount_PER_HOUR

