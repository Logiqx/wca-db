/* 
    Script:   Create tables
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create the tables in WCA alternative
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

INSERT INTO `wca_alt`.`Events` (`legacyId`, `name`, `rank`, `format`, `cellName`)
SELECT `id`, `name`, `rank`, `format`, `cellName`
FROM `Events`
ORDER BY `rank`;

CREATE UNIQUE INDEX `Events_legacyId` ON `wca_alt`.`Events` (`legacyId`);


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

INSERT INTO `wca_alt`.`Formats` (`code`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`)
SELECT `id`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`
FROM `wca`.`Formats`
ORDER BY `expected_solve_count`, `name`;

CREATE UNIQUE INDEX `Formats_code` ON `wca_alt`.`Formats` (`code`);


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

INSERT INTO `wca_alt`.`RoundTypes` (`code`, `rank`, `name`, `cellName`, `final`)
SELECT `id`, `rank`, `name`, `cellName`, `final`
FROM `wca`.`RoundTypes`
ORDER BY `rank`;

CREATE UNIQUE INDEX `RoundTypes_code` ON `wca_alt`.`RoundTypes` (`code`);


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

INSERT INTO `wca_alt`.`Continents` (`legacyId`, `name`, `recordName`, `latitude`, `longitude`, `zoom`)
SELECT `id`, `name`, `recordName`, `latitude`, `longitude`, `zoom`
FROM `Continents`
ORDER BY `name`;

CREATE UNIQUE INDEX `Continents_legacyId` ON `wca_alt`.`Continents` (`legacyId`);


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

INSERT INTO `wca_alt`.`Countries` (`continentId`, `legacyId`, `name`, `continentName`, `iso2`)
SELECT `Continents`.`id`, `Countries`.`id`, `Countries`.`name`, `Continents`.`name`, `Countries`.`iso2`
FROM `Countries`
JOIN `wca_alt`.`Continents` ON `Countries`.`continentId` = `Continents`.`legacyId`
ORDER BY `Continents`.`id`, `Countries`.`name`;

CREATE UNIQUE INDEX `Countries_legacyId` ON `wca_alt`.`Countries` (`legacyId`);

CREATE UNIQUE INDEX `Countries_iso2` ON `wca_alt`.`Countries` (`iso2`);


/* --------------------
    Persons
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Persons`;

CREATE TABLE `wca_alt`.`Persons` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subid` tinyint(3) unsigned NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` smallint(4) unsigned NOT NULL DEFAULT '0',
  `month` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `day` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

INSERT INTO `wca_alt`.`Persons` (`countryId`, `continentId`, `wcaId`, `subid`, `name`, `countryName`, `continentName`, `gender`)
SELECT `Countries`.`id`, `Countries`.`continentId`, `Persons`.`id`, `Persons`.`subid`,
	`Persons`.`name`, `Countries`.`name`, `Countries`.`continentName`, `Persons`.`gender`
FROM `wca`.`Persons`
JOIN `wca_alt`.`Countries` ON `Persons`.`countryId` = `Countries`.`legacyId`
ORDER BY `Countries`.`id`, `Persons`.`name`;

CREATE UNIQUE INDEX `Persons_wcaId_subid` ON `wca_alt`.`Persons` (`wcaId`, `subid`);

CREATE INDEX `Persons_countryId` ON `wca_alt`.`Persons` (`countryId`);
CREATE INDEX `Persons_continentId` ON `wca_alt`.`Persons` (`continentId`);


/* --------------------
    RanksSingle
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`RanksSingle`;

CREATE TABLE `wca_alt`.`RanksSingle` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventId` tinyint(2) unsigned NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eventName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `best` int(11) NOT NULL,
  `worldRank` mediumint(8) unsigned NOT NULL,
  `continentRank` mediumint(8) unsigned NOT NULL,
  `countryRank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

INSERT INTO `wca_alt`.`RanksSingle`
	(`eventId`, `personId`, `countryId`, `continentId`,
    `eventName`, `personName`, `countryName`, `continentName`, `wcaId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Events`.`id`, `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`,
	`Events`.`name`, `Persons`.`name`, `Persons`.`countryName`, `Persons`.`continentName`, `Persons`.`wcaId`,
	`RanksSingle`.`best`, `RanksSingle`.`worldRank`, `RanksSingle`.`continentRank`, `RanksSingle`.`countryRank`
FROM `RanksSingle` USE INDEX() -- This isn't strictly necessary but a full table scan will be fastest
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksSingle`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksSingle`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Events`.`id`, `Persons`.`id`;

CREATE UNIQUE INDEX `RanksSingle_eventId_personId` ON `wca_alt`.`RanksSingle` (`eventId`, `personId`);
CREATE INDEX `RanksSingle_eventId_countryId` ON `wca_alt`.`RanksSingle` (`eventId`, `countryId`);
CREATE INDEX `RanksSingle_eventId_continentId` ON `wca_alt`.`RanksSingle` (`eventId`, `continentId`);

CREATE UNIQUE INDEX `RanksSingle_personId_eventId` ON `wca_alt`.`RanksSingle` (`personId`, `eventId`);
CREATE INDEX `RanksSingle_countryId_eventId` ON `wca_alt`.`RanksSingle` (`countryId`, `eventId`);
CREATE INDEX `RanksSingle_continentId_eventId` ON `wca_alt`.`RanksSingle` (`continentId`, `eventId`);


/* --------------------
    RanksAverage
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`RanksAverage`;

CREATE TABLE `wca_alt`.`RanksAverage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventId` tinyint(2) unsigned NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `countryId` tinyint(3) unsigned NOT NULL,
  `continentId` tinyint(1) unsigned NOT NULL,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eventName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `continentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `best` int(11) NOT NULL,
  `worldRank` mediumint(8) unsigned NOT NULL,
  `continentRank` mediumint(8) unsigned NOT NULL,
  `countryRank` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

INSERT INTO `wca_alt`.`RanksAverage`
	(`eventId`, `personId`, `countryId`, `continentId`,
    `eventName`, `personName`, `countryName`, `continentName`, `wcaId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Events`.`id`, `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`,
	`Events`.`name`, `Persons`.`name`, `Persons`.`countryName`, `Persons`.`continentName`, `Persons`.`wcaId`,
	`RanksAverage`.`best`, `RanksAverage`.`worldRank`, `RanksAverage`.`continentRank`, `RanksAverage`.`countryRank`
FROM `RanksAverage` USE INDEX() -- This isn't strictly necessary but a full table scan will be fastest
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksAverage`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksAverage`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Events`.`id`, `Persons`.`id`;

CREATE UNIQUE INDEX `RanksAverage_eventId_personId` ON `wca_alt`.`RanksAverage` (`eventId`, `personId`);
CREATE INDEX `RanksAverage_eventId_countryId` ON `wca_alt`.`RanksAverage` (`eventId`, `countryId`);
CREATE INDEX `RanksAverage_eventId_continentId` ON `wca_alt`.`RanksAverage` (`eventId`, `continentId`);

CREATE UNIQUE INDEX `RanksAverage_personId_eventId` ON `wca_alt`.`RanksAverage` (`personId`, `eventId`);
CREATE INDEX `RanksAverage_countryId_eventId` ON `wca_alt`.`RanksAverage` (`countryId`, `eventId`);
CREATE INDEX `RanksAverage_continentId_eventId` ON `wca_alt`.`RanksAverage` (`continentId`, `eventId`);


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
  `endMonth` tinyint(2) unsigned NOT NULL,
  `endDay` tinyint(2) unsigned NOT NULL,
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

INSERT INTO `wca_alt`.`Competitions`
	(`countryId`, `continentId`, `legacyId`, `name`, `cityName`, `countryName`, `continentName`, `information`,
    `year`, `month`, `day`, `endMonth`, `endDay`, `eventSpecs`, `wcaDelegate`, `organiser`,
    `venue`, `venueAddress`, `venueDetails`, `external_website`, `cellName`, `latitude`, `longitude`)
SELECT `Countries`.`id`, `Countries`.`continentId`, `Competitions`.`id`,
	`Competitions`.`name`, `Competitions`.`cityName`, `Countries`.`name`, `Countries`.`ContinentName`, `Competitions`.`information`,
    `Competitions`.`year`, `Competitions`.`month`, `Competitions`.`day`, `Competitions`.`endMonth`, `Competitions`.`endDay`,
    `Competitions`.`eventSpecs`, `Competitions`.`wcaDelegate`, `Competitions`.`organiser`,
    `Competitions`.`venue`, `Competitions`.`venueAddress`, `Competitions`.`venueDetails`, `Competitions`.`external_website`,
    `Competitions`.`cellName`, `Competitions`.`latitude`, `Competitions`.`longitude`
FROM `wca`.`Competitions`
JOIN `wca_alt`.`Countries` ON `Competitions`.`countryId` = `Countries`.`legacyId`
ORDER BY `Countries`.`id`, `Competitions`.`year`, `Competitions`.`month`, `Competitions`.`day`, `Competitions`.`name`;

CREATE UNIQUE INDEX `Competitions_legacyId` ON `wca_alt`.`Competitions` (`legacyId`);

CREATE INDEX `Competitions_countryId` ON `wca_alt`.`Competitions` (`countryId`);
CREATE INDEX `Competitions_continentId` ON `wca_alt`.`Competitions` (`continentId`);

CREATE INDEX `Competitions_year_month_day` ON `wca_alt`.`Competitions` (`year`, `month`, `day`);


/* --------------------
    Results
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Results`;

CREATE TABLE `wca_alt`.`Results` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventId` tinyint(2) unsigned NOT NULL,
  `personId` mediumint(8) unsigned NOT NULL,
  `personCountryId` tinyint(3) unsigned NOT NULL,
  `personContinentId` tinyint(1) unsigned NOT NULL,
  `competitionId` mediumint(8) unsigned NOT NULL,
  `competitionCountryId` tinyint(3) unsigned NOT NULL,
  `competitionContinentId` tinyint(1) unsigned NOT NULL,
  `roundTypeId` tinyint(2) unsigned NOT NULL,
  `roundTypeCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `formatId` tinyint(1) unsigned NOT NULL,
  `formatCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wcaId` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eventName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personCountryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personContinentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionCountryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionContinentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roundTypeName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `formatName` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
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

INSERT INTO `wca_alt`.`Results`
	(`eventId`, `personId`, `personCountryId`, `personContinentId`,
	`competitionId`, `competitionCountryId`, `competitionContinentId`,
	`roundTypeId`, `roundTypeCode`, `formatId`, `formatCode`,
	`eventName`, `personName`, `personCountryName`, `personContinentName`,
    `wcaId`, `competitionName`, `competitionCountryName`, `competitionContinentName`,
    `roundTypeName`, `formatName`, `pos`, `best`, `average`,
	`value1`, `value2`, `value3`, `value4`, `value5`,
    `regionalSingleRecord`, `regionalAverageRecord`)
SELECT `Events`.`id`, `Persons`.`id`, `Countries`.`id`, `Countries`.`ContinentId`,
	`Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`,
	`RoundTypes`.`id`, `RoundTypes`.`code`, `Formats`.`id`, `Formats`.`code`,
	`Events`.`name`, `Results`.`personName`, `Countries`.`name`, `Countries`.`continentName`,
	`Results`.`personId`, `Competitions`.`name`, `Competitions`.`countryName`, `Competitions`.`continentName`,
	`RoundTypes`.`name`, `Formats`.`name`, `Results`.`pos`, `Results`.`best`, `Results`.`average`,
    `Results`.`value1`, `Results`.`value2`, `Results`.`value3`, `Results`.`value4`, `Results`.`value5`,
    `Results`.`regionalSingleRecord`, `Results`.`regionalAverageRecord`
FROM `wca`.`Results` USE INDEX () -- This isn't strictly necessary but a full table scan will be fastest
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `Results`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `Results`.`personId` AND `Persons`.`subid` = 1
JOIN `wca_alt`.`Countries` ON `Countries`.`legacyId` = `Results`.`personCountryId`
JOIN `wca_alt`.`Competitions` ON `Competitions`.`legacyId` = `Results`.`competitionId`
JOIN `wca_alt`.`RoundTypes` ON `RoundTypes`.`code` = `Results`.`roundTypeId`
JOIN `wca_alt`.`Formats` ON `Formats`.`code` = `Results`.`formatId`
ORDER BY `Events`.`id`, `Persons`.`id`, `Competitions`.`id`, `RoundTypes`.`id`;

CREATE INDEX `Results_eventId_personId` ON `wca_alt`.`Results` (`eventId`, `personId`);
CREATE INDEX `Results_eventId_personCountryId` ON `wca_alt`.`Results` (`eventId`, `personCountryId`);
CREATE INDEX `Results_eventId_personContinentId` ON `wca_alt`.`Results` (`eventId`, `personContinentId`);

CREATE INDEX `Results_personId_eventId` ON `wca_alt`.`Results` (`personId`, `eventId`);
CREATE INDEX `Results_personCountryId_eventId` ON `wca_alt`.`Results` (`personCountryId`, `eventId`);
CREATE INDEX `Results_personContinentId_eventId` ON `wca_alt`.`Results` (`personContinentId`, `eventId`);

CREATE INDEX `Results_eventId_CompetitionId` ON `wca_alt`.`Results` (`eventId`, `CompetitionId`);
CREATE INDEX `Results_eventId_CompetitionCountryId` ON `wca_alt`.`Results` (`eventId`, `CompetitionCountryId`);
CREATE INDEX `Results_eventId_CompetitionContinentId` ON `wca_alt`.`Results` (`eventId`, `CompetitionContinentId`);

CREATE INDEX `Results_competitionId_eventId` ON `wca_alt`.`Results` (`competitionId`, `eventId`);
CREATE INDEX `Results_competitionCountryId_eventId` ON `wca_alt`.`Results` (`competitionCountryId`, `eventId`);
CREATE INDEX `Results_competitionContinentId_eventId` ON `wca_alt`.`Results` (`competitionContinentId`, `eventId`);

CREATE INDEX `Results_roundTypeId` ON `wca_alt`.`Results` (`roundTypeId`);


/* --------------------
    Scrambles
   -------------------- */

