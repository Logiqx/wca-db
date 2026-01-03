/* 
    Script:   Explore Tables
    Created:  2019-05-09
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check query execution plans
*/

/*
    ranks_single_view

	Note: The use of p.wca_id (not r. wca_id) in ranks_single_view is crucial for the the first two queries
*/

-- Expected keys: events_name, persons_wca_id_sub_id, ranks_single_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_single_view
WHERE wca_id IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_wca_id_sub_id, ranks_single_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_single_view
WHERE wca_id = '2015GEOR02'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_country_name, ranks_single_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_single_view
WHERE country_name = 'United Kingdom'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_continent_name, ranks_single_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_single_view
WHERE continent_name = 'Europe'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, ranks_single_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_single_view
WHERE event_name = '3x3x3 Cube';


/*
    ranks_average_view

	Note: The use of p.wca_id (not r. wca_id) in ranks_average_view is crucial for the the first two queries
*/

-- Expected keys: events_name, persons_wca_id_sub_id, ranks_average_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_average_view
WHERE wca_id IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_wca_id_sub_id, ranks_average_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_average_view
WHERE wca_id = '2015GEOR02'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_country_name, ranks_average_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_average_view
WHERE country_name = 'United Kingdom'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_continent_name, ranks_average_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_average_view
WHERE continent_name = 'Europe'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, ranks_average_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.ranks_average_view
WHERE event_name = '3x3x3 Cube';


/*
    results_view

	Note: The use of p.wca_id (not r. wca_id) in results_view is crucial for the the first two queries
*/

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.results_view
WHERE event_name = '3x3x3 Cube';

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.results_view
WHERE format_name = 'Mean of 3';

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.results_view
WHERE round_type_name = 'Final';

/*
    person_results_view

	Note: The use of p.wca_id (not r. wca_id) in results_view is crucial for the the first two queries
*/

-- Expected keys: events_name, persons_wca_id_sub_id, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.person_results_view
WHERE wca_id IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_wca_id_sub_id, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.person_results_view
WHERE wca_id = '2015GEOR02'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_country_name, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.person_results_view
WHERE person_country_name = 'United Kingdom'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, persons_continent_name, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.person_results_view
WHERE person_continent_name = 'Europe'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.person_results_view
WHERE event_name = '3x3x3 Cube';

/*
    competition_results_view
*/

-- Expected keys: events_name, competitions_country_name, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.competition_results_view
WHERE competition_country_name = 'United Kingdom'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, competitions_continent_name, results_person_id_event_id
EXPLAIN SELECT *
FROM wca_alt.competition_results_view
WHERE competition_continent_name = 'Europe'
AND event_name = '3x3x3 Cube';

-- Expected keys: events_name, results_competition_id_event_id
EXPLAIN SELECT *
FROM wca_alt.competition_results_view
WHERE event_name = '3x3x3 Cube';
