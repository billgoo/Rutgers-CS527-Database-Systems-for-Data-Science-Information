-- table
select * from MyCube order by 1,2,3


-- pivot query
-- select
-- 	Product, Q1, Q2, Q3, Q4
-- from
-- 	MyCube PIVOT(SUM(Sales) FOR ThisQuarter IN (Q1,Q2,Q3,Q4)) AS P
select
	Product,
	SUM( IF(ThisYear=2016,Sales,0) ) As `2016`,
	SUM( IF(ThisYear=2017,Sales,0) ) As `2017`,
	SUM( IF(ThisYear=2018,Sales,0) ) As `2018`,
	SUM(Sales) As 'ALL'
from MyCube
group by Product with rollup;


-- pivot query
-- SELECT Product, Region, Q1, Q2, Q3, Q4
-- FROM   
-- (SELECT Product, Region, ThisQuarter, Sales FROM MyCube) AS p  
-- PIVOT  
-- (sum(Sales) FOR ThisQuarter IN (Q1,Q2,Q3,Q4)) AS pvt
SELECT
	Product,
	Region,
	sum( IF(ThisYear=2016,Sales,0) ) As `2016`,
	sum( IF(ThisYear=2017,Sales,0) ) As `2017`,
	sum( IF(ThisYear=2018,Sales,0) ) As `2018`,
	sum(Sales) As 'ALL'
FROM   
(SELECT Product, Region, ThisYear, Sales FROM MyCube) AS p
GROUP BY Product, Region WITH ROLLUP;


-- slicing
select * from MyCube where ThisYear=2016

-- dicing
select * from MyCube where ThisYear=2016 and region='USA'


-- group by with rollup
SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
FROM MyCube
GROUP BY ThisYear, Region, Product with rollup
ORDER BY 1,2,3


-- group by with cube
-- SELECT ThisQuarter, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisQuarter) AS 'Grouping' 
-- FROM MyCube
-- GROUP BY ThisQuarter, Region, Product with cube
-- ORDER BY 1,2,3
(
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY ThisYear, Region, Product with rollup
	UNION
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY ThisYear, Product, Region with rollup
	UNION
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY Region, ThisYear, Product with rollup
	UNION
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY Region, Product, ThisYear with rollup
	UNION
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY Product, ThisYear, Region with rollup
	UNION
	SELECT ThisYear, Region, Product, SUM(Sales)as TotalSales--, GROUPING(ThisYear) AS 'Grouping' 
	FROM MyCube
	GROUP BY Product, Region, ThisYear with rollup
)
ORDER BY 1,2,3;


-- group by grouping sets
SELECT ThisYear, Region, SUM(Sales) as TotalSales
FROM MyCube
GROUP BY GROUPING SETS ((ThisYear), (Region))
ORDER BY 1,2
--
SELECT ThisYear, NULL as Region, SUM(Sales) as TotalSales FROM MyCube GROUP BY ThisYear
UNION ALL
SELECT NULL, Region, SUM(Sales) as TotalSales FROM MyCube GROUP BY Region
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
	ThisYear, Region, Sales
	, AVG(Sales) OVER (PARTITION BY Region ORDER BY ThisYear) AS Sales_Avg
FROM 
	MyCube
ORDER BY 
	Region, ThisYear, Sales_Avg

-- Windowing
SELECT 
	ThisYear, Region, Sales
	, AVG(Sales) OVER (PARTITION BY Region ORDER BY ThisYear ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Sales_Avg
FROM 
	MyCube
ORDER BY 
	Region, ThisYear, Sales_Avg





