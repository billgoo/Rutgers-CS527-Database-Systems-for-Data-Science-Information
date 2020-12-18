CREATE DEFINER=`admin`@`%` PROCEDURE `get_correlation_coefficient`(in tbl varchar(100), col1 varchar(100), col2 varchar(100))
BEGIN
#select count
Set @sql = concat('select count(', col1, ') into @cnt', ' from ', tbl);
prepare getsql from @sql;
execute getsql;

#select @cnt;

#select E(col1), E(col2), E(col1*col2), std(col1), std(col2)
set @sql = concat('select (sum(', col1, ')/@cnt),', ' (sum(', col2, ')/@cnt),',
				' (sum(', col1, '*', col2, ')/@cnt),',
                ' std(', col1, '),', ' std(', col2, ')',
                ' into @E1, @E2, @E12, @s1, @s2',
                ' from ', tbl
				);
prepare getsql from @sql;
execute getsql;
select @E1,@E2,@E12,@s1,@s2;

#select Correlation coefficient
select (@E12-@E1*@E2)/(@s1*@s2) as Correlation_coefficient;

END