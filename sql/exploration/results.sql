/*
    Script:   Explore Results
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

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
