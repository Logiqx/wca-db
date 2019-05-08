-- IMPORTANT: List duplicate entries in the Persons table - none

SELECT p1.*, p2.*
FROM Persons p1
JOIN Persons p2 ON p2.id = p1.id AND p2.subid != p1.subid AND p2.name = p1.name AND p2.countryId = p1.countryId;

-- List entries in the Persons table which have had multiple changes

WITH MultiPersons AS
(
	SELECT id
	FROM wca.Persons
	GROUP BY id
	HAVING COUNT(*) > 1
)
SELECT p.id, MAX(subid) AS maxSubid,
	COUNT(DISTINCT name) - 1 AS numNameChanges,
    COUNT(DISTINCT countryId) - 1 AS numCountryChanges,
    COUNT(DISTINCT gender) - 1 AS numGenderChanges,
    COUNT(DISTINCT name) + COUNT(DISTINCT countryId) + COUNT(DISTINCT gender) - 3 AS numChanges
FROM Persons p
JOIN MultiPersons m ON m.id = p.id
GROUP BY p.id
HAVING numChanges > 1
ORDER BY p.id;
