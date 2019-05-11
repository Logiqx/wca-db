/* 
    Script:   Populate tables
    Created:  2019-05-09
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Populate tables in the WCA alternative database
*/

/* --------------------
    Events
   -------------------- */

INSERT INTO `wca_alt`.`Events` (`legacyId`, `name`, `rank`, `format`, `cellName`)
SELECT `id`, `name`, `rank`, `format`, `cellName`
FROM `Events`
ORDER BY `rank`;

CREATE UNIQUE INDEX `Events_legacyId` ON `wca_alt`.`Events` (`legacyId`);


/* --------------------
    Formats
   -------------------- */

INSERT INTO `wca_alt`.`Formats` (`code`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`)
SELECT `id`, `name`, `sort_by`, `sort_by_second`, `expected_solve_count`, `trim_fastest_n`, `trim_slowest_n`
FROM `wca`.`Formats`
ORDER BY `expected_solve_count`, `name`;

CREATE UNIQUE INDEX `Formats_code` ON `wca_alt`.`Formats` (`code`);


/* --------------------
    RoundTypes
   -------------------- */

INSERT INTO `wca_alt`.`RoundTypes` (`code`, `rank`, `name`, `cellName`, `final`)
SELECT `id`, `rank`, `name`, `cellName`, `final`
FROM `wca`.`RoundTypes`
ORDER BY `rank`;

CREATE UNIQUE INDEX `RoundTypes_code` ON `wca_alt`.`RoundTypes` (`code`);


/* --------------------
    Continents
   -------------------- */

INSERT INTO `wca_alt`.`Continents` (`legacyId`, `name`, `recordName`, `latitude`, `longitude`, `zoom`)
SELECT `id`, `name`, `recordName`, `latitude`, `longitude`, `zoom`
FROM `Continents`
ORDER BY `name`;

CREATE UNIQUE INDEX `Continents_legacyId` ON `wca_alt`.`Continents` (`legacyId`);


/* --------------------
    Countries
   -------------------- */

INSERT INTO `wca_alt`.`Countries` (`continentId`, `legacyId`, `name`, `continentName`, `iso2`)
SELECT `Continents`.`id`, `Countries`.`id`, `Countries`.`name`, `Continents`.`name`, `Countries`.`iso2`
FROM `Countries`
JOIN `wca_alt`.`Continents` ON `Countries`.`continentId` = `Continents`.`legacyId`
ORDER BY `Countries`.`name`;

CREATE UNIQUE INDEX `Countries_legacyId` ON `wca_alt`.`Countries` (`legacyId`);


/* --------------------
    Competitions
   -------------------- */

INSERT INTO `wca_alt`.`Competitions`
	(`countryId`, `continentId`, `legacyId`, `name`, `cityName`, `countryName`, `continentName`, `information`,
    `year`, `month`, `day`, `endYear`,
    `endMonth`, `endDay`,
    `start_date`, `end_date`,
    `eventSpecs`, `wcaDelegate`, `organiser`,
    `venue`, `venueAddress`, `venueDetails`, `external_website`, `cellName`, `latitude`, `longitude`)
SELECT `Countries`.`id`, `Countries`.`continentId`, `Competitions`.`id`,
	`Competitions`.`name`, `Competitions`.`cityName`, `Countries`.`name`, `Countries`.`ContinentName`, `Competitions`.`information`,
    `Competitions`.`year`, `Competitions`.`month`, `Competitions`.`day`,
    CASE WHEN `Competitions`.`endMonth` >= `Competitions`.`month` THEN `Competitions`.`year` ELSE `Competitions`.`year` + 1 END,
		`Competitions`.`endMonth`, `Competitions`.`endDay`,
    DATE_FORMAT(CONCAT(`Competitions`.`year`, "-", `Competitions`.`month`, "-", `Competitions`.`day`), "%Y-%m-%d"),
    DATE_FORMAT(CONCAT(CASE WHEN `Competitions`.`endMonth` >= `Competitions`.`month` THEN `Competitions`.`year` ELSE `Competitions`.`year` + 1 END,
		"-", `Competitions`.`endMonth`, "-", `Competitions`.`endDay`), "%Y-%m-%d"),
    `Competitions`.`eventSpecs`, `Competitions`.`wcaDelegate`, `Competitions`.`organiser`,
    `Competitions`.`venue`, `Competitions`.`venueAddress`, `Competitions`.`venueDetails`, `Competitions`.`external_website`,
    `Competitions`.`cellName`, `Competitions`.`latitude`, `Competitions`.`longitude`
FROM `wca`.`Competitions`
JOIN `wca_alt`.`Countries` ON `Competitions`.`countryId` = `Countries`.`legacyId`
ORDER BY `Competitions`.`year`, `Competitions`.`month`, `Competitions`.`day`, `Countries`.`id`, `Competitions`.`name`;

CREATE UNIQUE INDEX `Competitions_legacyId` ON `wca_alt`.`Competitions` (`legacyId`);


/* --------------------
    Scrambles
   -------------------- */

INSERT INTO `wca_alt`.`Scrambles`
	(`legacyId`, `eventId`, `competitionId`,
	`competitionCountryId`, `competitionContinentId`,
    `roundTypeId`, `roundTypeCode`,
    `groupId`, `isExtra`, `scrambleNum`, `scramble`)
SELECT `Scrambles`.`scrambleId`, `Events`.`id`,
	`Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`,
    `RoundTypes`.`id`, `Scrambles`.`roundTypeId`,
    `Scrambles`.`groupId`, `Scrambles`.`isExtra`, `Scrambles`.`scrambleNum`, `Scrambles`.`scramble`
FROM `Scrambles`
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `Scrambles`.`eventId`
JOIN `wca_alt`.`Competitions` ON `Competitions`.`legacyId` = `Scrambles`.`competitionId`
JOIN `wca_alt`.`RoundTypes` ON `RoundTypes`.`code` = `Scrambles`.`roundTypeId`
ORDER BY `Competitions`.`id`, `Events`.`id`, `RoundTypes`.`id`, `groupId`, `isExtra`, `scrambleNum`;


/* --------------------
    Persons
   -------------------- */

INSERT INTO `wca_alt`.`Persons` (`wcaId`, `subid`, `countryId`, `continentId`, `name`, `countryName`, `continentName`, `gender`)
SELECT `Persons`.`id`, `Persons`.`subid`, `Countries`.`id`, `Countries`.`continentId`,
	`Persons`.`name`, `Countries`.`name`, `Countries`.`continentName`, `Persons`.`gender`
FROM `wca`.`Persons`
JOIN `wca_alt`.`Countries` ON `Persons`.`countryId` = `Countries`.`legacyId`
ORDER BY `Persons`.`id`, `Persons`.`subid` DESC;

CREATE UNIQUE INDEX `Persons_wcaId_subid` ON `wca_alt`.`Persons` (`wcaId`, `subid`);


/* --------------------
    RanksSingle
   -------------------- */

INSERT INTO `wca_alt`.`RanksSingle`
	(`personId`, `countryId`, `continentId`, `eventId`, `wcaId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`, `Events`.`id`, `RanksSingle`.`personId`,
	`RanksSingle`.`best`, `RanksSingle`.`worldRank`, `RanksSingle`.`continentRank`, `RanksSingle`.`countryRank`
FROM `RanksSingle` USE INDEX ()
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksSingle`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksSingle`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Persons`.`id`, `Events`.`id`;


/* --------------------
    RanksAverage
   -------------------- */

INSERT INTO `wca_alt`.`RanksAverage`
	(`personId`, `countryId`, `continentId`, `eventId`, `wcaId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`, `Events`.`id`, `RanksAverage`.`personId`,
	`RanksAverage`.`best`, `RanksAverage`.`worldRank`, `RanksAverage`.`continentRank`, `RanksAverage`.`countryRank`
FROM `RanksAverage` USE INDEX ()
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksAverage`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksAverage`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Persons`.`id`, `Events`.`id`;


/* --------------------
    Results
   -------------------- */

INSERT INTO `wca_alt`.`Results`
	(`personId`,
    `personCountryId`, `personContinentId`,
	`competitionId`, `competitionCountryId`, `competitionContinentId`,
	`eventId`,
    `roundTypeId`, `roundTypeCode`, `roundTypeFinal`,
	`formatId`, `formatCode`,
    `wcaId`, `pos`, `best`, `average`,
	`value1`, `value2`, `value3`, `value4`, `value5`,
    `regionalSingleRecord`, `regionalAverageRecord`)
SELECT `Persons`.`id`,
	`Countries`.`id`, `Countries`.`ContinentId`,
	`Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`,
	`Events`.`id`,
    `RoundTypes`.`id`, `RoundTypes`.`code`, `RoundTypes`.`final`,
    `Formats`.`id`, `Formats`.`code`,
    `Results`.`personId`, `Results`.`pos`, `Results`.`best`, `Results`.`average`,
    `Results`.`value1`, `Results`.`value2`, `Results`.`value3`, `Results`.`value4`, `Results`.`value5`,
    `Results`.`regionalSingleRecord`, `Results`.`regionalAverageRecord`
FROM `wca`.`Results` USE INDEX ()
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `Results`.`personId` AND `Persons`.`name` = `Results`.`personName`
JOIN `wca_alt`.`Countries` ON `Countries`.`legacyId` = `Results`.`personCountryId` AND `Countries`.`id` = `Persons`.`countryId`
JOIN `wca_alt`.`Competitions` ON `Competitions`.`legacyId` = `Results`.`competitionId`
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `Results`.`eventId`
JOIN `wca_alt`.`RoundTypes` ON `RoundTypes`.`code` = `Results`.`roundTypeId`
JOIN `wca_alt`.`Formats` ON `Formats`.`code` = `Results`.`formatId`
ORDER BY `Persons`.`id`, `Competitions`.`id`, `Events`.`id`, `RoundTypes`.`id`;


/* --------------------
    Attempts
   -------------------- */

INSERT INTO `wca_alt`.`Attempts`
	(`resultId`, `eventId`, `personId`, -- `personCountryId`, `personContinentId`,
	`competitionId`, -- `competitionCountryId`, `competitionContinentId`,
	`roundTypeId`, -- `roundTypeCode`,
    `formatId`, -- `formatCode`,
	-- `eventName`, `personName`, `personCountryName`, `personContinentName`,
    -- `wcaId`, `competitionName`, `competitionCountryName`, `competitionContinentName`,
    -- `roundTypeName`, `formatName`, `pos`, `best`, `average`,
	`attempt`, `value`, `average`,
    `regionalSingleRecord`, `regionalAverageRecord`)
WITH r AS
(
	SELECT `id`, `eventId`, `personId`, -- `personCountryId`, `personContinentId`,
		`competitionId`, -- `competitionCountryId`, `competitionContinentId`,
		`roundTypeId`, -- `roundTypeCode`,
		`formatId`, -- `formatCode`,
		-- `eventName`, `personName`, `personCountryName`, `personContinentName`,
		-- `wcaId`, `competitionName`, `competitionCountryName`, `competitionContinentName`,
		-- `roundTypeName`, `formatName`, `pos`, `best`, `average`,
		`seq`,
		CASE
			WHEN seq = 1 THEN value1 WHEN seq = 2 THEN value2 WHEN seq = 3 THEN value3 WHEN seq = 4 THEN value4 WHEN seq = 5 THEN value5
		END AS value,
		`average`,
		`regionalSingleRecord`, `regionalAverageRecord`
	FROM `wca_alt`.`Results`
	JOIN `seq_1_to_5`)
SELECT *
FROM r
WHERE value != 0;
