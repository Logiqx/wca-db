/* 
    Script:   Check Tables
    Created:  2019-04-15
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check table sizes
*/

SET @wca_db = 'wca';

-- Total table sizes in WCA database
SELECT table_schema, ROUND(sum(data_length / 1024 / 1024), 2) AS data_length_mb
FROM information_schema.tables
WHERE table_schema = @wca_db
GROUP BY table_schema
ORDER BY table_schema;

-- Individual tables sizes should match the size of the clustered index (e.g. PRIMARY)
SELECT table_schema, table_name, ROUND(data_length / 1024 / 1024, 2) AS data_length_mb
FROM information_schema.tables
WHERE table_schema = @wca_db
ORDER BY table_schema, table_name;


