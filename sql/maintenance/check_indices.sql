/* 
    Script:   Check Indices
    Created:  2019-04-06
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check indices on the WCA tables
*/

SET @wca_db = 'wca_alt';

-- List tables with primary key
SELECT t.table_schema, t.table_name, s.index_name, t.table_rows,  
	MAX(s.cardinality) AS index_cardinality, 1 - MIN(s.non_unique) AS index_unique
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.engine = 'InnoDB'
AND t.table_schema = @wca_db
AND s.index_name ='PRIMARY'
GROUP BY t.table_schema, t.table_name, t.table_rows,  s.index_name
ORDER BY t.table_schema, t.table_name, t.table_rows,  s.index_name;

-- List tables with one or more secondary indices
SELECT t.table_schema, t.table_name, s.index_name, t.table_rows,  
	MAX(s.cardinality) AS index_cardinality, 1 - MIN(s.non_unique) AS index_unique
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.engine = 'InnoDB'
AND t.table_schema = @wca_db
AND s.index_name != 'PRIMARY'
GROUP BY t.table_schema, t.table_name, t.table_rows,  s.index_name
ORDER BY t.table_schema, t.table_name, t.table_rows,  s.index_name;

-- List tables without any indices
SELECT *, t.table_schema, t.table_name, t.table_rows
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.engine = 'InnoDB'
AND t.table_schema = @wca_db
AND s.index_name IS NULL
ORDER BY t.table_schema, t.table_name, t.table_rows;

-- List index sizes - PRIMARY is a clustered index so it includes the actual records for the base table
SELECT database_name, i.table_name, index_name, row_format,
	ROUND(stat_value * CASE WHEN row_format = 'Compressed' THEN 8192 ELSE @@innodb_page_size END / 1024 / 1024, 2) size_in_mb
FROM information_schema.tables t
JOIN mysql.innodb_index_stats i ON i.database_name = t.table_schema AND i.table_name = t.table_name
WHERE t.engine = 'InnoDB'
AND t.table_schema = @wca_db
AND t.table_name = 'Attempts'
AND stat_name = 'size'
ORDER BY table_name, index_name, database_name;
