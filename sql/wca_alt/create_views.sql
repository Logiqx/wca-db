/* --------------------
    Scrambles
   -------------------- */

-- TODO

--   `eventName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
--   `competitionName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
--   `competitionCountryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
--   `competitionContinentName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
--   `roundTypeName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,


/* --------------------
    RanksSingle
   -------------------- */

DROP VIEW IF EXISTS wca_alt.RanksSingleView;

CREATE VIEW wca_alt.RanksSingleView AS
SELECT r.id, r.`personId`, r.`countryId`, r.`continentId`, r.`eventId`,
	p.wcaId, p.name AS personName, p.countryName, p.continentName, e.name AS eventName,
	`best`, `worldRank`, `continentRank`, `countryRank`
FROM `wca_alt`.`RanksSingle` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`;


/* --------------------
    RanksAverage
   -------------------- */

DROP VIEW IF EXISTS wca_alt.RanksAverageView;

CREATE VIEW wca_alt.RanksAverageView AS
SELECT r.id, r.`personId`, r.`countryId`, r.`continentId`, r.`eventId`,
	p.wcaId, p.name AS personName, p.countryName, p.continentName, e.name AS eventName,
	`best`, `worldRank`, `continentRank`, `countryRank`
FROM `wca_alt`.`RanksAverage` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`;


/* --------------------
    Results
   -------------------- */

DROP VIEW IF EXISTS wca_alt.ResultsView;

CREATE VIEW wca_alt.ResultsView
AS
SELECT r.id, r.`personId`, r.`personCountryId`, r.`personContinentId`,
	r.`competitionId`, r.`competitionCountryId`, r.`competitionContinentId`,
	r.`eventId`, r.`roundTypeId`, r.`roundTypeCode`, r.`roundTypeFinal`, r.`formatId`, r.`formatCode`,
    e.name AS eventName, rt.name AS roundTypeName, f.name AS formatName,
    r.`wcaId`, r.`pos`, r.`best`, r.`average`,
	r.`value1`, r.`value2`, r.`value3`, r.`value4`, r.`value5`,
    r.`regionalSingleRecord`, r.`regionalAverageRecord`
FROM `wca_alt`.`Results` AS r
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`
JOIN `wca_alt`.`RoundTypes` AS rt ON rt.`id` = r.`roundTypeId`
JOIN `wca_alt`.`Formats` AS f ON f.`id` = r.`formatId`;


/* --------------------
    PersonResults
   -------------------- */

DROP VIEW IF EXISTS wca_alt.PersonResultsView;

CREATE VIEW wca_alt.PersonResultsView
AS
SELECT r.id, r.`personId`, r.`personCountryId`, r.`personContinentId`,
	r.`competitionId`, r.`competitionCountryId`, r.`competitionContinentId`,
	r.`eventId`, r.`roundTypeId`, r.`roundTypeCode`, r.`roundTypeFinal`, r.`formatId`, r.`formatCode`,
	p.name AS personName, p.CountryName AS personCountryName, p.continentName AS personContinentName, p.gender AS personGender,
    e.name AS eventName, rt.name AS roundTypeName, f.name AS formatName,
    p.`wcaId`, r.`pos`, r.`best`, r.`average`,
	r.`value1`, r.`value2`, r.`value3`, r.`value4`, r.`value5`,
    r.`regionalSingleRecord`, r.`regionalAverageRecord`
FROM `wca_alt`.`Results` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`
JOIN `wca_alt`.`RoundTypes` AS rt ON rt.`id` = r.`roundTypeId`
JOIN `wca_alt`.`Formats` AS f ON f.`id` = r.`formatId`;


/* --------------------
    CompetitionResults
   -------------------- */

DROP VIEW IF EXISTS wca_alt.CompetitionResultsView;

CREATE VIEW wca_alt.CompetitionResultsView
AS
SELECT r.id, r.`personId`, r.`personCountryId`, r.`personContinentId`,
	r.`competitionId`, r.`competitionCountryId`, r.`competitionContinentId`,
	r.`eventId`, r.`roundTypeId`, r.`roundTypeCode`, r.`roundTypeFinal`, r.`formatId`, r.`formatCode`,
	c.name AS competitionName, c.countryName AS competitionCountryName, c.continentName AS competitionContinentName,
    e.name AS eventName, rt.name AS roundTypeName, f.name AS formatName,
    r.`wcaId`, r.`pos`, r.`best`, r.`average`,
	r.`value1`, r.`value2`, r.`value3`, r.`value4`, r.`value5`,
    r.`regionalSingleRecord`, r.`regionalAverageRecord`
FROM `wca_alt`.`Results` AS r
JOIN `wca_alt`.`Competitions` AS c ON c.`id` = r.`competitionId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`
JOIN `wca_alt`.`RoundTypes` AS rt ON rt.`id` = r.`roundTypeId`
JOIN `wca_alt`.`Formats` AS f ON f.`id` = r.`formatId`;


/* --------------------
    Attempts
   -------------------- */

-- TODO
