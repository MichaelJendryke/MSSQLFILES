-- STATISTICS FOR EVERY STREETBLOCK
USE 
	weiboDEV
GO
DROP TABLE 
	STACK_2_EQ_STREETBLOCKS
Select 
	 -- these are the columns of the final table 
	 SB.OBJECTID AS STREETBLOCKID
	,STACK2.PointCOUNT as PointCount
	,STACK2.PointCOUNT/SB.AREA AS PointDensity
	,STACK2.AvgCoh_20130416_20130508_1
	,STACK2.AvgCoh_20130416_20130621_2
	,STACK2.AvgCoh_20130508_20130621_3
	,STACK2.AvgCoh_20130508_20130713_4
	,STACK2.AvgCoh_20130621_20130917_5
	,STACK2.AvgCoh_20130713_20130917_6
	,STACK2.AvgCoh_20130917_20131214_7
	,STACK2.AvgCoh_20131214_20140312_8
	,STACK2.AvgCoh_20140312_20140517_9
	,STACK2.AvgCoh_20140802_20140517_10
	,STACK2.AvgCoh_20140802_20140915_11
	,STACK2.AvgCoh_20140802_20141029_12
	,STACK2.AvgCoh_20141029_20141223_13
	,STACK2.AvgCoh_20150401_20150515_14
	,STACK2.MaxCoh_20130416_20130508_1
	,STACK2.MaxCoh_20130416_20130621_2
	,STACK2.MaxCoh_20130508_20130621_3
	,STACK2.MaxCoh_20130508_20130713_4
	,STACK2.MaxCoh_20130621_20130917_5
	,STACK2.MaxCoh_20130713_20130917_6
	,STACK2.MaxCoh_20130917_20131214_7
	,STACK2.MaxCoh_20131214_20140312_8
	,STACK2.MaxCoh_20140312_20140517_9
	,STACK2.MaxCoh_20140802_20140517_10
	,STACK2.MaxCoh_20140802_20140915_11
	,STACK2.MaxCoh_20140802_20141029_12
	,STACK2.MaxCoh_20141029_20141223_13
	,STACK2.MaxCoh_20150401_20150515_14
	,STACK2.MinCoh_20130416_20130508_1
	,STACK2.MinCoh_20130416_20130621_2
	,STACK2.MinCoh_20130508_20130621_3
	,STACK2.MinCoh_20130508_20130713_4
	,STACK2.MinCoh_20130621_20130917_5
	,STACK2.MinCoh_20130713_20130917_6
	,STACK2.MinCoh_20130917_20131214_7
	,STACK2.MinCoh_20131214_20140312_8
	,STACK2.MinCoh_20140312_20140517_9
	,STACK2.MinCoh_20140802_20140517_10
	,STACK2.MinCoh_20140802_20140915_11
	,STACK2.MinCoh_20140802_20141029_12
	,STACK2.MinCoh_20141029_20141223_13
	,STACK2.MinCoh_20150401_20150515_14
	,STACK2.StDevCoh_20130416_20130508_1
	,STACK2.StDevCoh_20130416_20130621_2
	,STACK2.StDevCoh_20130508_20130621_3
	,STACK2.StDevCoh_20130508_20130713_4
	,STACK2.StDevCoh_20130621_20130917_5
	,STACK2.StDevCoh_20130713_20130917_6
	,STACK2.StDevCoh_20130917_20131214_7
	,STACK2.StDevCoh_20131214_20140312_8
	,STACK2.StDevCoh_20140312_20140517_9
	,STACK2.StDevCoh_20140802_20140517_10
	,STACK2.StDevCoh_20140802_20140915_11
	,STACK2.StDevCoh_20140802_20141029_12
	,STACK2.StDevCoh_20141029_20141223_13
	,STACK2.StDevCoh_20150401_20150515_14
	,STACK2.StDevPCoh_20130416_20130508_1
	,STACK2.StDevPCoh_20130416_20130621_2
	,STACK2.StDevPCoh_20130508_20130621_3
	,STACK2.StDevPCoh_20130508_20130713_4
	,STACK2.StDevPCoh_20130621_20130917_5
	,STACK2.StDevPCoh_20130713_20130917_6
	,STACK2.StDevPCoh_20130917_20131214_7
	,STACK2.StDevPCoh_20131214_20140312_8
	,STACK2.StDevPCoh_20140312_20140517_9
	,STACK2.StDevPCoh_20140802_20140517_10
	,STACK2.StDevPCoh_20140802_20140915_11
	,STACK2.StDevPCoh_20140802_20141029_12
	,STACK2.StDevPCoh_20141029_20141223_13
	,STACK2.StDevPCoh_20150401_20150515_14
	,SB.[Shape]
