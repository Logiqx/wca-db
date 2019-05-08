/* --------------------
    RanksSingle
   -------------------- */

DROP VIEW IF EXISTS wca_alt.RanksSingleView;

CREATE VIEW wca_alt.RanksSingleView AS
SELECT r.id, p.wcaId, r.`personId`, r.`countryId`, r.`continentId`, r.`eventId`,
	p.name AS personName, c.name AS countryName, c.continentName AS continentName, e.name AS eventName,
	`best`, `worldRank`, `continentRank`, `countryRank`
FROM `wca_alt`.`RanksSingle` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Countries` AS c ON c.`id` = r.`countryId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`;


/* --------------------
    RanksAverage
   -------------------- */

DROP VIEW IF EXISTS wca_alt.RanksAverageView;

CREATE VIEW wca_alt.RanksAverageView AS
SELECT r.id, p.wcaId, r.`personId`, r.`countryId`, r.`continentId`, r.`eventId`,
	p.name AS personName, c.name AS countryName, c.continentName AS continentName, e.name AS eventName,
	`best`, `worldRank`, `continentRank`, `countryRank`
FROM `wca_alt`.`RanksAverage` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Countries` AS c ON c.`id` = r.`countryId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`;


/* --------------------
    Results
   -------------------- */

DROP VIEW IF EXISTS wca_alt.ResultsView;

CREATE VIEW wca_alt.ResultsView
AS
SELECT r.id, p.wcaId, r.`personId`, r.`personCountryId`, r.`personContinentId`,
	r.`competitionId`, r.`competitionCountryId`, r.`competitionContinentId`,
	r.`eventId`, r.`roundTypeId`, r.`roundTypeCode`, r.`roundTypeFinal`, r.`formatId`, r.`formatCode`,
	p.name AS personName, pc.name AS personCountryName, pc.continentName AS personContinentName, p.gender AS personGender,
	c.name AS competitionName, cc.name AS competitionCountryName, cc.continentName AS competitionContinentName,
    e.name AS eventName, rt.name AS roundTypeName, f.name AS formatTypeName,
    r.`pos`, r.`best`, r.`average`,
	r.`value1`, r.`value2`, r.`value3`, r.`value4`, r.`value5`,
    r.`regionalSingleRecord`, r.`regionalAverageRecord`
FROM `wca_alt`.`Results` AS r
JOIN `wca_alt`.`Persons` AS p ON p.`id` = r.`personId`
JOIN `wca_alt`.`Countries` AS pc ON pc.`id` = r.`personCountryId`
JOIN `wca_alt`.`Competitions` AS c ON c.`id` = r.`competitionId`
JOIN `wca_alt`.`Countries` AS cc ON cc.`id` = r.`competitionCountryId`
JOIN `wca_alt`.`Events` AS e ON e.id = r.`eventId`
JOIN `wca_alt`.`RoundTypes` AS rt ON rt.`id` = r.`roundTypeId`
JOIN `wca_alt`.`Formats` AS f ON f.`id` = r.`formatId`;
