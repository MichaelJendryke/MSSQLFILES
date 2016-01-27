-- STATISTICS FOR EVERY STREETBLOCK
USE weiboDEV
GO
DROP TABLE STACK_1_EQ_STREETBLOCKS
Select 
	 -- these are the columns of the final table 
	 SB.OBJECTID AS STREETBLOCKID
	,STACK1.PointCOUNT as PointCount
	,STACK1.PointCOUNT/SB.AREA AS PointDensity
	,STACK1.AvgCoh_20090328_20090408_1
	,STACK1.AvgCoh_20090328_20090419_2
	,STACK1.AvgCoh_20090328_20090511_3
	,STACK1.AvgCoh_20090328_20090522_4
	,STACK1.AvgCoh_20090328_20090602_5
	,STACK1.AvgCoh_20090328_20090624_6
	,STACK1.AvgCoh_20090408_20090419_7
	,STACK1.AvgCoh_20090408_20090511_8
	,STACK1.AvgCoh_20090408_20090522_9
	,STACK1.AvgCoh_20090408_20090602_10
	,STACK1.AvgCoh_20090419_20090511_11
	,STACK1.AvgCoh_20090419_20090522_12
	,STACK1.AvgCoh_20090419_20090602_13
	,STACK1.AvgCoh_20090419_20090624_14
	,STACK1.AvgCoh_20090511_20090522_15
	,STACK1.AvgCoh_20090511_20090602_16
	,STACK1.AvgCoh_20090511_20090624_17
	,STACK1.AvgCoh_20090522_20090602_18
	,STACK1.AvgCoh_20090522_20090624_19
	,STACK1.AvgCoh_20090624_20090829_20
	,STACK1.AvgCoh_20090624_20090920_21
	,STACK1.AvgCoh_20090829_20091012_22
	,STACK1.AvgCoh_20090829_20091023_23
	,STACK1.AvgCoh_20090920_20091012_24
	,STACK1.AvgCoh_20090920_20091023_25
	,STACK1.AvgCoh_20090920_20091114_26
	,STACK1.AvgCoh_20090920_20091206_27
	,STACK1.AvgCoh_20090920_20091217_28
	,STACK1.AvgCoh_20091012_20091023_29
	,STACK1.AvgCoh_20091012_20091114_30
	,STACK1.AvgCoh_20091012_20100108_31
	,STACK1.AvgCoh_20091023_20091114_32
	,STACK1.AvgCoh_20091023_20100108_33
	,STACK1.AvgCoh_20091023_20100119_34
	,STACK1.AvgCoh_20091114_20091206_35
	,STACK1.AvgCoh_20091114_20091217_36
	,STACK1.AvgCoh_20091114_20100108_37
	,STACK1.AvgCoh_20091114_20100119_38
	,STACK1.AvgCoh_20091114_20100130_39
	,STACK1.AvgCoh_20091206_20091217_40
	,STACK1.AvgCoh_20091206_20100108_41
	,STACK1.AvgCoh_20091206_20100119_42
	,STACK1.AvgCoh_20091217_20100108_43
	,STACK1.AvgCoh_20091217_20100119_44
	,STACK1.AvgCoh_20091228_20091206_45
	,STACK1.AvgCoh_20091228_20091217_46
	,STACK1.AvgCoh_20100108_20100119_47
	,STACK1.AvgCoh_20100108_20100130_48
	,STACK1.AvgCoh_20100119_20100130_49
	,STACK1.AvgCoh_20110916_20111008_50
	,STACK1.AvgCoh_20110916_20111213_51
	,STACK1.AvgCoh_20111008_20111213_52
	,STACK1.AvgCoh_20111008_20120104_53
	,STACK1.AvgCoh_20111121_20120104_54
	,STACK1.AvgCoh_20111121_20120206_55
	,STACK1.AvgCoh_20111213_20120310_56
	,STACK1.AvgCoh_20120104_20120206_57
	,STACK1.AvgCoh_20120104_20120310_58
	,STACK1.AvgCoh_20120104_20120401_59
	,STACK1.AvgCoh_20120206_20120310_60
	,STACK1.AvgCoh_20120206_20120401_61
	,STACK1.AvgCoh_20120310_20120401_62
	,STACK1.AvgCoh_20120310_20120515_63
	,STACK1.AvgCoh_20120401_20120515_64
	,STACK1.AvgCoh_20120401_20120628_65
	,STACK1.AvgCoh_20120515_20120628_66
	,STACK1.AvgCoh_20120515_20120811_67
	,STACK1.AvgCoh_20120628_20120811_68
	,STACK1.AvgCoh_20120628_20120902_69
	,STACK1.AvgCoh_20120720_20121005_70
	,STACK1.AvgCoh_20120811_20120902_71
	,SB.[Shape]
