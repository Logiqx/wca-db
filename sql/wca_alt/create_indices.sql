/* 
    Script:   Create Indices
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create OPTIONAL indices - select them one by one!
*/

/* --------------------
    events
   -------------------- */

CREATE UNIQUE INDEX `events_name` ON `wca_alt`.`events` (`name`);


/* --------------------
    formats
   -------------------- */

CREATE UNIQUE INDEX `formats_name` ON `wca_alt`.`formats` (`name`);


/* --------------------
    round_types
   -------------------- */

CREATE UNIQUE INDEX `round_types_name` ON `wca_alt`.`round_types` (`name`);


/* --------------------
    continents
   -------------------- */

CREATE UNIQUE INDEX `continents_name` ON `wca_alt`.`continents` (`name`);


/* --------------------
    countries
   -------------------- */

CREATE UNIQUE INDEX `countries_iso2` ON `wca_alt`.`countries` (`iso2`);
CREATE UNIQUE INDEX `countries_name` ON `wca_alt`.`countries` (`name`);
CREATE INDEX `countries_continent_name` ON `wca_alt`.`countries` (`continent_name`);


/* --------------------
    competitions
   -------------------- */

CREATE INDEX `competitions_name` ON `wca_alt`.`competitions` (`name`);
CREATE INDEX `competitions_country_name` ON `wca_alt`.`competitions` (`country_name`);
CREATE INDEX `competitions_continent_name` ON `wca_alt`.`competitions` (`continent_name`);
CREATE INDEX `competitions_year_month_day` ON `wca_alt`.`competitions` (`year`, `month`, `day`);
CREATE INDEX `competitions_start_date` ON `wca_alt`.`competitions` (`start_date`);


/* --------------------
    scrambles
   -------------------- */

CREATE INDEX `scrambles_competition_id_event_id` ON `wca_alt`.`scrambles` (`competition_id`, `event_id`);
CREATE INDEX `scrambles_competition_country_id_event_id` ON `wca_alt`.`scrambles` (`competition_country_id`, `event_id`);
CREATE INDEX `scrambles_competition_continent_id_event_id` ON `wca_alt`.`scrambles` (`competition_continent_id`, `event_id`);
CREATE INDEX `scrambles_event_id` ON `wca_alt`.`scrambles` (`event_id`);


/* --------------------
    persons
   -------------------- */

CREATE INDEX `persons_name` ON `wca_alt`.`persons` (`name`);
CREATE INDEX `persons_country_name` ON `wca_alt`.`persons` (`country_name`);
CREATE INDEX `persons_continent_name` ON `wca_alt`.`persons` (`continent_name`);


/* --------------------
    ranks_single
   -------------------- */

CREATE UNIQUE INDEX `ranks_single_person_id_event_id` ON `wca_alt`.`ranks_single` (`person_id`, `event_id`);
CREATE INDEX `ranks_single_country_id_event_id` ON `wca_alt`.`ranks_single` (`country_id`, `event_id`);
CREATE INDEX `ranks_single_continent_id_event_id` ON `wca_alt`.`ranks_single` (`continent_id`, `event_id`);
CREATE INDEX `ranks_single_event_id` ON `wca_alt`.`ranks_single` (`event_id`);


/* --------------------
    ranks_average
   -------------------- */

CREATE UNIQUE INDEX `ranks_average_person_id_event_id` ON `wca_alt`.`ranks_average` (`person_id`, `event_id`);
CREATE INDEX `ranks_average_country_id_event_id` ON `wca_alt`.`ranks_average` (`country_id`, `event_id`);
CREATE INDEX `ranks_average_continent_id_event_id` ON `wca_alt`.`ranks_average` (`continent_id`, `event_id`);
CREATE INDEX `ranks_average_event_id` ON `wca_alt`.`ranks_average` (`event_id`);


/* --------------------
    results
   -------------------- */

CREATE INDEX `results_person_id_event_id` ON `wca_alt`.`results` (`person_id`, `event_id`);
CREATE INDEX `results_person_country_id_event_id` ON `wca_alt`.`results` (`person_country_id`, `event_id`);
CREATE INDEX `results_person_continent_id_event_id` ON `wca_alt`.`results` (`person_continent_id`, `event_id`);
CREATE INDEX `results_event_id` ON `wca_alt`.`results` (`event_id`);
