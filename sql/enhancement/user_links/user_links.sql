/* 
      Script:   User Links
      Created:  2019-06-29
      Author:   Michael George / 2015GEOR02
     
      Purpose:  Establish links between user accounts and WCA profiles
*/

-- Use the latest results database
USE wca;

-- Additional indices required on the users table
ALTER TABLE wca_dev.users ADD INDEX index_users_on_unconfirmed_wca_id (unconfirmed_wca_id);
ALTER TABLE wca_dev.users ADD INDEX index_users_on_name (name);

/*
    Create table for user links
*/

-- Drop pre-existing table
DROP TABLE IF EXISTS wca_dev.user_links;

-- Create the table for user links
CREATE TABLE wca_dev.user_links (
  `wca_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_iso2` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `confirmed_id` int(11) DEFAULT NULL,
  `registration_ids` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unconfirmed_ids` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `possible_country_ids` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `possible_world_ids` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`wca_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*
    Step 1 - Confirmed WCA IDs (AKA Claimed)
*/

-- Simple join of WCA profiles with confirmed user accounts ~3s
INSERT INTO wca_dev.user_links (wca_id, name, country_id, country_iso2, gender, user_status, user_id, confirmed_id)
SELECT p.id AS wca_id, p.name, p.country_id, c.iso2, IFNULL(p.gender, ''), IF(u.id, 'Confirmed', NULL) AS user_status, u.id AS user_id, u.id AS confirmed_id
FROM persons AS p
JOIN countries AS c ON c.id = p.country_id
LEFT JOIN wca_dev.users AS u ON u.wca_id = p.id
WHERE subid = 1; -- latest name + country

/*
    Step 2 - Competition Registrations
*/

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS registration_duplicates;

-- Create temporary table containing the registrations that are ambiguous (i.e. same name for two people in same comp) ~5s
CREATE TEMPORARY TABLE registration_duplicates AS
SELECT competition_id, name, COUNT(DISTINCT user_id) AS num_persons
FROM wca_dev.registrations r
JOIN wca_dev.users AS u ON u.id = r.user_id
WHERE deleted_at IS NULL
GROUP BY competition_id, name
HAVING num_persons > 1;

-- Add the PK
ALTER TABLE registration_duplicates ADD PRIMARY KEY (competition_id, name);

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS registration_users;

-- Create temporary table containing the registrations that are unambiguous ~2s
CREATE TEMPORARY TABLE registration_users AS
SELECT r.competition_id, r.user_id, u.name
FROM wca_dev.registrations r
JOIN wca_dev.users AS u ON u.id = r.user_id
WHERE deleted_at IS NULL
AND NOT EXISTS
(
	SELECT 1
	FROM registration_duplicates d
    WHERE d.competition_id = r.competition_id
    AND d.name = u.name
);

-- Add the PK
ALTER TABLE registration_users ADD PRIMARY KEY (competition_id, name);

-- Updating the links table takes between 20-30 seconds (warm) and 180 seconds (cold) since it has to use the "Results" table
UPDATE wca_dev.user_links AS l
JOIN
(
	SELECT person_id AS wca_id, MAX(user_id) AS user_id, GROUP_CONCAT(DISTINCT user_id) AS registration_ids
	FROM results r
	JOIN registration_users u ON u.competition_id = r.competition_id AND u.name = r.person_name
    GROUP BY person_id
) AS r ON r.wca_id = l.wca_id
SET l.user_status = COALESCE(l.user_status, 'Registered'), l.user_id = COALESCE(l.user_id, r.user_id), l.registration_ids = r.registration_ids;

/*
    Step 3 - Unconfirmed WCA IDs
*/

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS unconfirmed_users;

-- Create temporary table containing the unconfirmed WCA claims
CREATE TEMPORARY TABLE unconfirmed_users AS
SELECT unconfirmed_wca_id AS wca_id, name, MAX(id) AS user_id, GROUP_CONCAT(DISTINCT id) AS unconfirmed_ids
FROM wca_dev.users
WHERE unconfirmed_wca_id IS NOT NULL
GROUP BY unconfirmed_wca_id, name;

-- Add the PK
ALTER TABLE unconfirmed_users ADD PRIMARY KEY (wca_id, name);

-- Update the links table
UPDATE wca_dev.user_links AS l
JOIN unconfirmed_users AS u ON u.wca_id = l.wca_id AND u.name = l.name
SET l.user_status = COALESCE(l.user_status, 'Unconfirmed'), l.user_id = COALESCE(l.user_id, u.user_id), l.unconfirmed_ids = u.unconfirmed_ids;

/*
    Step 4 - Matching Name + country (ignoring gender seems beneficial)
*/

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS duplicate_names;

-- Create temporary table containing the people from the same country with the same name ~5s
CREATE TEMPORARY TABLE duplicate_names AS
SELECT p.name, p.country_id AS country_id
FROM persons p
GROUP BY name, country_id
HAVING COUNT(DISTINCT id) > 1;

-- Add the PK
ALTER TABLE duplicate_names ADD PRIMARY KEY (name, country_id);

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS country_users;

-- Create temporary table containing the people from the same country with a suitable name ~2s
CREATE TEMPORARY TABLE country_users AS
SELECT p.wca_id, MAX(id) AS user_id, GROUP_CONCAT(DISTINCT id) AS possible_country_ids
FROM wca_dev.user_links AS p
JOIN wca_dev.users AS u ON u.wca_id IS NULL AND u.unconfirmed_wca_id IS NULL AND u.name = p.name AND u.country_iso2 = p.country_iso2
WHERE NOT EXISTS
(
	SELECT 1
    FROM duplicate_names d
    WHERE d.name = p.name AND d.country_id = p.country_id
)
GROUP BY wca_id;

-- Add the PK
ALTER TABLE country_users ADD PRIMARY KEY (wca_id);

-- Update the links table
UPDATE wca_dev.user_links AS l
JOIN country_users AS u ON u.wca_id = l.wca_id
SET l.user_status = COALESCE(l.user_status, 'Possible'), l.user_id = COALESCE(l.user_id, u.user_id), l.possible_country_ids = u.possible_country_ids;

/*
    Step 5 - Matching Name, worldwide (ignoring gender seems beneficial)
*/

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS duplicate_names;

-- Create temporary table containing the people worldwide with the same name ~3s
CREATE TEMPORARY TABLE duplicate_names AS
SELECT p.name
FROM persons p
GROUP BY name
HAVING COUNT(DISTINCT id) > 1;

-- Add the PK
ALTER TABLE duplicate_names ADD PRIMARY KEY (name);

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS duplicate_names_extra;

-- Same as the other temporary table but with country added
CREATE TEMPORARY TABLE duplicate_names_extra AS
SELECT DISTINCT name, country_iso2
FROM wca_dev.user_links l
WHERE EXISTS
(
	SELECT 1
	FROM duplicate_names d
    WHERE d.name = l.name
);

-- Add the PK
ALTER TABLE duplicate_names_extra ADD PRIMARY KEY (name, country_iso2);

-- Drop pre-existing temporary table
DROP TEMPORARY TABLE IF EXISTS worldwide_users;

-- Create temporary table containing the people from the same country with the same name ~2s
CREATE TEMPORARY TABLE worldwide_users AS
SELECT l.wca_id, MAX(id) AS user_id, GROUP_CONCAT(DISTINCT id) AS possible_world_ids
FROM wca_dev.user_links AS l
JOIN wca_dev.users AS u ON u.wca_id IS NULL AND u.unconfirmed_wca_id IS NULL AND u.name = l.name AND u.country_iso2 != l.country_iso2
WHERE NOT EXISTS
(
	SELECT 1
    FROM duplicate_names_extra d
    WHERE d.name = l.name
)
GROUP BY wca_id;

-- Add the PK
ALTER TABLE worldwide_users ADD PRIMARY KEY (wca_id);

-- Update the links table
UPDATE wca_dev.user_links AS l
JOIN worldwide_users AS u ON u.wca_id = l.wca_id
SET l.possible_world_ids = u.possible_world_ids;

/*
    Finalise processing
*/

-- Ensure that user status is always populated ~2s
UPDATE wca_dev.user_links
SET user_status = 'Non-existent'
WHERE user_status IS NULL;

ALTER TABLE wca_dev.user_links ADD INDEX user_links_user_id (user_id);

/*
    Summarise the links
*/

SELECT user_status, COUNT(*) AS num_persons,
	COUNT(confirmed_id) AS num_confirmed,
    COUNT(registration_ids) AS num_registered,
	COUNT(unconfirmed_ids) AS num_unconfirmed,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_overall,
    ROUND(100.0 * COUNT(confirmed_id) / COUNT(*), 2) AS pct_confirmed,
    ROUND(100.0 * COUNT(registration_ids) / COUNT(*), 2) AS pct_registered,
    ROUND(100.0 * COUNT(unconfirmed_ids) / COUNT(*), 2) AS pct_unconfirmed
FROM wca_dev.user_links
GROUP BY user_status
ORDER BY num_persons DESC;
