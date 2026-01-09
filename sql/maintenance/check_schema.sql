/* 
    Script:   Check schema
    Created:  2025-12-30
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check for inconsistencies between results export and developer database
*/

-- Check which tables have an `id` column, which is always the primary key - no surprises
--   10 tables in results export
--     excludes persons, ranks_average, ranks_single, ar_internal_metadata, eligible_country_iso2s_for_championship, schema_migrations
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE TABLE_SCHEMA IN ('wca', 'wca_dev')
AND COLUMN_NAME = 'id'
ORDER BY TABLE_SCHEMA, COLUMN_TYPE, TABLE_NAME, COLUMN_NAME;

-- Check which tables have a `person_id` column - PROPOSE rename of `person_id` to `wca_id`
--   3 tables in results export / 6 tables in developer export
--     ranks_average, ranks_single, results + concise_average_results, concise_single_results, inbox_results
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE TABLE_SCHEMA IN ('wca', 'wca_dev')
AND COLUMN_NAME = 'person_id'
ORDER BY TABLE_SCHEMA, COLUMN_TYPE, TABLE_NAME, COLUMN_NAME;

-- Check which tables have a `wca_id` column - PROPOSE rename of `person_id` to `wca_id`
--   1 table in results export / 4 tables in developer export
--     persons + inbox_persons, tickets_edit_person, users
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE TABLE_SCHEMA IN ('wca', 'wca_dev')
AND COLUMN_NAME = 'wca_id'
ORDER BY TABLE_SCHEMA, COLUMN_TYPE, TABLE_NAME, COLUMN_NAME;

-- Check which tables have `day`, `month`, `year` columns - PROPOSE concise results, competitions and persons use proper date fields
--   1 table in results export / 2 tables in developer export
--     competitions / concise_average_results, concise_single_results
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE TABLE_SCHEMA IN ('wca', 'wca_dev')
AND (COLUMN_NAME LIKE '%day' OR COLUMN_NAME LIKE '%month' OR COLUMN_NAME LIKE '%year')
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_TYPE, LENGTH(COLUMN_NAME), COLUMN_NAME;

-- Compare tables in results export against developer export - PROPOSE competitions and persons use proper date fields
--   2 tables in results export have columns that are not in the developer export
--     competitions.*, results.person_country_id
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema = 'wca'
AND NOT EXISTS
(
	SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS AS c2
    WHERE table_schema = 'wca_dev'
    AND c2.TABLE_NAME = c1.TABLE_NAME
    AND c2.COLUMN_NAME = c1.COLUMN_NAME
)
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_TYPE, LENGTH(COLUMN_NAME), COLUMN_NAME;

-- Show fields with differing types
--   4 tables in results export have different types to the developer export
--     championships.id, results.id, scrambles.id and result_attempts.attempt_number
SELECT c1.TABLE_NAME, c1.COLUMN_NAME, c1.COLUMN_TYPE AS results_type, c2.COLUMN_TYPE AS developer_type
FROM INFORMATION_SCHEMA.COLUMNS AS c1
JOIN INFORMATION_SCHEMA.COLUMNS AS c2 ON c2.table_name = c1.table_name AND c2.column_name = c1.column_name
WHERE c1.TABLE_SCHEMA = 'wca'
AND c2.TABLE_SCHEMA = 'wca_dev'
AND c1.COLUMN_TYPE <> c2.COLUMN_TYPE
ORDER BY c1.TABLE_NAME, c1.COLUMN_TYPE, LENGTH(c1.COLUMN_NAME), c1.COLUMN_NAME;

-- Show fields with differing types in wca_alt
--    Nothing really worth reporting, except perhaps events.name being 54 characters
SELECT c1.TABLE_NAME, c1.COLUMN_NAME, c1.COLUMN_TYPE AS results_type, c2.COLUMN_TYPE AS possible_type
FROM INFORMATION_SCHEMA.COLUMNS AS c1
JOIN INFORMATION_SCHEMA.COLUMNS AS c2 ON c2.table_name = c1.table_name AND c2.column_name = c1.column_name
WHERE c1.TABLE_SCHEMA = 'wca'
AND c2.TABLE_SCHEMA = 'wca_alt'
AND c1.COLUMN_TYPE <> c2.COLUMN_TYPE
ORDER BY c1.COLUMN_TYPE, c2.COLUMN_TYPE, TABLE_NAME;

-- Check which tables have strange varchar lengths
--   events.name = 54 (perhaps use 50), formats.sort_by and sort_by_second = 255 (perhaps use 10), various = 191 (some are really short)
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE TABLE_SCHEMA IN ('wca', 'wca_dev')
AND DATA_TYPE = 'varchar'
AND CHARACTER_MAXIMUM_LENGTH NOT IN (1, 2, 3, 6, 10, 32, 50)
ORDER BY TABLE_SCHEMA, CHARACTER_MAXIMUM_LENGTH, COLUMN_TYPE, TABLE_NAME, COLUMN_NAME;

-- Search for tables without primary key
--   2 tables in results export do not have a primary key
--     eligible_country_iso2s_for_championship + result_attempts (not required)
SELECT DISTINCT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c1
WHERE table_schema = 'wca'
AND NOT EXISTS
(
	SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS AS c2
    WHERE table_schema = 'wca'
    AND c2.TABLE_NAME = c1.TABLE_NAME
    AND c2.COLUMN_KEY = 'PRI'
)
ORDER BY TABLE_SCHEMA, TABLE_NAME
