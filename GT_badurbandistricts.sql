/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	  --[PopDensSQKM]
      [TotMsgDensSQKM]
      ,[ResTotMsgCntDensSQKM]
FROM 
	[weiboDEV].[dbo].[A_SHANGHAI_URBANDISTRICTS_final]
WHERE 
	   [OBJECTID] NOT IN (SELECT * FROM badurbandistricts)



DROP TABLE
badurbandistricts
SELECT
	[OBJECTID]
INTO
	badurbandistricts
FROM
	[dbo].[A_SHANGHAI_URBANDISTRICTS_final]

WHERE
	[OBJECTID] IN (9894,9896,9897,9898,9899,9900,9901,9902,9903,9905,9906,9907,9910,9913,9914,10459,10547,10589,12625,12627,12628,12629,12630,12631,12632,12633,12129)