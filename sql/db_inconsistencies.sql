/* 
    Script:   Database Inconsistencies
    Created:  2025-12-30
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check for inconsistencies between results export and developer database
*/

-- Check which tables have an `id` column, which is always the primary key - no surprises
--   10 tables in results export
--     excludes persons, ranks_average, ranks_single, ar_internal_metadata, eligible_country_iso2s_for_championship, schema_migrations
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema LIKE 'wca%'
AND column_name = 'id'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

-- Check which tables have a `person_id` column - PROPOSE rename of `person_id` to `wca_id`
--   3 tables in results export / 6 tables in developer export
--     ranks_average, ranks_single, results + concise_average_results, concise_single_results, inbox_results
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema LIKE 'wca%'
AND column_name = 'person_id'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

-- Check which tables have a `wca_id` column - PROPOSE rename of `person_id` to `wca_id`
--   1 table in results export / 4 tables in developer export
--     persons + inbox_persons, tickets_edit_person, users
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema LIKE 'wca%'
AND column_name = 'wca_id'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

-- Check which tables have `day`, `month`, `year` columns - PROPOSE concise results, competitions and persons use proper date fields
--   1 table in results export / 2 tables in developer export
--     competitions / concise_average_results, concise_single_results
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema LIKE 'wca%'
AND column_name = 'month'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

-- Compare tables in results export against developer export - PROPOSE competitions and persons use proper date fields
--   2 tables in results export have columns that are not in the developer export
--     competitions.*, results.person_country_id
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema = 'wca'
AND NOT EXISTS
(
	SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS AS c2
    WHERE table_schema = 'wca_dev'
    AND c2.table_name = c1.table_name
    AND c2.column_name = c1.column_name
)
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;
