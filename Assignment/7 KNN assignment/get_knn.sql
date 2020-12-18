CREATE DEFINER=`admin`@`%` PROCEDURE `get_knn`(
	in tbl varchar(100), tar varchar(100), predictor varchar(100), val varchar(10), k int
)
BEGIN
    -- create temp table for knn data
    -- drop temp table if exists
    DROP TABLE IF EXISTS Challenger_schema.temp1;
    CREATE TABLE Challenger_schema.temp1
	(
		`O-Ring failure` TINYINT(1) NOT NULL,
		`Launch temperature` INT NOT NULL,
		`Leak-check pressure` VARCHAR(10) NOT NULL,
		`ED` DOUBLE NOT NULL
	);

    -- swtich between predictor
	-- calculate knn distance and return a temp view
	IF (predictor='Launch temperature') THEN
        -- @predictor=`Launch temperature`
        -- Find @k nearest neighbors and insert the data
		SET @sql1 = CONCAT(
            'INSERT INTO Challenger_schema.temp1(`O-Ring failure`, `Launch temperature`, `Leak-check pressure`, `ED`) 
            SELECT `O-Ring failure`, `Launch temperature`, `Leak-check pressure`, 
            sqrt(pow((`', predictor,'` - CAST(',val,' as signed)), 2)) AS `ED` 
            
			FROM Challenger_schema.',tbl,
            ' ORDER BY `ED` ASC LIMIT ', k,';');
        prepare getsql1 from @sql1;
        execute getsql1;
    ELSEIF (predictor='Leak-check pressure') THEN
        -- Find @k nearest neighbors and insert the data
        SET @sql1 = CONCAT(
            'INSERT INTO Challenger_schema.temp1(`O-Ring failure`, `Launch temperature`, `Leak-check pressure`, `ED`) 
            SELECT `O-Ring failure`, `Launch temperature`, `Leak-check pressure`, 
            sqrt(pow((CASE WHEN ''', val, '''=''Low'' THEN `temp_predictor` - 1 
            WHEN ''', val, '''=''Medium'' THEN `temp_predictor` - 2 
            WHEN ''', val, '''=''High'' THEN `temp_predictor` - 3 
            ELSE `temp_predictor` - (-1) END ), 2 )) AS `ED` 
            FROM ( SELECT *, (CASE 
            WHEN `',
            predictor,
            '`=''Low'' THEN 1 WHEN `',
            predictor,
            '`=''Medium'' THEN 2 WHEN `',
            predictor,
            '`=''High'' THEN 3 
            ELSE -1 
            end) as `temp_predictor` 
            from Challenger_schema.',
            tbl,
            ') converter_tbl 
            ORDER BY `ED` ASC LIMIT ',
            k, ';');
        prepare getsql1 from @sql1;
        execute getsql1;
    ELSE 
        SELECT 'Error: Value of @predictor is not valid.';
    END IF;

    -- print @k nearest neighbors
    SELECT `O-Ring failure`, `Launch temperature`, `Leak-check pressure`
    FROM Challenger_schema.temp1;

    -- Return the proportion of N and Y.
    SET @prosql = CONCAT(
        'SELECT `',
        tar,
        '`, CONCAT(ltrim(
            CAST(count(`',
        tar,
        '`)*100.0/(SELECT count(`',
        tar,
        '`) FROM Challenger_schema.temp1) AS DEC(18,2))
        ),
        ''%'') as `proportion`
        FROM Challenger_schema.temp1
        GROUP BY `',
        tar,
        '`;'
    );
    prepare getprosql from @prosql;
    execute getprosql;

    -- Return the majority class (N or Y) of @target
    SET @sub_countsql = CONCAT(
        '(
            SELECT 
                `',
        tar,
        '`, 
        count(`',
        tar,
        '`) as `proportion` 
        FROM Challenger_schema.temp1 
        GROUP BY `',
        tar,
        '`
        ) count_pro'
    );
    SET @majsql = CONCAT(
        'SELECT `',
        tar,
        '` FROM ',
        @sub_countsql,
        ' WHERE `proportion` IN ( '
        'SELECT MAX(`proportion`) AS `proportion` 
        FROM ',
        @sub_countsql,
        ');'
    );
    prepare getmajsql from @majsql;
    execute getmajsql;

    -- drop temp table
    DROP TABLE IF EXISTS Challenger_schema.temp1;

END