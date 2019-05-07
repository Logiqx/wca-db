/* 
    Script:   Check Indices
    Created:  2019-04-06
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check indices on the WCA tables
*/

SET @wca_db = 'wca';

-- List index statistics
SELECT *
FROM information_schema.statistics
WHERE table_schema = @wca_db
ORDER BY table_name, table_schema;

-- List tables with primary key
SELECT t.table_schema, t.table_name, s.index_name, t.table_rows,  
	MAX(s.cardinality) AS index_cardinality, 1 - MIN(s.non_unique) AS index_unique
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.table_schema = @wca_db
AND s.index_name ='PRIMARY'
GROUP BY t.table_schema, t.table_name, t.table_rows,  s.index_name
ORDER BY t.table_schema, t.table_name, t.table_rows,  s.index_name;

-- List tables with one or more indices
SELECT t.table_schema, t.table_name, s.index_name, t.table_rows,  
	MAX(s.cardinality) AS index_cardinality, 1 - MIN(s.non_unique) AS index_unique
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.table_schema = @wca_db
AND s.index_name != 'PRIMARY'
GROUP BY t.table_schema, t.table_name, t.table_rows,  s.index_name
ORDER BY t.table_schema, t.table_name, t.table_rows,  s.index_name;

-- List tables without any indices
SELECT t.table_schema, t.table_name, t.table_rows
FROM information_schema.tables t
LEFT JOIN information_schema.statistics s ON s.table_schema = t.table_schema AND s.table_name = t.table_name
WHERE t.table_schema = @wca_db
AND s.index_name IS NULL
ORDER BY t.table_schema, t.table_name, t.table_rows;

-- List index sizes - PRIMARY is a clustered index so it includes the actual table records
SELECT database_name, table_name, database_name, index_name,
	ROUND(stat_value *
		CASE
            WHEN database_name = 'wcastats' THEN 8192
			ELSE @@innodb_page_size
		END / 1024 / 1024, 2) size_in_mb
FROM mysql.innodb_index_stats
WHERE database_name = @wca_db
AND stat_name = 'size'
ORDER BY database_name, table_name;