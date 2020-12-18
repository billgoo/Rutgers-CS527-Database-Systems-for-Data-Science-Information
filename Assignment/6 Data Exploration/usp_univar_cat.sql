use Datasets
go

-- usp_univar_cat
alter procedure usp_univar_cat (@table varchar(100), @colname varchar(100))
as

--
declare @sql varchar(max)

--
set @sql='
select [' + @colname +']
	, count(*) as [Count]
	, 100.0*count(*)/(select count(*) from [' + @table +']) as [Count%]
from 
	[' + @table +']
group by
	[' + @colname +']'

execute (@sql)


-- check
exec usp_univar_cat 'ABC_Retail','Customer_Country'
