/*
    Script:   Explore Persons
    Created:  2019-05-08
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- IMPORTANT: List duplicate entries in the persons table - none
SELECT p1.*, p2.*
FROM wca.persons p1
JOIN wca.persons p2 ON p2.wca_id = p1.wca_id AND p2.sub_id != p1.sub_id AND p2.name = p1.name AND p2.country_id = p1.country_id;

-- List records in the persons table which include multiple changes
WITH multi_persons AS
(
	SELECT wca_id
	FROM wca.persons
	GROUP BY wca_id
	HAVING COUNT(*) > 1
)
SELECT p.wca_id, MAX(sub_id) AS max_sub_id,
	COUNT(DISTINCT name) - 1 AS num_name_changes,
    COUNT(DISTINCT country_id) - 1 AS num_country_changes,
    COUNT(DISTINCT gender) - 1 AS num_gender_changes,
    COUNT(DISTINCT name) + COUNT(DISTINCT country_id) + COUNT(DISTINCT gender) - 3 AS num_changes
FROM wca.persons p
JOIN multi_persons m ON m.wca_id = p.wca_id
GROUP BY p.wca_id
HAVING num_changes > 1
ORDER BY p.wca_id;
