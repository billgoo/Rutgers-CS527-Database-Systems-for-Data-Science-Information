-- table
select * from MyCube order by 1,2,3
 
-- pivot query
select
	Product, Q1, Q2, Q3, Q4
from
	MyCube PIVOT(SUM(Sales) FOR ThisQuarter IN (Q1,Q2,Q3,Q4)) AS P


-- pivot query 
select
	Region, Q1, Q2, Q3, Q4
from
	MyCube PIVOT(SUM(Sales) FOR ThisQuarter IN (Q1,Q2,Q3,Q4)) AS P


-- pivot query
SELECT Product, Region, Q1, Q2, Q3, Q4
FROM   
(SELECT Product, Region, ThisQuarter, Sales FROM MyCube) AS p  
PIVOT  
(sum(Sales) FOR ThisQuarter IN (Q1,Q2,Q3,Q4)) AS pvt  


-- slicing
select * from MyCube where ThisQuarter='Q1'


-- dicing
select * from MyCube where ThisQuarter='Q1' and region='Europe'


-- group by with rollup
SELECT ThisQuarter, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisQuarter) AS 'Grouping' 
FROM MyCube
GROUP BY ThisQuarter, Region, Product with rollup
ORDER BY 1,2,3


-- group by with cube
SELECT ThisQuarter, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisQuarter) AS 'Grouping' 
FROM MyCube
GROUP BY ThisQuarter, Region, Product with cube
ORDER BY 1,2,3



-- group by grouping sets
SELECT ThisQuarter, Region, SUM(Sales) as TotalSales
FROM MyCube
GROUP BY GROUPING SETS ((ThisQuarter), (Region))
ORDER BY 1,2

--
SELECT ThisQuarter, NULL as Region, SUM(Sales) as TotalSalesFROM MyCubeGROUP BY ThisQuarter
UNION ALL
SELECT NULL, Region, SUM(Sales)as TotalSales FROM MyCubeGROUP BY Region
ORDER BY 1,2


-- Ranking
SELECT 
	Product, Sales
	, RANK() OVER (ORDER BY Sales ASC) as RANK_SALES
	, DENSE_RANK() OVER (ORDER BY Sales ASC) as DENSE_RANK_SALES
	, PERCENT_RANK() OVER (ORDER BY Sales ASC) as PERC_RANK_SALES
	, CUME_DIST() OVER (ORDER BY Sales ASC) as CUM_DIST_SALES
FROM 
	MyCube
ORDER BY 
	RANK_SALES ASC


-- Windowing
SELECT 
	ThisQuarter, Region, Sales
	, AVG(Sales) OVER (PARTITION BY Region ORDER BY ThisQuarter) AS Sales_Avg
FROM 
	MyCube
ORDER BY 
	Region, ThisQuarter, Sales_Avg


-- Windowing
SELECT 
	ThisQuarter, Region, Sales
	, AVG(Sales) OVER (PARTITION BY Region ORDER BY ThisQuarter ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Sales_Avg
FROM 
	MyCube
ORDER BY 
	Region, ThisQuarter, Sales_Avg