DROP TABLE IF EXISTS `wca_alt`.`Scrambles`;

CREATE TABLE `wca_alt`.`Scrambles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `legacyId` int(10) unsigned NOT NULL,
  `eventId` tinyint(2) unsigned NOT NULL,
  `competitionId` mediumint(8) unsigned NOT NULL,
  `competitionCountryId` tinyint(3) unsigned NOT NULL,
  `competitionContinentId` tinyint(1) unsigned NOT NULL,
  `roundTypeId` tinyint(2) unsigned NOT NULL,
  `roundTypeCode` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eventName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionCountryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `competitionContinentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roundTypeName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupId` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isExtra` tinyint(1) NOT NULL,
  `scrambleNum` int(11) NOT NULL,
  `scramble` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

INSERT INTO `wca_alt`.`Scrambles`
	(`legacyId`, `eventId`, `competitionId`, `competitionCountryId`, `competitionContinentId`, `roundTypeId`,
    `roundTypeCode`, `eventName`, `competitionName`, `competitionCountryName`, `competitionContinentName`, `roundTypeName`,
    `groupId`, `isExtra`, `scrambleNum`, `scramble`)
SELECT `Scrambles`.`scrambleId`, `Events`.`id`, `Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`, `RoundTypes`.`id`,
	`Scrambles`.`roundTypeId`, `Events`.`name`, `Competitions`.`name`, `Competitions`.`countryName`, `Competitions`.`continentName`, `RoundTypes`.`name`,
    `Scrambles`.`groupId`, `Scrambles`.`isExtra`, `Scrambles`.`scrambleNum`, `Scrambles`.`scramble`
