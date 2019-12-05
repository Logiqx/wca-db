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
SELECT DATE_FORMAT(updated_at, '%a') AS dow, DATE(updated_at), COUNT(*) AS numResults
FROM wca_dev.Results
WHERE YEAR(updated_at) >= 2018
AND DATE(updated_at) != '2018-10-04'
GROUP BY DATE(updated_at)
ORDER BY DATE(updated_at) DESC;

-- Comps posted by date
SELECT DATE_FORMAT(updated_at, '%a') AS dow, DATE(results_posted_at), COUNT(*) as numComps
FROM wca_dev.Competitions
WHERE results_posted_at IS NOT NULL
AND YEAR(results_posted_at) >= 2018
GROUP BY DATE(results_posted_at)
ORDER BY DATE(results_posted_at) DESC;

-- Results updated by DOW
SELECT 'Updated', DATE_FORMAT(updated_at, '%a') AS dow,  COUNT(*) AS numResults
FROM wca_dev.Results
WHERE YEAR(updated_at) >= 2018
AND DATE(updated_at) != '2018-10-04'
GROUP BY dow
ORDER BY DAYOFWEEK(updated_at);

-- Comps posted by DOW
SELECT 'Posted', DATE_FORMAT(results_posted_at, '%a') AS dow, COUNT(*) AS numComps
FROM wca_dev.Competitions
WHERE results_posted_at IS NOT NULL
AND YEAR(results_posted_at) >= 2018
GROUP BY dow
ORDER BY DAYOFWEEK(results_posted_at);

-- What formats have been used for each event?
SELECT eventId, formatId, COUNT(*) AS numResults
FROM Results
GROUP BY eventId, formatId
ORDER BY eventId, numResults DESC;

-- IMPORTANT: Number of unknown persons in results = 0
SELECT COUNT(*)
FROM Results r
WHERE NOT EXISTS
(
	SELECT 1
    FROM Persons p
    WHERE p.id = r.personId AND r.personName = p.name AND r.personCountryId = p.countryId
);

/*
    Stuff relating to subid
*/

-- Show usage of subid in persons
SELECT subid, COUNT(*)
FROM Results r
LEFT JOIN Persons p ON p.id = r.personId AND r.personName = p.name AND r.personCountryId = p.countryId
GROUP BY subid
ORDER BY subid;

-- Names in results where they are not the latest in the persons table
SELECT r.*
FROM wca.Results r
JOIN wca.Persons p ON p.id = r.personId AND p.subid = 1
WHERE r.personName != p.name;