INTO
	STACK_2_EQ_STREETBLOCKS
FROM 
	[weiboDEV].[dbo].ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA SB
LEFT OUTER JOIN 
	(	SELECT 
			 [weiboDEV].[dbo].[STACK2_LINK_ID_to_STREETBLOOKID].[STREETBLOCKID]
			,COUNT([weiboDEV].[dbo].[STACK2_rfEQ].ID) AS PointCOUNT
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img1]) AS AvgCoh_20130416_20130508_1
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img2]) AS AvgCoh_20130416_20130621_2
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img3]) AS AvgCoh_20130508_20130621_3
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img4]) AS AvgCoh_20130508_20130713_4
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img5]) AS AvgCoh_20130621_20130917_5
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img6]) AS AvgCoh_20130713_20130917_6
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img7]) AS AvgCoh_20130917_20131214_7
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img8]) AS AvgCoh_20131214_20140312_8
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img9]) AS AvgCoh_20140312_20140517_9
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img10]) AS AvgCoh_20140802_20140517_10
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img11]) AS AvgCoh_20140802_20140915_11
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img12]) AS AvgCoh_20140802_20141029_12
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img13]) AS AvgCoh_20141029_20141223_13
			,AVG([weiboDEV].[dbo].[STACK2_rfEQ].[img14]) AS AvgCoh_20150401_20150515_14
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img1])  AS MaxCoh_20130416_20130508_1
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img2])  AS MaxCoh_20130416_20130621_2
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img3])  AS MaxCoh_20130508_20130621_3
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img4])  AS MaxCoh_20130508_20130713_4
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img5])  AS MaxCoh_20130621_20130917_5
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img6])  AS MaxCoh_20130713_20130917_6
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img7])  AS MaxCoh_20130917_20131214_7
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img8])  AS MaxCoh_20131214_20140312_8
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img9])  AS MaxCoh_20140312_20140517_9
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img10]) AS MaxCoh_20140802_20140517_10
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img11]) AS MaxCoh_20140802_20140915_11
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img12]) AS MaxCoh_20140802_20141029_12
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img13]) AS MaxCoh_20141029_20141223_13
			,MAX([weiboDEV].[dbo].[STACK2_rfEQ].[img14]) AS MaxCoh_20150401_20150515_14
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img1])  AS MinCoh_20130416_20130508_1
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img2])  AS MinCoh_20130416_20130621_2
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img3])  AS MinCoh_20130508_20130621_3
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img4])  AS MinCoh_20130508_20130713_4
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img5])  AS MinCoh_20130621_20130917_5
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img6])  AS MinCoh_20130713_20130917_6
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img7])  AS MinCoh_20130917_20131214_7
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img8])  AS MinCoh_20131214_20140312_8
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img9])  AS MinCoh_20140312_20140517_9
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img10]) AS MinCoh_20140802_20140517_10
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img11]) AS MinCoh_20140802_20140915_11
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img12]) AS MinCoh_20140802_20141029_12
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img13]) AS MinCoh_20141029_20141223_13
			,MIN([weiboDEV].[dbo].[STACK2_rfEQ].[img14]) AS MinCoh_20150401_20150515_14
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img1])  AS StDevCoh_20130416_20130508_1
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img2])  AS StDevCoh_20130416_20130621_2
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img3])  AS StDevCoh_20130508_20130621_3
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img4])  AS StDevCoh_20130508_20130713_4
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img5])  AS StDevCoh_20130621_20130917_5
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img6])  AS StDevCoh_20130713_20130917_6
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img7])  AS StDevCoh_20130917_20131214_7
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img8])  AS StDevCoh_20131214_20140312_8
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img9])  AS StDevCoh_20140312_20140517_9
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img10]) AS StDevCoh_20140802_20140517_10
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img11]) AS StDevCoh_20140802_20140915_11
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img12]) AS StDevCoh_20140802_20141029_12
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img13]) AS StDevCoh_20141029_20141223_13
			,STDEV([weiboDEV].[dbo].[STACK2_rfEQ].[img14]) AS StDevCoh_20150401_20150515_14
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img1])  AS StDevPCoh_20130416_20130508_1
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img2])  AS StDevPCoh_20130416_20130621_2
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img3])  AS StDevPCoh_20130508_20130621_3
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img4])  AS StDevPCoh_20130508_20130713_4
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img5])  AS StDevPCoh_20130621_20130917_5
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img6])  AS StDevPCoh_20130713_20130917_6
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img7])  AS StDevPCoh_20130917_20131214_7
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img8])  AS StDevPCoh_20131214_20140312_8
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img9])  AS StDevPCoh_20140312_20140517_9
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img10]) AS StDevPCoh_20140802_20140517_10
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img11]) AS StDevPCoh_20140802_20140915_11
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img12]) AS StDevPCoh_20140802_20141029_12
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img13]) AS StDevPCoh_20141029_20141223_13
			,STDEVP([weiboDEV].[dbo].[STACK2_rfEQ].[img14]) AS StDevPCoh_20150401_20150515_14
		FROM 
			[weiboDEV].[dbo].[STACK2_LINK_ID_to_STREETBLOOKID]
		JOIN 
			[weiboDEV].[dbo].[STACK2_rfEQ]
		ON
			[weiboDEV].[dbo].[STACK2_LINK_ID_to_STREETBLOOKID].[ID] = [weiboDEV].[dbo].[STACK2_rfEQ].[ID]
		GROUP BY 
			[weiboDEV].[dbo].[STACK2_LINK_ID_to_STREETBLOOKID].STREETBLOCKID
	) STACK2 ON (SB.OBJECTID=STACK2.STREETBLOCKID)


