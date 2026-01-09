/* 
    Script:   Populate tables
    Created:  2019-05-09
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Populate tables in the WCA alternative database
   
    Notes:    Works with v2 results export, but yet to check for new fields
*/

/* --------------------
    events
   -------------------- */

INSERT INTO `wca_alt`.`events` (`legacy_id`, `name`, `rank`, `format`)
SELECT `id`, `name`, `rank`, `format`
FROM `events`
ORDER BY `rank`;

CREATE UNIQUE INDEX `events_legacy_id` ON `wca_alt`.`events` (`legacy_id`);


/* --------------------
    Formats
   -------------------- */

INSERT INTO `wca_alt`.`formats` (`code`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`)
SELECT `id`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`
FROM `wca`.`formats`
ORDER BY `expected_solve_count`, `name`;

CREATE UNIQUE INDEX `formats_code` ON `wca_alt`.`formats` (`code`);


/* --------------------
    round_types
   -------------------- */

INSERT INTO `wca_alt`.`round_types` (`code`, `rank`, `name`, `cell_name`, `final`)
SELECT `id`, `rank`, `name`, `cell_name`, `final`
FROM `wca`.`round_types`
ORDER BY `rank`;

CREATE UNIQUE INDEX `round_types_code` ON `wca_alt`.`round_types` (`code`);


/* --------------------
    Continents
   -------------------- */

INSERT INTO `wca_alt`.`continents` (`legacy_id`, `name`, `record_name`, `latitude`, `longitude`, `zoom`)
SELECT `id`, `name`, `record_name`, `latitude`, `longitude`, `zoom`
FROM `continents`
ORDER BY `name`;

CREATE UNIQUE INDEX `continents_legacy_id` ON `wca_alt`.`continents` (`legacy_id`);


/* --------------------
    Countries
   -------------------- */

INSERT INTO `wca_alt`.`countries` (`continent_id`, `legacy_id`, `name`, `continent_name`, `iso2`)
SELECT `continents`.`id`, `countries`.`id`, `countries`.`name`, `continents`.`name`, `countries`.`iso2`
FROM `countries`
JOIN `wca_alt`.`continents` ON `countries`.`continent_id` = `continents`.`legacy_id`
ORDER BY `countries`.`name`;

CREATE UNIQUE INDEX `countries_legacy_id` ON `wca_alt`.`countries` (`legacy_id`);


/* --------------------
    competitions
   -------------------- */

INSERT INTO `wca_alt`.`competitions`
	(`country_id`, `continent_id`, `legacy_id`, `name`, `city_name`, `country_name`, `continent_name`, `information`,
    `year`, `month`, `day`, `end_year`,
    `end_month`, `end_day`,
    `start_date`, `end_date`,
    `event_specs`, -- `wca_delegate`, `organiser`,
    `venue`, `venue_address`, `venue_details`, `external_website`, `cell_name`) -- , `latitude`, `longitude`)
SELECT `countries`.`id`, `countries`.`continent_id`, `competitions`.`id`,
	`competitions`.`name`, `competitions`.`city_name`, `countries`.`name`, `countries`.`continent_name`, `competitions`.`information`,
    `competitions`.`year`, `competitions`.`month`, `competitions`.`day`,
    CASE WHEN `competitions`.`end_month` >= `competitions`.`month` THEN `competitions`.`year` ELSE `competitions`.`year` + 1 END,
		`competitions`.`end_month`, `competitions`.`end_day`,
    DATE_FORMAT(CONCAT(`competitions`.`year`, "-", `competitions`.`month`, "-", `competitions`.`day`), "%Y-%m-%d") AS start_date,
    DATE_FORMAT(CONCAT(CASE WHEN `competitions`.`end_month` >= `competitions`.`month` THEN `competitions`.`year` ELSE `competitions`.`year` + 1 END,
		"-", `competitions`.`end_month`, "-", `competitions`.`end_day`), "%Y-%m-%d") AS end_date,
    `competitions`.`event_specs`, -- `competitions`.`wca_delegate`, `competitions`.`organiser`,
    `competitions`.`venue`, `competitions`.`venue_address`, `competitions`.`venue_details`, `competitions`.`external_website`,
    `competitions`.`cell_name` -- , `competitions`.`latitude`, `competitions`.`longitude`
FROM `wca`.`competitions`
JOIN `wca_alt`.`countries` ON `competitions`.`country_id` = `countries`.`legacy_id`
ORDER BY start_date, end_date, `competitions`.`name`;

CREATE UNIQUE INDEX `competitions_legacy_id` ON `wca_alt`.`competitions` (`legacy_id`);


/* --------------------
    Scrambles
   -------------------- */

INSERT INTO `wca_alt`.`scrambles`
	(`legacy_id`, `competition_id`, `competition_country_id`, `competition_continent_id`,
    `event_id`, `round_type_id`, `round_type_code`, `round_type_final`,
    `group_id`, `is_extra`, `scramble_num`, `scramble`)
SELECT `scrambles`.`id`, `competitions`.`id`, `competitions`.`country_id`, `competitions`.`continent_id`,
    `events`.`id`, `round_types`.`id`, `round_types`.`code`, `round_types`.`final`,
    `scrambles`.`group_id`, `scrambles`.`is_extra`, `scrambles`.`scramble_num`, `scrambles`.`scramble`
