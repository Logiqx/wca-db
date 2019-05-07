/* 
    Script:   Create Indices
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create OPTIONAL indices - select them one by one!
*/

/* --------------------
    Persons
   -------------------- */

CREATE INDEX `Persons_name` ON `wcastats`.`Persons` (`name`);
CREATE INDEX `Persons_countryName` ON `wcastats`.`Persons` (`countryName`);
CREATE INDEX `Persons_continentName` ON `wcastats`.`Persons` (`continentName`);


/* --------------------
    RanksSingle
   -------------------- */

CREATE UNIQUE INDEX `RanksSingle_wcaId` ON `wcastats`.`RanksSingle` (`wcaId`);

CREATE INDEX `RanksSingle_personName` ON `wcastats`.`RanksSingle` (`personName`);
CREATE INDEX `RanksSingle_countryName` ON `wcastats`.`RanksSingle` (`countryName`);
CREATE INDEX `RanksSingle_continentName` ON `wcastats`.`RanksSingle` (`continentName`);

CREATE INDEX `RanksSingle_eventName` ON `wcastats`.`RanksSingle` (`eventName`);


/* --------------------
    RanksAverage
   -------------------- */

CREATE UNIQUE INDEX `RanksAverage_wcaId` ON `wcastats`.`RanksAverage` (`wcaId`);

CREATE INDEX `RanksAverage_personName` ON `wcastats`.`RanksAverage` (`personName`);
CREATE INDEX `RanksAverage_countryName` ON `wcastats`.`RanksAverage` (`countryName`);
CREATE INDEX `RanksAverage_continentName` ON `wcastats`.`RanksAverage` (`continentName`);

CREATE INDEX `RanksAverage_eventName` ON `wcastats`.`RanksAverage` (`eventName`);


/* --------------------
    Competitions
   -------------------- */

CREATE INDEX `Competitions_countryName` ON `wcastats`.`Competitions` (`countryName`);
CREATE INDEX `Competitions_continentName` ON `wcastats`.`Competitions` (`continentName`);


/* --------------------
    Results
   -------------------- */

CREATE INDEX `Results_wcaId` ON `wcastats`.`Results` (`wcaId`);

CREATE INDEX `Results_roundTypeCode` ON `wcastats`.`Results` (`roundTypeCode`);
CREATE INDEX `Results_formatCode` ON `wcastats`.`Results` (`formatCode`);

CREATE INDEX `Results_personName` ON `wcastats`.`Results` (`personName`);
CREATE INDEX `Results_personCountryName` ON `wcastats`.`Results` (`personCountryName`);
CREATE INDEX `Results_personContinentName` ON `wcastats`.`Results` (`personContinentName`);

CREATE INDEX `Results_competitionName` ON `wcastats`.`Results` (`competitionName`);
CREATE INDEX `Results_competitionCountryName` ON `wcastats`.`Results` (`competitionCountryName`);
CREATE INDEX `Results_competitionContinentName` ON `wcastats`.`Results` (`competitionContinentName`);

CREATE INDEX `Results_roundTypeName` ON `wcastats`.`Results` (`roundTypeName`);
CREATE INDEX `Results_eventName` ON `wcastats`.`Results` (`eventName`);


/* --------------------
    Scrambles
   -------------------- */

CREATE INDEX `Scrambles_roundTypeCode` ON `wcastats`.`Scrambles` (`roundTypeCode`);

CREATE INDEX `Scrambles_competitionName` ON `wcastats`.`Scrambles` (`competitionName`);
CREATE INDEX `Scrambles_competitionCountryName` ON `wcastats`.`Scrambles` (`competitionCountryName`);
CREATE INDEX `Scrambles_competitionContinentName` ON `wcastats`.`Scrambles` (`competitionContinentName`);

CREATE INDEX `Scrambles_roundTypeName` ON `wcastats`.`Scrambles` (`roundTypeName`);
CREATE INDEX `Scrambles_eventName` ON `wcastats`.`Scrambles` (`eventName`);
