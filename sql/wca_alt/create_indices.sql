/* 
    Script:   Create Indices
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create OPTIONAL indices - select them one by one!
*/

/* --------------------
    Events
   -------------------- */

CREATE UNIQUE INDEX `Events_name` ON `wca_alt`.`Events` (`name`);


/* --------------------
    Formats
   -------------------- */

CREATE UNIQUE INDEX `Formats_name` ON `wca_alt`.`Formats` (`name`);


/* --------------------
    RoundTypes
   -------------------- */

CREATE UNIQUE INDEX `RoundTypes_name` ON `wca_alt`.`RoundTypes` (`name`);


/* --------------------
    Continents
   -------------------- */

CREATE UNIQUE INDEX `Continents_name` ON `wca_alt`.`Continents` (`name`);


/* --------------------
    Countries
   -------------------- */

CREATE UNIQUE INDEX `Countries_iso2` ON `wca_alt`.`Countries` (`iso2`);
CREATE UNIQUE INDEX `Countries_name` ON `wca_alt`.`Countries` (`name`);
CREATE INDEX `Countries_continentName` ON `wca_alt`.`Countries` (`continentName`);


/* --------------------
    Competitions
   -------------------- */

CREATE UNIQUE INDEX `Competitions_name` ON `wca_alt`.`Competitions` (`name`);
CREATE INDEX `Competitions_countryName` ON `wca_alt`.`Competitions` (`countryName`);
CREATE INDEX `Competitions_continentName` ON `wca_alt`.`Competitions` (`continentName`);
CREATE INDEX `Competitions_year_month_day` ON `wca_alt`.`Competitions` (`year`, `month`, `day`);
CREATE INDEX `Competitions_start_date` ON `wca_alt`.`Competitions` (`start_date`);


/* --------------------
    Scrambles
   -------------------- */

CREATE INDEX `Scrambles_competitionId_eventId` ON `wca_alt`.`Scrambles` (`competitionId`, `eventId`);
CREATE INDEX `Scrambles_competitionCountryId_eventId` ON `wca_alt`.`Scrambles` (`competitionCountryId`, `eventId`);
CREATE INDEX `Scrambles_competitionContinentId_eventId` ON `wca_alt`.`Scrambles` (`competitionContinentId`, `eventId`);
CREATE INDEX `Scrambles_eventId` ON `wca_alt`.`Scrambles` (`eventId`);


/* --------------------
    Persons
   -------------------- */

CREATE INDEX `Persons_name` ON `wca_alt`.`Persons` (`name`);
CREATE INDEX `Persons_countryName` ON `wca_alt`.`Persons` (`countryName`);
CREATE INDEX `Persons_continentName` ON `wca_alt`.`Persons` (`continentName`);


/* --------------------
    RanksSingle
   -------------------- */

CREATE UNIQUE INDEX `RanksSingle_personId_eventId` ON `wca_alt`.`RanksSingle` (`personId`, `eventId`);
CREATE INDEX `RanksSingle_countryId_eventId` ON `wca_alt`.`RanksSingle` (`countryId`, `eventId`);
CREATE INDEX `RanksSingle_continentId_eventId` ON `wca_alt`.`RanksSingle` (`continentId`, `eventId`);
CREATE INDEX `RanksSingle_eventId` ON `wca_alt`.`RanksSingle` (`eventId`);


/* --------------------
    RanksAverage
   -------------------- */

CREATE UNIQUE INDEX `RanksAverage_personId_eventId` ON `wca_alt`.`RanksAverage` (`personId`, `eventId`);
CREATE INDEX `RanksAverage_countryId_eventId` ON `wca_alt`.`RanksAverage` (`countryId`, `eventId`);
CREATE INDEX `RanksAverage_continentId_eventId` ON `wca_alt`.`RanksAverage` (`continentId`, `eventId`);
CREATE INDEX `RanksAverage_eventId` ON `wca_alt`.`RanksAverage` (`eventId`);


/* --------------------
    Results
   -------------------- */

CREATE INDEX `Results_personId_eventId` ON `wca_alt`.`Results` (`personId`, `eventId`);
CREATE INDEX `Results_personCountryId_eventId` ON `wca_alt`.`Results` (`personCountryId`, `eventId`);
CREATE INDEX `Results_personContinentId_eventId` ON `wca_alt`.`Results` (`personContinentId`, `eventId`);
CREATE INDEX `Results_eventId` ON `wca_alt`.`Results` (`eventId`);