ALTER TABLE [dbo].[STACK_2_EQ_STREETBLOCKS] ADD  CONSTRAINT [PK_STACK_2_EQ_STREETBLOCKS_STREETBLOCKID] PRIMARY KEY CLUSTERED 
(
	[STREETBLOCKID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE SPATIAL INDEX [SI_STACK_2_EQ_STREETBLOCKS] ON [dbo].[STACK_2_EQ_STREETBLOCKS]
(
	[Shape]
)USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


-------------------------------------------------------------------
--     	Select all then save as CSV for matlab
-------------------------------------------------------------------
USE
	weiboDEV
GO
Select 
	* 
FROM
	[dbo].[STACK_2_EQ_STREETBLOCKS]
WHERE
	PointDensity IS NOT NULL


-------------------------------------------------------------------
--     	Select STACK 2 into normalized ROW by ROW format (PIVOT)
-------------------------------------------------------------------
-- adoped from http://bradsruminations.blogspot.com/2010/02/spotlight-on-unpivot-part-1.html
--
USE
	weiboDEV
GO
DROP TABLE
	STACK_2_EQ_STREETBLOCKS_rowformat
SELECT
	STREETBLOCKID
   ,imgdate
   ,Coherence as VALUE
INTO 
	STACK_2_EQ_STREETBLOCKS_rowformat
FROM
	[dbo].[STACK_2_EQ_STREETBLOCKS]
cross apply (	select 'AvgCoh_20130416_20130508_1'  as imagedate, AvgCoh_20130416_20130508_1  union all
				select 'AvgCoh_20130416_20130621_2'  as imagedate, AvgCoh_20130416_20130621_2  union all
				select 'AvgCoh_20130508_20130621_3'  as imagedate, AvgCoh_20130508_20130621_3  union all
				select 'AvgCoh_20130508_20130713_4'  as imagedate, AvgCoh_20130508_20130713_4  union all
				select 'AvgCoh_20130621_20130917_5'  as imagedate, AvgCoh_20130621_20130917_5  union all
				select 'AvgCoh_20130713_20130917_6'  as imagedate, AvgCoh_20130713_20130917_6  union all
				select 'AvgCoh_20130917_20131214_7'  as imagedate, AvgCoh_20130917_20131214_7  union all
				select 'AvgCoh_20131214_20140312_8'  as imagedate, AvgCoh_20131214_20140312_8  union all
				select 'AvgCoh_20140312_20140517_9'  as imagedate, AvgCoh_20140312_20140517_9  union all
				select 'AvgCoh_20140802_20140517_10' as imagedate, AvgCoh_20140802_20140517_10 union all
				select 'AvgCoh_20140802_20140915_11' as imagedate, AvgCoh_20140802_20140915_11 union all
				select 'AvgCoh_20140802_20141029_12' as imagedate, AvgCoh_20140802_20141029_12 union all
				select 'AvgCoh_20141029_20141223_13' as imagedate, AvgCoh_20141029_20141223_13 union all
				select 'AvgCoh_20150401_20150515_14' as imagedate, AvgCoh_20150401_20150515_14 union all
				select 'MaxCoh_20130416_20130508_1'  as imagedate, MaxCoh_20130416_20130508_1  union all
				select 'MaxCoh_20130416_20130621_2'  as imagedate, MaxCoh_20130416_20130621_2  union all
				select 'MaxCoh_20130508_20130621_3'  as imagedate, MaxCoh_20130508_20130621_3  union all
				select 'MaxCoh_20130508_20130713_4'  as imagedate, MaxCoh_20130508_20130713_4  union all
				select 'MaxCoh_20130621_20130917_5'  as imagedate, MaxCoh_20130621_20130917_5  union all
				select 'MaxCoh_20130713_20130917_6'  as imagedate, MaxCoh_20130713_20130917_6  union all
				select 'MaxCoh_20130917_20131214_7'  as imagedate, MaxCoh_20130917_20131214_7  union all
				select 'MaxCoh_20131214_20140312_8'  as imagedate, MaxCoh_20131214_20140312_8  union all
				select 'MaxCoh_20140312_20140517_9'  as imagedate, MaxCoh_20140312_20140517_9  union all
				select 'MaxCoh_20140802_20140517_10' as imagedate, MaxCoh_20140802_20140517_10 union all
				select 'MaxCoh_20140802_20140915_11' as imagedate, MaxCoh_20140802_20140915_11 union all
				select 'MaxCoh_20140802_20141029_12' as imagedate, MaxCoh_20140802_20141029_12 union all
				select 'MaxCoh_20141029_20141223_13' as imagedate, MaxCoh_20141029_20141223_13 union all
				select 'MaxCoh_20150401_20150515_14' as imagedate, MaxCoh_20150401_20150515_14 union all
				select 'MinCoh_20130416_20130508_1'  as imagedate, MinCoh_20130416_20130508_1  union all
				select 'MinCoh_20130416_20130621_2'  as imagedate, MinCoh_20130416_20130621_2  union all
				select 'MinCoh_20130508_20130621_3'  as imagedate, MinCoh_20130508_20130621_3  union all
				select 'MinCoh_20130508_20130713_4'  as imagedate, MinCoh_20130508_20130713_4  union all
				select 'MinCoh_20130621_20130917_5'  as imagedate, MinCoh_20130621_20130917_5  union all
				select 'MinCoh_20130713_20130917_6'  as imagedate, MinCoh_20130713_20130917_6  union all
				select 'MinCoh_20130917_20131214_7'  as imagedate, MinCoh_20130917_20131214_7  union all
				select 'MinCoh_20131214_20140312_8'  as imagedate, MinCoh_20131214_20140312_8  union all
				select 'MinCoh_20140312_20140517_9'  as imagedate, MinCoh_20140312_20140517_9  union all
				select 'MinCoh_20140802_20140517_10' as imagedate, MinCoh_20140802_20140517_10 union all
				select 'MinCoh_20140802_20140915_11' as imagedate, MinCoh_20140802_20140915_11 union all
				select 'MinCoh_20140802_20141029_12' as imagedate, MinCoh_20140802_20141029_12 union all
				select 'MinCoh_20141029_20141223_13' as imagedate, MinCoh_20141029_20141223_13 union all
				select 'MinCoh_20150401_20150515_14' as imagedate, MinCoh_20150401_20150515_14 union all
				select 'StDevCoh_20130416_20130508_1'  as imagedate, StDevCoh_20130416_20130508_1  union all
				select 'StDevCoh_20130416_20130621_2'  as imagedate, StDevCoh_20130416_20130621_2  union all
				select 'StDevCoh_20130508_20130621_3'  as imagedate, StDevCoh_20130508_20130621_3  union all
				select 'StDevCoh_20130508_20130713_4'  as imagedate, StDevCoh_20130508_20130713_4  union all
				select 'StDevCoh_20130621_20130917_5'  as imagedate, StDevCoh_20130621_20130917_5  union all
				select 'StDevCoh_20130713_20130917_6'  as imagedate, StDevCoh_20130713_20130917_6  union all
				select 'StDevCoh_20130917_20131214_7'  as imagedate, StDevCoh_20130917_20131214_7  union all
				select 'StDevCoh_20131214_20140312_8'  as imagedate, StDevCoh_20131214_20140312_8  union all
				select 'StDevCoh_20140312_20140517_9'  as imagedate, StDevCoh_20140312_20140517_9  union all
				select 'StDevCoh_20140802_20140517_10' as imagedate, StDevCoh_20140802_20140517_10 union all
				select 'StDevCoh_20140802_20140915_11' as imagedate, StDevCoh_20140802_20140915_11 union all
				select 'StDevCoh_20140802_20141029_12' as imagedate, StDevCoh_20140802_20141029_12 union all
				select 'StDevCoh_20141029_20141223_13' as imagedate, StDevCoh_20141029_20141223_13 union all
				select 'StDevCoh_20150401_20150515_14' as imagedate, StDevCoh_20150401_20150515_14 union all
				select 'StDevPCoh_20130416_20130508_1'  as imagedate, StDevPCoh_20130416_20130508_1  union all
				select 'StDevPCoh_20130416_20130621_2'  as imagedate, StDevPCoh_20130416_20130621_2  union all
				select 'StDevPCoh_20130508_20130621_3'  as imagedate, StDevPCoh_20130508_20130621_3  union all
				select 'StDevPCoh_20130508_20130713_4'  as imagedate, StDevPCoh_20130508_20130713_4  union all
				select 'StDevPCoh_20130621_20130917_5'  as imagedate, StDevPCoh_20130621_20130917_5  union all
				select 'StDevPCoh_20130713_20130917_6'  as imagedate, StDevPCoh_20130713_20130917_6  union all
				select 'StDevPCoh_20130917_20131214_7'  as imagedate, StDevPCoh_20130917_20131214_7  union all
				select 'StDevPCoh_20131214_20140312_8'  as imagedate, StDevPCoh_20131214_20140312_8  union all
				select 'StDevPCoh_20140312_20140517_9'  as imagedate, StDevPCoh_20140312_20140517_9  union all
				select 'StDevPCoh_20140802_20140517_10' as imagedate, StDevPCoh_20140802_20140517_10 union all
				select 'StDevPCoh_20140802_20140915_11' as imagedate, StDevPCoh_20140802_20140915_11 union all
				select 'StDevPCoh_20140802_20141029_12' as imagedate, StDevPCoh_20140802_20141029_12 union all
				select 'StDevPCoh_20141029_20141223_13' as imagedate, StDevPCoh_20141029_20141223_13 union all
				select 'StDevPCoh_20150401_20150515_14' as imagedate, StDevPCoh_20150401_20150515_14 ) X (imgdate,Coherence)

ALTER TABLE 
	STACK_2_EQ_STREETBLOCKS_rowformat
ADD 
	what smallint;

UPDATE STACK_2_EQ_STREETBLOCKS_rowformat
SET 
	what = (
			CASE
				WHEN (LEFT(imgdate, 3) = 'Avg') THEN 1
				WHEN (LEFT(imgdate, 3) = 'Max') THEN 2
				WHEN (LEFT(imgdate, 3) = 'Min') THEN 3
				WHEN (LEFT(imgdate, 5) = 'StDev') THEN 4
				WHEN (SUBSTRING(imgdate, 1,6) = 'StDevP') THEN SUBSTRING(imgdate, 1,6)
				ELSE
					0
				END
			)

	Select * from [dbo].[STACK_2_EQ_STREETBLOCKS_rowformat] 			
				
	