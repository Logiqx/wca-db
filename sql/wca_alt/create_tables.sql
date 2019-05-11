/* 
    Script:   Create tables
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create tables in the WCA alternative database
*/

/* --------------------
    Events
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Events`;

CREATE TABLE `wca_alt`.`Events` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `legacyId` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` smallint(3) unsigned NOT NULL,
  `format` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cellName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    Formats
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Formats`;

CREATE TABLE `wca_alt`.`Formats` (
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
    RoundTypes
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`RoundTypes`;

CREATE TABLE `wca_alt`.`RoundTypes` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cellName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `final` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    Continents
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Continents`;

CREATE TABLE `wca_alt`.`Continents` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `legacyId` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recordName` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `zoom` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    Countries
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Countries`;

CREATE TABLE `wca_alt`.`Countries` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `continentId` tinyint(1) unsigned NOT NULL,
  `legacyId` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso2` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/* --------------------
    Competitions
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Competitions`;

CREATE TABLE `wca_alt`.`Competitions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `legacyId` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cityName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `information` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` smallint(4) unsigned NOT NULL,
  `month` tinyint(2) unsigned NOT NULL,
  `day` tinyint(2) unsigned NOT NULL,
  `endYear` smallint(4) unsigned NOT NULL,
  `endMonth` tinyint(2) unsigned NOT NULL,
  `endDay` tinyint(2) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `eventSpecs` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wcaDelegate` text COLLATE utf8mb4_unicode_ci NOT NULL, 
  `organiser` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `venue` varchar(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  `venueAddress` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `venueDetails` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_website` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cellName` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    Scrambles
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Scrambles`;

CREATE TABLE `wca_alt`.`Scrambles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `legacyId` int(10) unsigned NOT NULL,
  `competitionId` mediumint(8) unsigned NOT NULL,
  `competitionCountryId` tinyint(3) unsigned NOT NULL,
  `competitionContinentId` tinyint(1) unsigned NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `roundTypeId` tinyint(2) unsigned NOT NULL,
  `roundTypeCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roundTypeFinal` tinyint(1) NOT NULL,
  `groupId` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isExtra` tinyint(1) NOT NULL,
  `scrambleNum` int(11) NOT NULL,
  `scramble` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    Persons
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Persons`;

CREATE TABLE `wca_alt`.`Persons` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subid` tinyint(3) unsigned NOT NULL,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` smallint(4) unsigned NOT NULL DEFAULT '0',
  `month` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `day` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    RanksSingle
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`RanksSingle`;

CREATE TABLE `wca_alt`.`RanksSingle` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `worldRank` mediumint(8) unsigned NOT NULL,
  `continentRank` mediumint(8) unsigned NOT NULL,
  `countryRank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    RanksAverage
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`RanksAverage`;

CREATE TABLE `wca_alt`.`RanksAverage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `worldRank` mediumint(8) unsigned NOT NULL,
  `continentRank` mediumint(8) unsigned NOT NULL,
  `countryRank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    Results
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Results`;

CREATE TABLE `wca_alt`.`Results` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `personCountryId` tinyint(3) unsigned NOT NULL,
  `personContinentId` tinyint(1) unsigned NOT NULL,
  `competitionId` mediumint(8) unsigned NOT NULL,
  `competitionCountryId` tinyint(3) unsigned NOT NULL,
  `competitionContinentId` tinyint(1) unsigned NOT NULL,
  `competitionDate` date NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `roundTypeId` tinyint(2) unsigned NOT NULL,
  `roundTypeCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roundTypeFinal` tinyint(1) unsigned NOT NULL,
  `formatId` tinyint(1) unsigned NOT NULL,
  `formatCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pos` smallint(5) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `average` int(11) NOT NULL,
  `value1` int(11) NOT NULL,
  `value2` int(11) NOT NULL,
  `value3` int(11) NOT NULL,
  `value4` int(11) NOT NULL,
  `value5` int(11) NOT NULL,
  `regionalSingleRecord` char(3) COLLATE utf8mb4_unicode_ci,
  `regionalAverageRecord` char(3) COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;


/* --------------------
    Attempts
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Attempts`;

CREATE TABLE `wca_alt`.`Attempts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `competitionId` mediumint(8) unsigned NOT NULL,
  `competitionDate` date NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `roundTypeId` tinyint(2) unsigned NOT NULL,
  `roundTypeFinal` tinyint(1) unsigned NOT NULL,
  `formatId` tinyint(1) unsigned NOT NULL,
  `pos` smallint(5) unsigned NOT NULL,
  `best` int(11) NOT NULL,
  `average` int(11) NOT NULL,
  `attempt` tinyint(1) unsigned NOT NULL,
  `value` int(11) NOT NULL,
  `resultSingle` int(11) NULL,
  `resultAverage` int(11) NULL,
  `isDnfSingle` tinyint(1) unsigned NOT NULL,
  `isDnfAverage` tinyint(1) unsigned NOT NULL,
  `regionalSingleRecord` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `regionalAverageRecord` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
