-- HISTOGRAM FOR AN IMAGE

SELECT COUNT(VALUE) as CNT, ';' as del, FORMAT(VALUE,'0.00') AS COHERENCE
FROM (SELECT ROUND([img1],2) as VALUE FROM [dbo].[STACK1_rf]) AS A 
GROUP BY VALUE
ORDER BY VALUE

SELECT COUNT([img1]) FROM [dbo].[STACK1_rf]


-- HISTOGRAM FOR STREETBLOCKS
SELECT FORMAT(VALUE,'0000000000.00') AS VALUE,COUNT(VALUE) as CNT
FROM (SELECT ROUND([AREASQM]/50000,0)*5 as VALUE FROM [dbo].[A_SHANGHAI_STEETBLOCKS_final]) AS A 
GROUP BY VALUE
ORDER BY VALUE

SELECT COUNT([img1]) FROM [dbo].[STACK1_rf]

Select CAST(12355.5 as bigint) 


