SELECT COUNT(VALUE) as CNT, ';' as del, FORMAT(VALUE,'0.00') AS COHERENCE
FROM (SELECT ROUND([img1],2) as VALUE FROM [dbo].[STACK1_rf]) AS A 
GROUP BY VALUE
ORDER BY VALUE

SELECT COUNT([img1]) FROM [dbo].[STACK1_rf]