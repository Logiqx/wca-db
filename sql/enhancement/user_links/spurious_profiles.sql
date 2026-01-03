/* 
      Script:   Spurious Profiles
      Created:  2019-09-22
      Author:   Michael George / 2015GEOR02
     
      Purpose:  Identify spurious WCA profiles
*/

-- Create temporary table containing the registrations that are ambiguous (i.e. same name for two people in same comp) ~30s

DROP TEMPORARY TABLE IF EXISTS registration_duplicates;

CREATE TEMPORARY TABLE registration_duplicates AS
SELECT competition_id, LEFT(name, 80) AS name, COUNT(DISTINCT user_id) AS num_persons
FROM registrations AS r
JOIN users AS u ON u.id = r.user_id
WHERE deleted_at IS NULL
GROUP BY competition_id, LEFT(name, 80)
HAVING num_persons > 1;

ALTER TABLE registration_duplicates ADD PRIMARY KEY (competition_id, name);

-- Create temporary table containing the registrations that are unambiguous ~2s

DROP TEMPORARY TABLE IF EXISTS registration_users;

CREATE TEMPORARY TABLE registration_users AS
SELECT r.competition_id, r.user_id, LEFT(u.name, 80) AS name, u.wca_id
FROM registrations AS r
JOIN users AS u ON u.id = r.user_id
WHERE deleted_at IS NULL
AND NOT EXISTS
(
  SELECT 1
  FROM registration_duplicates AS d
  WHERE d.competition_id = r.competition_id
  AND d.name = LEFT(u.name, 80)
);

ALTER TABLE registration_users ADD PRIMARY KEY (competition_id, name);

-- Join results back to registrations - takes about 7 seconds (warm)
SELECT user_id, name, GROUP_CONCAT(DISTINCT country_id) AS country_ids, GROUP_CONCAT(DISTINCT person_id) AS result_ids
FROM
(
  SELECT person_name, competition_id, country_id, person_id
  FROM
  (
    SELECT DISTINCT id
    FROM persons
    WHERE name IN
    (
      SELECT name
      FROM persons
      GROUP BY name
      HAVING COUNT(DISTINCT id) > 1
    )
  ) AS d
  JOIN results AS r ON r.person_id = d.id
  GROUP BY person_name, competition_id
  HAVING COUNT(DISTINCT person_id) = 1
) AS r
JOIN registration_users u ON u.competition_id = r.competition_id AND u.name = r.person_name
GROUP BY user_id
HAVING COUNT(DISTINCT person_id) > 1
ORDER BY country_ids, name;
