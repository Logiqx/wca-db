/*
    Script:   Explore Results
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

/*
    When are results posted?
    
    Answer: Sun + Mon are the most common. Tue + Wed account for half as many results. Thu - Sat account for half as many again
            Based on this the Over-40's rankings will be refereshed on Mon + Tue
*/

-- Results updated by date
SELECT DATE_FORMAT(updated_at, '%a') AS dow, DATE(updated_at), COUNT(*) AS num_results
FROM wca_dev.results
WHERE YEAR(updated_at) >= 2018
AND DATE(updated_at) != '2018-10-04'
GROUP BY DATE(updated_at)
ORDER BY DATE(updated_at) DESC;

-- Comps posted by date
SELECT DATE_FORMAT(updated_at, '%a') AS dow, DATE(results_posted_at), COUNT(*) as num_comps
FROM wca_dev.competitions
WHERE results_posted_at IS NOT NULL
AND YEAR(results_posted_at) >= 2018
GROUP BY DATE(results_posted_at)
ORDER BY DATE(results_posted_at) DESC;

-- Results updated by DOW
SELECT 'Updated', DATE_FORMAT(updated_at, '%a') AS dow,  COUNT(*) AS num_results
FROM wca_dev.results
WHERE YEAR(updated_at) >= 2018
AND DATE(updated_at) != '2018-10-04'
GROUP BY dow
ORDER BY DAYOFWEEK(updated_at);

-- Comps posted by DOW
SELECT 'Posted', DATE_FORMAT(results_posted_at, '%a') AS dow, COUNT(*) AS num_comps
FROM wca_dev.competitions
WHERE results_posted_at IS NOT NULL
AND YEAR(results_posted_at) >= 2018
GROUP BY dow
ORDER BY DAYOFWEEK(results_posted_at);

-- What formats have been used for each event?
SELECT event_id, format_id, COUNT(*) AS num_results
FROM wca.results
GROUP BY event_id, format_id
ORDER BY event_id, num_results DESC;

-- IMPORTANT: Number of unknown persons in results = 0
SELECT COUNT(*)
FROM wca.results r
WHERE NOT EXISTS
(
	SELECT 1
    FROM wca.persons p
    WHERE p.wca_id = r.person_id AND r.person_name = p.name AND r.person_country_id = p.country_id
);

/*
    Stuff relating to subid
*/

-- Show usage of subid in persons
SELECT sub_id, COUNT(*)
FROM wca.results r
LEFT JOIN wca.persons p ON p.wca_id = r.person_id AND r.person_name = p.name AND r.person_country_id = p.country_id
GROUP BY sub_id
ORDER BY sub_id;

-- Names in results where they are not the latest in the persons table
SELECT r.*
FROM wca.results r
JOIN wca.persons p ON p.wca_id = r.person_id AND p.sub_id = 1
WHERE r.person_name != p.name;
