CREATE DEFINER=`admin`@`%` PROCEDURE `get_univar`(in tbl varchar(100), attribute varchar(100))
BEGIN
set @rowindex := -1;
set @findmedian = concat(
'select avg(t.col) into @median
from 
(select @rowindex:=@rowindex + 1 as rowindex,', tbl,'.',attribute,' as col ',
' from ', tbl,
' order by ', tbl,'.',attribute, ') as t',
' where t.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));'
);
prepare findmedian from @findmedian;
execute findmedian;
DEALLOCATE PREPARE findmedian;

set @rowindex := -1;
set @findQ1 = concat(
'select avg(t.col) into @Q1
from 
(select @rowindex:=@rowindex + 1 as rowindex,', tbl,'.',attribute,' as col ',
' from ', tbl,
' order by ', tbl,'.',attribute, ') as t',
' where t.rowindex IN (FLOOR(@rowindex / 4), CEIL(@rowindex / 4));'
);
prepare findQ1 from @findQ1;
execute findQ1;
DEALLOCATE PREPARE findQ1;

set @rowindex := -1;
set @findQ3 = concat(
'select avg(t.col) into @Q3
from 
(select @rowindex:=@rowindex + 1 as rowindex,', tbl,'.',attribute,' as col ',
' from ', tbl,
' order by ', tbl,'.',attribute, ') as t',
' where t.rowindex IN (FLOOR(@rowindex / 4 * 3), CEIL(@rowindex / 4 * 3));'
);
prepare findQ3 from @findQ3;
execute findQ3;
DEALLOCATE PREPARE findQ3;


set @query1 = concat('select min(', attribute, '), max(',attribute, '), avg(',attribute, '), 
TRUNCATE(@Q1,2) as Q1, TRUNCATE(@median,2) as median, TRUNCATE(@Q3,2) as Q3 from ', tbl);
prepare getsql from @query1;
execute getsql;
DEALLOCATE PREPARE getsql;

END