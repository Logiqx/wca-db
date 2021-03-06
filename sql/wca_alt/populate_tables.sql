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
    DATE_FORMAT(CONCAT(`Competitions`.`year`, "-", `Competitions`.`month`, "-", `Competitions`.`day`), "%Y-%m-%d") AS start_date,
    DATE_FORMAT(CONCAT(CASE WHEN `Competitions`.`endMonth` >= `Competitions`.`month` THEN `Competitions`.`year` ELSE `Competitions`.`year` + 1 END,
		"-", `Competitions`.`endMonth`, "-", `Competitions`.`endDay`), "%Y-%m-%d") AS end_date,
    `Competitions`.`eventSpecs`, `Competitions`.`wcaDelegate`, `Competitions`.`organiser`,
    `Competitions`.`venue`, `Competitions`.`venueAddress`, `Competitions`.`venueDetails`, `Competitions`.`external_website`,
    `Competitions`.`cellName`, `Competitions`.`latitude`, `Competitions`.`longitude`
FROM `wca`.`Competitions`
JOIN `wca_alt`.`Countries` ON `Competitions`.`countryId` = `Countries`.`legacyId`
ORDER BY start_date, end_date, `Competitions`.`name`;

CREATE UNIQUE INDEX `Competitions_legacyId` ON `wca_alt`.`Competitions` (`legacyId`);


/* --------------------
    Scrambles
   -------------------- */

INSERT INTO `wca_alt`.`Scrambles`
	(`legacyId`, `competitionId`, `competitionCountryId`, `competitionContinentId`,
    `eventId`, `roundTypeId`, `roundTypeCode`, `roundTypeFinal`,
    `groupId`, `isExtra`, `scrambleNum`, `scramble`)
SELECT `Scrambles`.`scrambleId`, `Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`,
    `Events`.`id`, `RoundTypes`.`id`, `RoundTypes`.`code`, `RoundTypes`.`final`,
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

UPDATE `wca_alt`.`Persons` AS p1
INNER JOIN `wca_alt`.`Persons` AS p2 ON p2.`wcaId` = p1.`wcaId` AND p2.`subid` = 1
SET p1.`linkId` = p2.`id`;


/* --------------------
    RanksSingle
   -------------------- */

INSERT INTO `wca_alt`.`RanksSingle`
	(`personId`, `countryId`, `continentId`, `eventId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`, `Events`.`id`,
	`RanksSingle`.`best`, `RanksSingle`.`worldRank`, `RanksSingle`.`continentRank`, `RanksSingle`.`countryRank`
FROM `RanksSingle` USE INDEX ()
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksSingle`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksSingle`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Persons`.`id`, `Events`.`id`;


/* --------------------
    RanksAverage
   -------------------- */

INSERT INTO `wca_alt`.`RanksAverage`
	(`personId`, `countryId`, `continentId`, `eventId`,
    `best`, `worldRank`, `continentRank`, `countryRank`)
SELECT `Persons`.`id`, `Persons`.`countryId`, `Persons`.`continentId`, `Events`.`id`,
	`RanksAverage`.`best`, `RanksAverage`.`worldRank`, `RanksAverage`.`continentRank`, `RanksAverage`.`countryRank`
FROM `RanksAverage` USE INDEX ()
JOIN `wca_alt`.`Events` ON `Events`.`legacyId` = `RanksAverage`.`eventId`
JOIN `wca_alt`.`Persons` ON `Persons`.`wcaId` = `RanksAverage`.`personId` AND `Persons`.`subid` = 1
ORDER BY `Persons`.`id`, `Events`.`id`;


/* --------------------
    Results
   -------------------- */

INSERT INTO `wca_alt`.`Results`
	(`personId`, `personLinkId`,
    `personCountryId`, `personContinentId`,
	`competitionId`, `competitionCountryId`, `competitionContinentId`, `competitionDate`,
	`eventId`,
    `roundTypeId`, `roundTypeCode`, `roundTypeFinal`,
	`formatId`, `formatCode`,
    `pos`, `best`, `average`,
	`value1`, `value2`, `value3`, `value4`, `value5`,
    `regionalSingleRecord`, `regionalAverageRecord`)
SELECT `Persons`.`id`, `Persons`.`linkId`,
	`Countries`.`id`, `Countries`.`ContinentId`,
	`Competitions`.`id`, `Competitions`.`countryId`, `Competitions`.`continentId`, `Competitions`.`start_date`,
	`Events`.`id`,
    `RoundTypes`.`id`, `RoundTypes`.`code`, `RoundTypes`.`final`,
    `Formats`.`id`, `Formats`.`code`,
    `Results`.`pos`, `Results`.`best`, `Results`.`average`,
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
	(`personId`, `personLinkId`, `competitionId`, `competitionDate`, `eventId`,
    `roundTypeId`, `roundTypeFinal`, `formatId`,
	`pos`, `best`, `average`, `attempt`,
    `value`, `resultSingle`, `resultAverage`, `isDnfSingle`, `isDnfAverage`,
    `regionalSingleRecord`, `regionalAverageRecord`)
WITH cte AS
(
	SELECT `personId`, `personLinkId`, `competitionId`, `competitionDate`, `eventId`,
		`roundTypeId`, `roundTypeFinal`, `formatId`,
		`pos`, `best`, `average`, `seq`,
        @value := CASE WHEN seq = 1 THEN value1 WHEN seq = 2 THEN value2 WHEN seq = 3 THEN value3 WHEN seq = 4 THEN value4 WHEN seq = 5 THEN value5 END AS value,
        IF(@value > 0, @value, NULL) AS resultSingle,
        IF(average > 0, average, NULL) AS resultAverage,
        IF(@value = -1, 1, 0) AS isDnfSingle,
        IF(average = -1, 1, 0) AS isDnfAverage,
        IF(regionalSingleRecord != '' AND @value = best, regionalSingleRecord, '') AS regionalSingleRecord,
        `regionalAverageRecord`
	FROM `wca_alt`.`Results`
	JOIN `seq_1_to_5`
)
SELECT *
FROM cte
WHERE value NOT IN (0, -2);
