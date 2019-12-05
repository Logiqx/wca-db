/* 
    Script:   Check Tables
    Created:  2019-04-15
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check table sizes

    Notes:    The InnoDB engine stores data records in the clustered index (i.e. PRIMARY index)
*/

SET @wca_db = 'wca_alt';

/*
    Overall database sizes
*/

-- Table sizes only
SELECT table_schema, ROUND(sum(data_length / 1024 / 1024), 2) AS size_in_mb
FROM information_schema.tables
WHERE engine = 'InnoDB'
AND table_schema LIKE 'wca%'
GROUP BY table_schema
ORDER BY size_in_mb DESC;

-- Table sizes + index sizes
SELECT database_name,
	ROUND(SUM(stat_value * CASE WHEN row_format = 'Compressed' THEN 8192 ELSE @@innodb_page_size END / 1024 / 1024), 2) size_in_mb
FROM information_schema.tables t
JOIN mysql.innodb_index_stats i ON i.database_name = t.table_schema AND i.table_name = t.table_name
WHERE t.engine = 'InnoDB'
AND t.table_schema LIKE 'wca%'
AND stat_name = 'size'
GROUP BY database_name
ORDER BY size_in_mb DESC;

/*
    Individual table sizes
*/

-- Table sizes only
WITH stats AS
(
	SELECT table_schema, table_name, row_format, ROUND(data_length / 1024 / 1024, 2) AS size_in_mb
	FROM information_schema.tables
	WHERE table_schema IN ('wca', 'wca_alt')
	AND engine = 'InnoDB'
)
SELECT *, ROUND(100.0 * s1.size_in_mb / s2.size_in_mb, 2) AS pctSize
FROM stats s1
LEFT JOIN stats s2 ON s2.table_name = s1.table_name AND s2.table_schema = 'wca'
WHERE s1.table_schema = 'wca_alt'
ORDER BY s1.size_in_mb DESC;

-- Table sizes + index sizes
WITH stats AS
(
	SELECT table_schema, i.table_name, row_format,
		ROUND(SUM(stat_value * CASE WHEN row_format = 'Compressed' THEN 8192 ELSE @@innodb_page_size END / 1024 / 1024), 2) size_in_mb
	FROM information_schema.tables t
	JOIN mysql.innodb_index_stats i ON database_name = table_schema AND i.table_name = t.table_name
	WHERE table_schema IN ('wca', 'wca_alt')
	AND engine = 'InnoDB'
	AND stat_name = 'size'
	GROUP BY database_name, table_name
)
SELECT *, ROUND(100.0 * s1.size_in_mb / s2.size_in_mb, 2) AS pctSize
FROM stats s1
LEFT JOIN stats s2 ON s2.table_name = s1.table_name AND s2.table_schema = 'wca'
WHERE s1.table_schema = 'wca_alt'
ORDER BY s1.size_in_mb DESC;