FROM `Scrambles` USE INDEX () -- This isn't strictly necessary but a full table scan will be fastest
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `Scrambles`.`eventId`
JOIN `wca_alt`.`Competitions` ON `Competitions`.`legacyId` = `Scrambles`.`competitionId`
JOIN `wca_alt`.`RoundTypes` ON `RoundTypes`.`code` = `Scrambles`.`roundTypeId`
ORDER BY `Events`.`id`, `Competitions`.`id`, `RoundTypes`.`id`, `groupId`, `isExtra`, `scrambleNum`;

CREATE INDEX `Scrambles_eventId_CompetitionId` ON `wca_alt`.`Scrambles` (`eventId`, `CompetitionId`);
CREATE INDEX `Scrambles_eventId_CompetitionCountryId` ON `wca_alt`.`Scrambles` (`eventId`, `CompetitionCountryId`);
CREATE INDEX `Scrambles_eventId_CompetitionContinentId` ON `wca_alt`.`Scrambles` (`eventId`, `CompetitionContinentId`);

CREATE INDEX `Scrambles_competitionId_eventId` ON `wca_alt`.`Scrambles` (`competitionId`, `eventId`);
CREATE INDEX `Scrambles_competitionCountryId_eventId` ON `wca_alt`.`Scrambles` (`competitionCountryId`, `eventId`);
CREATE INDEX `Scrambles_competitionContinentId_eventId` ON `wca_alt`.`Scrambles` (`competitionContinentId`, `eventId`);

CREATE INDEX `Scrambles_roundTypeId` ON `wca_alt`.`Scrambles` (`roundTypeId`);