INTO
	STACK_1_EQ_STREETBLOCKS
FROM 
	[weiboDEV].[dbo].ALLROADS_RIVERS_BORDERS_TO_POLYGONS_PLUS_POPDATA SB
LEFT OUTER JOIN 
	(	SELECT 
			 [weiboDEV].[dbo].[STACK1_LINK_ID_to_STREETBLOOKID].[STREETBLOCKID]
			,COUNT([weiboDEV].[dbo].[STACK1_rfEQ].ID) AS PointCOUNT
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img1]) AS AvgCoh_20090328_20090408_1
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img2]) AS AvgCoh_20090328_20090419_2
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img3]) AS AvgCoh_20090328_20090511_3
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img4]) AS AvgCoh_20090328_20090522_4
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img5]) AS AvgCoh_20090328_20090602_5
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img6]) AS AvgCoh_20090328_20090624_6
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img7]) AS AvgCoh_20090408_20090419_7
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img8]) AS AvgCoh_20090408_20090511_8
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img9]) AS AvgCoh_20090408_20090522_9
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img10]) AS AvgCoh_20090408_20090602_10
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img11]) AS AvgCoh_20090419_20090511_11
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img12]) AS AvgCoh_20090419_20090522_12
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img13]) AS AvgCoh_20090419_20090602_13
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img14]) AS AvgCoh_20090419_20090624_14
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img15]) AS AvgCoh_20090511_20090522_15
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img16]) AS AvgCoh_20090511_20090602_16
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img17]) AS AvgCoh_20090511_20090624_17
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img18]) AS AvgCoh_20090522_20090602_18
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img19]) AS AvgCoh_20090522_20090624_19
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img20]) AS AvgCoh_20090624_20090829_20
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img21]) AS AvgCoh_20090624_20090920_21
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img22]) AS AvgCoh_20090829_20091012_22
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img23]) AS AvgCoh_20090829_20091023_23
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img24]) AS AvgCoh_20090920_20091012_24
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img25]) AS AvgCoh_20090920_20091023_25
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img26]) AS AvgCoh_20090920_20091114_26
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img27]) AS AvgCoh_20090920_20091206_27
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img28]) AS AvgCoh_20090920_20091217_28
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img29]) AS AvgCoh_20091012_20091023_29
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img30]) AS AvgCoh_20091012_20091114_30
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img31]) AS AvgCoh_20091012_20100108_31
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img32]) AS AvgCoh_20091023_20091114_32
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img33]) AS AvgCoh_20091023_20100108_33
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img34]) AS AvgCoh_20091023_20100119_34
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img35]) AS AvgCoh_20091114_20091206_35
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img36]) AS AvgCoh_20091114_20091217_36
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img37]) AS AvgCoh_20091114_20100108_37
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img38]) AS AvgCoh_20091114_20100119_38
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img39]) AS AvgCoh_20091114_20100130_39
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img40]) AS AvgCoh_20091206_20091217_40
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img41]) AS AvgCoh_20091206_20100108_41
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img42]) AS AvgCoh_20091206_20100119_42
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img43]) AS AvgCoh_20091217_20100108_43
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img44]) AS AvgCoh_20091217_20100119_44
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img45]) AS AvgCoh_20091228_20091206_45
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img46]) AS AvgCoh_20091228_20091217_46
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img47]) AS AvgCoh_20100108_20100119_47
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img48]) AS AvgCoh_20100108_20100130_48
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img49]) AS AvgCoh_20100119_20100130_49
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img50]) AS AvgCoh_20110916_20111008_50
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img51]) AS AvgCoh_20110916_20111213_51
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img52]) AS AvgCoh_20111008_20111213_52
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img53]) AS AvgCoh_20111008_20120104_53
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img54]) AS AvgCoh_20111121_20120104_54
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img55]) AS AvgCoh_20111121_20120206_55
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img56]) AS AvgCoh_20111213_20120310_56
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img57]) AS AvgCoh_20120104_20120206_57
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img58]) AS AvgCoh_20120104_20120310_58
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img59]) AS AvgCoh_20120104_20120401_59
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img60]) AS AvgCoh_20120206_20120310_60
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img61]) AS AvgCoh_20120206_20120401_61
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img62]) AS AvgCoh_20120310_20120401_62
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img63]) AS AvgCoh_20120310_20120515_63
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img64]) AS AvgCoh_20120401_20120515_64
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img65]) AS AvgCoh_20120401_20120628_65
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img66]) AS AvgCoh_20120515_20120628_66
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img67]) AS AvgCoh_20120515_20120811_67
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img68]) AS AvgCoh_20120628_20120811_68
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img69]) AS AvgCoh_20120628_20120902_69
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img70]) AS AvgCoh_20120720_20121005_70
			,AVG([weiboDEV].[dbo].[STACK1_rfEQ].[img71]) AS AvgCoh_20120811_20120902_71
			
		FROM 
			[weiboDEV].[dbo].[STACK1_LINK_ID_to_STREETBLOOKID]
		JOIN 
			[weiboDEV].[dbo].[STACK1_rfEQ]
		ON
			[weiboDEV].[dbo].[STACK1_LINK_ID_to_STREETBLOOKID].[ID] = [weiboDEV].[dbo].[STACK1_rfEQ].[ID]
		GROUP BY 
			[weiboDEV].[dbo].[STACK1_LINK_ID_to_STREETBLOOKID].STREETBLOCKID
	) STACK1 ON (SB.OBJECTID=STACK1.STREETBLOCKID)


