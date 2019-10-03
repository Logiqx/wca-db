/*
    Script:   Explore competitions
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

/*
   Results database
*/

-- Any funny years?
SELECT year, COUNT(*) AS numComps
FROM Competitions
GROUP BY year
ORDER BY year;

-- Any funny months?
SELECT month, COUNT(*) AS numComps
FROM Competitions
GROUP BY month
ORDER BY month;

-- Any funny days?
SELECT day, COUNT(*) AS numComps
FROM Competitions
GROUP BY day
ORDER BY day;

-- Days of week where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
SELECT DAYOFWEEK(DATE_FORMAT(CONCAT(year, "-", month, "-", day), "%Y-%m-%d")) AS startDow, COUNT(*) AS numComps
FROM Competitions
GROUP BY startDow
ORDER BY startDow;

-- Only two competitions cross years - 2016-12-31 was a Saturday
SELECT *, DAYOFWEEK(DATE_FORMAT(CONCAT(year, "-", month, "-", day), "%Y-%m-%d")) AS startDow
FROM Competitions
WHERE endMonth < month
ORDER BY startDow;

/*
   Dev database
*/

-- Competition Length
-- 1	3502
-- 2	2387
-- 3	313
-- 4	6
-- 5	2
SELECT TIMESTAMPDIFF(DAY, start_date, end_date) + 1 AS numDays, COUNT(*) AS numComps, ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM wca_dev.Competitions), 2) AS pctComps
FROM wca_dev.Competitions
GROUP BY numDays
ORDER BY numDays;

-- Show the longest comps (5 days) - Gdańsk, Poland  (Mon to Fri)
SELECT *
FROM wca_dev.Competitions
WHERE TIMESTAMPDIFF(DAY, start_date, end_date) + 1 = 5;

-- Start day where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
SELECT DAYNAME(start_date) AS startDow, COUNT(*) AS numComps,
	ROUND(AVG(TIMESTAMPDIFF(DAY, start_date, end_date) + 1), 1) AS avgDays,
	MAX(TIMESTAMPDIFF(DAY, start_date, end_date) + 1) AS maxDays,
	ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM wca_dev.Competitions), 2) AS pctComps
FROM wca_dev.Competitions
GROUP BY startDow
ORDER BY (DAYOFWEEK(start_date) + 5) % 7;

-- End day where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
SELECT DAYNAME(end_date) AS endDow, COUNT(*) AS numComps,
	ROUND(AVG(TIMESTAMPDIFF(DAY, start_date, end_date) + 1), 1) AS avgDays,
	MAX(TIMESTAMPDIFF(DAY, start_date, end_date) + 1) AS maxDays,
	ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM wca_dev.Competitions), 2) AS pctComps
FROM wca_dev.Competitions
GROUP BY endDow
ORDER BY (DAYOFWEEK(end_date) + 5) % 7;

-- Start + end day where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
SELECT DAYNAME(start_date) AS startDow,
	DAYNAME(end_date) AS endDow,
	TIMESTAMPDIFF(DAY, start_date, end_date) + 1 AS numDays,
	COUNT(*) AS numComps, ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM wca_dev.Competitions), 2) AS pctComps
FROM wca_dev.Competitions
GROUP BY startDow, endDow
ORDER BY (DAYOFWEEK(end_date) + 5) % 7, (DAYOFWEEK(start_date) + 5) % 7;

-- Start + end day where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
-- Mon to Fri (5d)
-- Tue to Thu (3d)
-- Wed to Fri (3d)
-- Thu to Sun (4d)
-- Fri to Sun (3d)
-- Sat to Mon (3d) * rolls into new week
-- Sun to Mon (2d) * rolls into new week
-- CONCLUSION: Treat MONDAY as end of the week (re: end_date). Could use Monday as start of week as there are only a few "monday only" comps each year.
SELECT DAYNAME(start_date) AS startDow,
	DAYNAME(start_date + MAX(TIMESTAMPDIFF(DAY, start_date, end_date))) AS lastDow,
	MAX(TIMESTAMPDIFF(DAY, start_date, end_date) + 1) AS maxDays,
	COUNT(*) AS numComps, ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM wca_dev.Competitions), 2) AS pctComps
FROM wca_dev.Competitions
GROUP BY startDow
ORDER BY (DAYOFWEEK(start_date) + 5) % 7;

-- Monday comps
SELECT *
FROM wca_dev.Competitions
WHERE DAYOFWEEK(start_date) = 2 AND DAYOFWEEK(end_date) = 2
ORDER BY start_date;
