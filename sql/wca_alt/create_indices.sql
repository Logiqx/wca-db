/* 
    Script:   Create Indices
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create OPTIONAL indices - select them one by one!
*/

/* --------------------
    Persons
   -------------------- */


/* --------------------
    Results
   -------------------- */

CREATE INDEX `Results_roundTypeCode` ON `wcastats`.`Results` (`roundTypeCode`);
CREATE INDEX `Results_formatCode` ON `wcastats`.`Results` (`formatCode`);

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
