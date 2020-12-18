use Datasets
go

alter procedure usp_ztest(@table varchar(100), @numvar varchar(100), @catvar varchar(100)
						  , @catval0 varchar(50), @catval1 varchar(50))
as

declare @sql varchar(max)

set @sql='
declare @n1 float
declare @m1 float
declare @s1 float
declare @n0 float
declare @m0 float
declare @s0 float
declare @sp float
declare @z float

--0
select
	@n0=count(*)
	, @m0=avg([' + @numvar + '])
	, @s0=var([' + @numvar + '])
from
	[' + @table + ']
where
	' + @catvar + '=' + char(39) + @catval0 + char(39)

set @sql= @sql + 'select @n0, @m0, @s0'


--1
set @sql= @sql + '
select
	@n1=count(*)
	, @m1=avg([' + @numvar + '])
	, @s1=var([' + @numvar + '])
from
	[' + @table + ']
where
	' + @catvar + '=' + char(39) + @catval1 + char(39)

--
set @sql= @sql + '
set @sp=sqrt((@s0/@n0)+(@s1/@n1))
set @z=(@m1-@m0)/@sp'

--
set @sql= @sql + '
select 
	@z as z
	, @n0 as count_0, @m0 as avg_0, @s0 as var_0
	, @n1 as count_1, @m1 as avg_1, @s1 as var_1'

--
execute (@sql)


--check	
execute usp_ztest 'Challenger', 'Launch_temperature', 'O_Ring_failure', 'N','Y'