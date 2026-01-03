/* --------------------
    Scrambles
   -------------------- */

DROP VIEW IF EXISTS wca_alt.scrambles_view;

CREATE VIEW wca_alt.scrambles_view AS
SELECT s.id,
	c.name AS competition_name, c.country_name AS competition_country_name, c.continent_name AS competition_continent_name, e.name AS event_name, rt.name AS round_type_name,
	s.legacy_id, s.competition_id, s.competition_country_id, s.competition_continent_id, s.event_id, s.round_type_id, s.round_type_code, s.round_type_final,
    s.group.wca_id, s.is_extra, s.scramble_num, s.scramble
FROM wca_alt.scrambles AS s
JOIN wca_alt.events AS e ON e.id = s.event_id
JOIN wca_alt.competitions AS c ON c.id = s.competition_id
JOIN wca_alt.round_types AS rt ON rt.id = s.round_type_id;


/* --------------------
    ranks_single
   -------------------- */

DROP VIEW IF EXISTS wca_alt.ranks_single_view;

CREATE VIEW wca_alt.ranks_single_view AS
SELECT r.id,
	p.name AS person_name, p.country_name, p.continent_name, p.gender AS person_gender, e.name AS event_name,
    r.person_id, r.country_id, r.continent_id, r.event_id,
	best, world_rank, continent_rank, country_rank
FROM wca_alt.ranks_single AS r
JOIN wca_alt.persons AS p ON p.wca_id = r.person_id
JOIN wca_alt.events AS e ON e.id = r.event_id;


/* --------------------
    ranks_average
   -------------------- */

DROP VIEW IF EXISTS wca_alt.ranks_average_view;

CREATE VIEW wca_alt.ranks_average_view AS
SELECT r.id,
	p.name AS person_name, p.country_name, p.continent_name, p.gender AS person_gender, e.name AS event_name,
    r.person_id, r.country_id, r.continent_id, r.event_id,
	best, world_rank, continent_rank, country_rank
FROM wca_alt.ranks_average AS r
JOIN wca_alt.persons AS p ON p.wca_id = r.person_id
JOIN wca_alt.events AS e ON e.id = r.event_id;


/* --------------------
    results
   -------------------- */

DROP VIEW IF EXISTS wca_alt.results_view;

CREATE VIEW wca_alt.results_view
AS
SELECT r.id,
    e.name AS event_name, rt.name AS round_type_name, f.name AS format_name,
	r.person_id, r.person_link_id, r.person_country_id, r.person_continent_id,
	r.competition_id, r.competition_country_id, r.competition_continent_id, r.competition_date,
	r.event_id, r.round_type_id, r.round_type_code, r.round_type_final, r.format_id, r.format_code,
    r.pos, r.best, r.average,
	r.value1, r.value2, r.value3, r.value4, r.value5,
    r.regional_single_record, r.regional_average_record
FROM wca_alt.results AS r
JOIN wca_alt.events AS e ON e.id = r.event_id
JOIN wca_alt.round_types AS rt ON rt.id = r.round_type_id
JOIN wca_alt.formats AS f ON f.id = r.format_id;


/* --------------------
    person_results
   -------------------- */

DROP VIEW IF EXISTS wca_alt.person_results_view;

CREATE VIEW wca_alt.person_results_view
AS
SELECT r.id, p.wca_id,
    p.name AS person_name, p.country_name AS person_country_name, p.continent_name AS person_continent_name, p.gender AS person_gender,
    e.name AS event_name, rt.name AS round_type_name, f.name AS format_name,
	r.person_id, r.person_link_id, r.person_country_id, r.person_continent_id,
	r.competition_id, r.competition_country_id, r.competition_continent_id, r.competition_date,
	r.event_id, r.round_type_id, r.round_type_code, r.round_type_final, r.format_id, r.format_code,
    r.pos, r.best, r.average,
	r.value1, r.value2, r.value3, r.value4, r.value5,
    r.regional_single_record, r.regional_average_record
FROM wca_alt.results AS r
JOIN wca_alt.persons AS p ON p.wca_id = r.person_id
JOIN wca_alt.events AS e ON e.id = r.event_id
JOIN wca_alt.round_types AS rt ON rt.id = r.round_type_id
JOIN wca_alt.formats AS f ON f.id = r.format_id;


/* --------------------
    competition_results
   -------------------- */

DROP VIEW IF EXISTS wca_alt.competition_results_view;

CREATE VIEW wca_alt.competition_results_view
AS
SELECT r.id,
    c.name AS competition_name, c.country_name AS competition_country_name, c.continent_name AS competition_continent_name,
    e.name AS event_name, rt.name AS round_type_name, f.name AS format_name,
	r.person_id, r.person_link_id, r.person_country_id, r.person_continent_id,
	r.competition_id, r.competition_country_id, r.competition_continent_id, r.competition_date,
	r.event_id, r.round_type_id, r.round_type_code, r.round_type_final, r.format_id, r.format_code,
    r.pos, r.best, r.average,
	r.value1, r.value2, r.value3, r.value4, r.value5,
    r.regional_single_record, r.regional_average_record
FROM wca_alt.results AS r
JOIN wca_alt.competitions AS c ON c.id = r.competition_id
JOIN wca_alt.events AS e ON e.id = r.event_id
JOIN wca_alt.round_types AS rt ON rt.id = r.round_type_id
JOIN wca_alt.formats AS f ON f.id = r.format_id;


/* --------------------
    Attempts
   -------------------- */

-- TODO
