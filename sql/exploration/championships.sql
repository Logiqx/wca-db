/*
    Script:   Explore championships
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- List championship types
SELECT championship_type, COUNT(*)
FROM championships
GROUP BY championship_type
ORDER BY LENGTH(championship_type) desc, championship_type;

-- List championships not related to an ISO code
SELECT *
FROM championships
WHERE LENGTH(championship_type) > 2
ORDER BY competition_id;

-- List competitions which were used for multiple championships
SELECT *
FROM championships
WHERE competition_id IN
(
	SELECT competition_id
	FROM championships
	GROUP BY competition_id
	HAVING COUNT(*) > 1
)
ORDER BY competition_id;

-- List championship types which span multiple ISO codes
SELECT *
FROM eligible_country_iso2s_for_championship;
