/* 
    Script:   Create tables
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create tables in the WCA alternative database
   
    Notes:    Works with v2 results export, but yet to check for new fields
*/

/* --------------------
    events
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`events`;

CREATE TABLE `wca_alt`.`events` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` smallint(3) unsigned NOT NULL,
  `format` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    formats
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`formats`;

CREATE TABLE `wca_alt`.`formats` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_by` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_by_second` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expected_solve_count` tinyint(1) unsigned NOT NULL,
  `trim_fastest_n` tinyint(1) unsigned NOT NULL,
  `trim_slowest_n` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    round_types
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`round_types`;

CREATE TABLE `wca_alt`.`round_types` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cell_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `final` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    continents
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`continents`;

CREATE TABLE `wca_alt`.`continents` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_name` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `zoom` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    countries
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`countries`;

CREATE TABLE `wca_alt`.`countries` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `continent_id` tinyint(1) unsigned NOT NULL,
  `legacy_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continent_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso2` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    competitions
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`competitions`;

CREATE TABLE `wca_alt`.`competitions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` tinyint(3) unsigned NOT NULL,
  `continent_id` tinyint(1) unsigned NOT NULL,
  `legacy_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continent_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `information` mediumtext COLLATE utf8mb4_unicode_ci,
  `year` smallint(4) unsigned NOT NULL,
  `month` tinyint(2) unsigned NOT NULL,
  `day` tinyint(2) unsigned NOT NULL,
  `end_year` smallint(4) unsigned NOT NULL,
  `end_month` tinyint(2) unsigned NOT NULL,
  `end_day` tinyint(2) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `event_specs` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  -- `wca_delegate` text COLLATE utf8mb4_unicode_ci NOT NULL, 
  -- `organiser` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `venue` varchar(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  `venue_address` varchar(191) COLLATE utf8mb4_unicode_ci,
  `venue_details` varchar(191) COLLATE utf8mb4_unicode_ci,
  `external_website` varchar(200) COLLATE utf8mb4_unicode_ci,
  `cell_name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  -- `latitude` int(11) NOT NULL,
  -- `longitude` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    scrambles
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`scrambles`;

CREATE TABLE `wca_alt`.`scrambles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` int(10) unsigned NOT NULL,
  `competition_id` mediumint(8) unsigned NOT NULL,
  `competition_country_id` tinyint(3) unsigned NOT NULL,
  `competition_continent_id` tinyint(1) unsigned NOT NULL,
  `event_id` tinyint(2) unsigned NOT NULL,
  `round_type_id` tinyint(2) unsigned NOT NULL,
  `round_type_code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `round_type_final` tinyint(1) NOT NULL,
  `group_id` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_extra` tinyint(1) NOT NULL,
  `scramble_num` int(11) NOT NULL,
  `scramble` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    persons
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`persons`;

CREATE TABLE `wca_alt`.`persons` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `wca_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_id` tinyint(3) unsigned NOT NULL,
  `country_id` tinyint(3) unsigned NOT NULL,
  `continent_id` tinyint(1) unsigned NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continent_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci,
  `year` smallint(4) unsigned NOT NULL DEFAULT '0',
  `month` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `day` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    ranks_single
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`ranks_single`;

CREATE TABLE `wca_alt`.`ranks_single` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person_id` mediumint(8) unsigned NOT NULL,
  `country_id` tinyint(3) unsigned NOT NULL,
  `continent_id` tinyint(1) unsigned NOT NULL,
  `event_id` tinyint(2) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `world_rank` mediumint(8) unsigned NOT NULL,
  `continent_rank` mediumint(8) unsigned NOT NULL,
  `country_rank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    ranks_average
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`ranks_average`;

CREATE TABLE `wca_alt`.`ranks_average` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person_id` mediumint(8) unsigned NOT NULL,
  `country_id` tinyint(3) unsigned NOT NULL,
  `continent_id` tinyint(1) unsigned NOT NULL,
  `event_id` tinyint(2) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `world_rank` mediumint(8) unsigned NOT NULL,
  `continent_rank` mediumint(8) unsigned NOT NULL,
  `country_rank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    results
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`results`;

CREATE TABLE `wca_alt`.`results` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person_id` mediumint(8) unsigned NOT NULL,
  `person_link_id` mediumint(8) unsigned NOT NULL,
  `person_country_id` tinyint(3) unsigned NOT NULL,
  `person_continent_id` tinyint(1) unsigned NOT NULL,
  `competition_id` mediumint(8) unsigned NOT NULL,
  `competition_country_id` tinyint(3) unsigned NOT NULL,
  `competition_continent_id` tinyint(1) unsigned NOT NULL,
  `competition_date` date NOT NULL,
  `event_id` tinyint(2) unsigned NOT NULL,
  `round_type_id` tinyint(2) unsigned NOT NULL,
  `round_type_code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `round_type_final` tinyint(1) unsigned NOT NULL,
  `format_id` tinyint(1) unsigned NOT NULL,
  `format_code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pos` smallint(5) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `average` int(11) NOT NULL,
  -- `value1` int(11) NOT NULL,
  -- `value2` int(11) NOT NULL,
  -- `value3` int(11) NOT NULL,
  -- `value4` int(11) NOT NULL,
  -- `value5` int(11) NOT NULL,
  `regional_single_record` char(3) COLLATE utf8mb4_unicode_ci,
  `regional_average_record` char(3) COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