ALTER TABLE [dbo].[STACK_1_EQ_STREETBLOCKS] ADD  CONSTRAINT [PK_STACK_1_EQ_STREETBLOCKS_STREETBLOCKID] PRIMARY KEY CLUSTERED 
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
CREATE SPATIAL INDEX [SI_STACK_1_EQ_STREETBLOCKS] ON [dbo].[STACK_1_EQ_STREETBLOCKS]
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
	[dbo].[STACK_1_EQ_STREETBLOCKS]
WHERE
	PointDensity IS NOT NULL


-------------------------------------------------------------------
--     	Select STACK 1 into normalized ROW by ROW format (PIVOT)
-------------------------------------------------------------------
-- adoped from http://bradsruminations.blogspot.com/2010/02/spotlight-on-unpivot-part-1.html
--
use weiboDEV
GO
select STREETBLOCKID,imgdate,Coherence
into STACK_1_EQ_STREETBLOCKS_rowformat
from [dbo].[STACK_1_EQ_STREETBLOCKS]
cross apply (	select 'AvgCoh_20090328_20090408_1'  as imagedate, AvgCoh_20090328_20090408_1  union all
				select 'AvgCoh_20090328_20090419_2'  as imagedate, AvgCoh_20090328_20090419_2  union all
				select 'AvgCoh_20090328_20090511_3'  as imagedate, AvgCoh_20090328_20090511_3  union all
				select 'AvgCoh_20090328_20090522_4'  as imagedate, AvgCoh_20090328_20090522_4  union all
				select 'AvgCoh_20090328_20090602_5'  as imagedate, AvgCoh_20090328_20090602_5  union all
				select 'AvgCoh_20090328_20090624_6'  as imagedate, AvgCoh_20090328_20090624_6  union all
				select 'AvgCoh_20090408_20090419_7'  as imagedate, AvgCoh_20090408_20090419_7  union all
				select 'AvgCoh_20090408_20090511_8'  as imagedate, AvgCoh_20090408_20090511_8  union all
				select 'AvgCoh_20090408_20090522_9'  as imagedate, AvgCoh_20090408_20090522_9  union all
				select 'AvgCoh_20090408_20090602_10' as imagedate, AvgCoh_20090408_20090602_10 union all
				select 'AvgCoh_20090419_20090511_11' as imagedate, AvgCoh_20090419_20090511_11 union all
				select 'AvgCoh_20090419_20090522_12' as imagedate, AvgCoh_20090419_20090522_12 union all
				select 'AvgCoh_20090419_20090602_13' as imagedate, AvgCoh_20090419_20090602_13 union all
				select 'AvgCoh_20090419_20090624_14' as imagedate, AvgCoh_20090419_20090624_14 union all
				select 'AvgCoh_20090511_20090522_15' as imagedate, AvgCoh_20090511_20090522_15 union all
				select 'AvgCoh_20090511_20090602_16' as imagedate, AvgCoh_20090511_20090602_16 union all
				select 'AvgCoh_20090511_20090624_17' as imagedate, AvgCoh_20090511_20090624_17 union all
				select 'AvgCoh_20090522_20090602_18' as imagedate, AvgCoh_20090522_20090602_18 union all
				select 'AvgCoh_20090522_20090624_19' as imagedate, AvgCoh_20090522_20090624_19 union all
				select 'AvgCoh_20090624_20090829_20' as imagedate, AvgCoh_20090624_20090829_20 union all
				select 'AvgCoh_20090624_20090920_21' as imagedate, AvgCoh_20090624_20090920_21 union all
				select 'AvgCoh_20090829_20091012_22' as imagedate, AvgCoh_20090829_20091012_22 union all
				select 'AvgCoh_20090829_20091023_23' as imagedate, AvgCoh_20090829_20091023_23 union all
				select 'AvgCoh_20090920_20091012_24' as imagedate, AvgCoh_20090920_20091012_24 union all
				select 'AvgCoh_20090920_20091023_25' as imagedate, AvgCoh_20090920_20091023_25 union all
				select 'AvgCoh_20090920_20091114_26' as imagedate, AvgCoh_20090920_20091114_26 union all
				select 'AvgCoh_20090920_20091206_27' as imagedate, AvgCoh_20090920_20091206_27 union all
				select 'AvgCoh_20090920_20091217_28' as imagedate, AvgCoh_20090920_20091217_28 union all
				select 'AvgCoh_20091012_20091023_29' as imagedate, AvgCoh_20091012_20091023_29 union all
				select 'AvgCoh_20091012_20091114_30' as imagedate, AvgCoh_20091012_20091114_30 union all
				select 'AvgCoh_20091012_20100108_31' as imagedate, AvgCoh_20091012_20100108_31 union all
				select 'AvgCoh_20091023_20091114_32' as imagedate, AvgCoh_20091023_20091114_32 union all
				select 'AvgCoh_20091023_20100108_33' as imagedate, AvgCoh_20091023_20100108_33 union all
				select 'AvgCoh_20091023_20100119_34' as imagedate, AvgCoh_20091023_20100119_34 union all
				select 'AvgCoh_20091114_20091206_35' as imagedate, AvgCoh_20091114_20091206_35 union all
				select 'AvgCoh_20091114_20091217_36' as imagedate, AvgCoh_20091114_20091217_36 union all
				select 'AvgCoh_20091114_20100108_37' as imagedate, AvgCoh_20091114_20100108_37 union all
				select 'AvgCoh_20091114_20100119_38' as imagedate, AvgCoh_20091114_20100119_38 union all
				select 'AvgCoh_20091114_20100130_39' as imagedate, AvgCoh_20091114_20100130_39 union all
				select 'AvgCoh_20091206_20091217_40' as imagedate, AvgCoh_20091206_20091217_40 union all
				select 'AvgCoh_20091206_20100108_41' as imagedate, AvgCoh_20091206_20100108_41 union all
				select 'AvgCoh_20091206_20100119_42' as imagedate, AvgCoh_20091206_20100119_42 union all
				select 'AvgCoh_20091217_20100108_43' as imagedate, AvgCoh_20091217_20100108_43 union all
				select 'AvgCoh_20091217_20100119_44' as imagedate, AvgCoh_20091217_20100119_44 union all
				select 'AvgCoh_20091228_20091206_45' as imagedate, AvgCoh_20091228_20091206_45 union all
				select 'AvgCoh_20091228_20091217_46' as imagedate, AvgCoh_20091228_20091217_46 union all
				select 'AvgCoh_20100108_20100119_47' as imagedate, AvgCoh_20100108_20100119_47 union all
				select 'AvgCoh_20100108_20100130_48' as imagedate, AvgCoh_20100108_20100130_48 union all
				select 'AvgCoh_20100119_20100130_49' as imagedate, AvgCoh_20100119_20100130_49 union all
				select 'AvgCoh_20110916_20111008_50' as imagedate, AvgCoh_20110916_20111008_50 union all
				select 'AvgCoh_20110916_20111213_51' as imagedate, AvgCoh_20110916_20111213_51 union all
				select 'AvgCoh_20111008_20111213_52' as imagedate, AvgCoh_20111008_20111213_52 union all
				select 'AvgCoh_20111008_20120104_53' as imagedate, AvgCoh_20111008_20120104_53 union all
				select 'AvgCoh_20111121_20120104_54' as imagedate, AvgCoh_20111121_20120104_54 union all
				select 'AvgCoh_20111121_20120206_55' as imagedate, AvgCoh_20111121_20120206_55 union all
				select 'AvgCoh_20111213_20120310_56' as imagedate, AvgCoh_20111213_20120310_56 union all
				select 'AvgCoh_20120104_20120206_57' as imagedate, AvgCoh_20120104_20120206_57 union all
				select 'AvgCoh_20120104_20120310_58' as imagedate, AvgCoh_20120104_20120310_58 union all
				select 'AvgCoh_20120104_20120401_59' as imagedate, AvgCoh_20120104_20120401_59 union all
				select 'AvgCoh_20120206_20120310_60' as imagedate, AvgCoh_20120206_20120310_60 union all
				select 'AvgCoh_20120206_20120401_61' as imagedate, AvgCoh_20120206_20120401_61 union all
				select 'AvgCoh_20120310_20120401_62' as imagedate, AvgCoh_20120310_20120401_62 union all
				select 'AvgCoh_20120310_20120515_63' as imagedate, AvgCoh_20120310_20120515_63 union all
				select 'AvgCoh_20120401_20120515_64' as imagedate, AvgCoh_20120401_20120515_64 union all
				select 'AvgCoh_20120401_20120628_65' as imagedate, AvgCoh_20120401_20120628_65 union all
				select 'AvgCoh_20120515_20120628_66' as imagedate, AvgCoh_20120515_20120628_66 union all
				select 'AvgCoh_20120515_20120811_67' as imagedate, AvgCoh_20120515_20120811_67 union all
				select 'AvgCoh_20120628_20120811_68' as imagedate, AvgCoh_20120628_20120811_68 union all
				select 'AvgCoh_20120628_20120902_69' as imagedate, AvgCoh_20120628_20120902_69 union all
				select 'AvgCoh_20120720_20121005_70' as imagedate, AvgCoh_20120720_20121005_70 union all
				select 'AvgCoh_20120811_20120902_71' as imagedate, AvgCoh_20120811_20120902_71) X(imgdate,Coherence)





