/* 
    Script:   Explore Tables
    Created:  2019-05-09
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check query execution plans
*/

/*
    RanksSingleView

	Note: The use of p.wcaId (not r. wcaId) in RanksSingleView is crucial for the the first two queries
*/

-- Expected keys: Events_name, Persons_wcaId_subid, RanksSingle_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksSingleView
WHERE wcaId IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_wcaId_subid, RanksSingle_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksSingleView
WHERE wcaId = '2015GEOR02'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_countryName, RanksSingle_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksSingleView
WHERE countryName = 'United Kingdom'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_continentName, RanksSingle_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksSingleView
WHERE continentName = 'Europe'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, RanksSingle_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksSingleView
WHERE eventName = '3x3x3 Cube';


/*
    RanksAverageView

	Note: The use of p.wcaId (not r. wcaId) in RanksAverageView is crucial for the the first two queries
*/

-- Expected keys: Events_name, Persons_wcaId_subid, RanksAverage_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksAverageView
WHERE wcaId IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_wcaId_subid, RanksAverage_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksAverageView
WHERE wcaId = '2015GEOR02'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_countryName, RanksAverage_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksAverageView
WHERE countryName = 'United Kingdom'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_continentName, RanksAverage_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksAverageView
WHERE continentName = 'Europe'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, RanksAverage_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.RanksAverageView
WHERE eventName = '3x3x3 Cube';


/*
    ResultsView

	Note: The use of p.wcaId (not r. wcaId) in ResultsView is crucial for the the first two queries
*/

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.ResultsView
WHERE eventName = '3x3x3 Cube';

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.ResultsView
WHERE formatName = 'Mean of 3';

-- Expected keys: TODO
EXPLAIN SELECT *
FROM wca_alt.ResultsView
WHERE roundTypeName = 'Final';

/*
    PersonResultsView

	Note: The use of p.wcaId (not r. wcaId) in ResultsView is crucial for the the first two queries
*/

-- Expected keys: Events_name, Persons_wcaId_subid, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.PersonResultsView
WHERE wcaId IN ('2007JOON01', '2012NADA01', '2014HABO01')
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_wcaId_subid, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.PersonResultsView
WHERE wcaId = '2015GEOR02'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_countryName, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.PersonResultsView
WHERE personCountryName = 'United Kingdom'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Persons_continentName, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.PersonResultsView
WHERE personContinentName = 'Europe'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.PersonResultsView
WHERE eventName = '3x3x3 Cube';

/*
    CompetitionResultsView
*/

-- Expected keys: Events_name, Competitions_countryName, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.CompetitionResultsView
WHERE competitionCountryName = 'United Kingdom'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Competitions_continentName, Results_personId_eventId
EXPLAIN SELECT *
FROM wca_alt.CompetitionResultsView
WHERE competitionContinentName = 'Europe'
AND eventName = '3x3x3 Cube';

-- Expected keys: Events_name, Results_competitionId_eventId
EXPLAIN SELECT *
FROM wca_alt.CompetitionResultsView
WHERE eventName = '3x3x3 Cube';
