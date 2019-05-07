SELECT * FROM wca.championships
where length(championship_type) > 2
order by competition_id;

SELECT championship_type, COUNT(*)
FROM wca.championships
group by championship_type
order by length(championship_type) desc, championship_type;

SELECT * FROM championships
WHERE competition_id IN (
SELECT competition_id
FROM championships
GROUP BY competition_id
HAVING COUNT(*) > 1)
ORDER by competition_id;

SELECT * FROM wca.eligible_country_iso2s_for_championship;
SELECT * FROM wca.Continents;