FROM `scrambles`
JOIN `wca_alt`.`events` ON `events`.`legacy_id` = `scrambles`.`event_id`
JOIN `wca_alt`.`competitions` ON `competitions`.`legacy_id` = `scrambles`.`competition_id`
JOIN `wca_alt`.`round_types` ON `round_types`.`code` = `scrambles`.`round_type_id`
ORDER BY `competitions`.`id`, `events`.`id`, `round_types`.`id`, `group_id`, `is_extra`, `scramble_num`;


/* --------------------
    persons
   -------------------- */

INSERT INTO `wca_alt`.`persons` (`wca_id`, `sub_id`, `country_id`, `continent_id`, `name`, `country_name`, `continent_name`, `gender`)
SELECT `persons`.`wca_id`, `persons`.`sub_id`, `countries`.`id`, `countries`.`continent_id`,
	`persons`.`name`, `countries`.`name`, `countries`.`continent_name`, `persons`.`gender`
FROM `wca`.`persons`
JOIN `wca_alt`.`countries` ON `persons`.`country_id` = `countries`.`legacy_id`
ORDER BY `persons`.`wca_id`, `persons`.`sub_id` DESC;

CREATE UNIQUE INDEX `persons_wca_id_sub_id` ON `wca_alt`.`persons` (`wca_id`, `sub_id`);

SET SQL_SAFE_UPDATES = 0;

UPDATE `wca_alt`.`persons` AS p1
INNER JOIN `wca_alt`.`persons` AS p2 ON p2.`wca_id` = p1.`wca_id` AND p2.`sub_id` = 1
SET p1.`link_id` = p2.`id`;

SET SQL_SAFE_UPDATES = 1;


/* --------------------
    ranks_single
   -------------------- */

INSERT INTO `wca_alt`.`ranks_single`
	(`person_id`, `country_id`, `continent_id`, `event_id`,
    `best`, `world_rank`, `continent_rank`, `country_rank`)
SELECT `persons`.`id`, `persons`.`country_id`, `persons`.`continent_id`, `events`.`id`,
	`ranks_single`.`best`, `ranks_single`.`world_rank`, `ranks_single`.`continent_rank`, `ranks_single`.`country_rank`
FROM `ranks_single` USE INDEX ()
JOIN `wca_alt`.`events` ON `events`.`legacy_id` = `ranks_single`.`event_id`
JOIN `wca_alt`.`persons` ON `persons`.`wca_id` = `ranks_single`.`person_id` AND `persons`.`sub_id` = 1
ORDER BY `persons`.`wca_id`, `events`.`id`;


/* --------------------
    ranks_average
   -------------------- */

INSERT INTO `wca_alt`.`ranks_average`
	(`person_id`, `country_id`, `continent_id`, `event_id`,
    `best`, `world_rank`, `continent_rank`, `country_rank`)
SELECT `persons`.`id`, `persons`.`country_id`, `persons`.`continent_id`, `events`.`id`,
	`ranks_average`.`best`, `ranks_average`.`world_rank`, `ranks_average`.`continent_rank`, `ranks_average`.`country_rank`
FROM `ranks_average` USE INDEX ()
JOIN `wca_alt`.`events` ON `events`.`legacy_id` = `ranks_average`.`event_id`
JOIN `wca_alt`.`persons` ON `persons`.`wca_id` = `ranks_average`.`person_id` AND `persons`.`sub_id` = 1
ORDER BY `persons`.`wca_id`, `events`.`id`;


/* --------------------
    results
   -------------------- */

INSERT INTO `wca_alt`.`results`
	(`person_id`, `person_link_id`,
    `person_country_id`, `person_continent_id`,
	`competition_id`, `competition_country_id`, `competition_continent_id`, `competition_date`,
	`event_id`,
    `round_type_id`, `round_type_code`, `round_type_final`,
	`format_id`, `format_code`,
    `pos`, `best`, `average`,
	-- `value1`, `value2`, `value3`, `value4`, `value5`,
    `regional_single_record`, `regional_average_record`)
SELECT `persons`.`id`, `persons`.`link_id`,
	`countries`.`id`, `countries`.`continent_id`,
	`competitions`.`id`, `competitions`.`country_id`, `competitions`.`continent_id`, `competitions`.`start_date`,
	`events`.`id`,
    `round_types`.`id`, `round_types`.`code`, `round_types`.`final`,
    `formats`.`id`, `formats`.`code`,
    `results`.`pos`, `results`.`best`, `results`.`average`,
    -- `results`.`value1`, `results`.`value2`, `results`.`value3`, `results`.`value4`, `results`.`value5`,
    `results`.`regional_single_record`, `results`.`regional_average_record`
FROM `wca`.`results` USE INDEX ()
JOIN `wca_alt`.`persons` ON `persons`.`wca_id` = `results`.`person_id` AND `persons`.`name` = `results`.`person_name`
JOIN `wca_alt`.`countries` ON `countries`.`legacy_id` = `results`.`person_country_id` AND `countries`.`id` = `persons`.`country_id`
JOIN `wca_alt`.`competitions` ON `competitions`.`legacy_id` = `results`.`competition_id`
JOIN `wca_alt`.`events` ON `events`.`legacy_id` = `results`.`event_id`
JOIN `wca_alt`.`round_types` ON `round_types`.`code` = `results`.`round_type_id`
JOIN `wca_alt`.`formats` ON `formats`.`code` = `results`.`format_id`
ORDER BY `persons`.`wca_id`, `competitions`.`id`, `events`.`id`, `round_types`.`id`;
