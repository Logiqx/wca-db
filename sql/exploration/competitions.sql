/*
    Script:   Explore competitions
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- Any funny years?
SELECT year, COUNT(*)
FROM Competitions
GROUP BY year
ORDER BY year;

-- Any funny months?
SELECT month, COUNT(*)
FROM Competitions
GROUP BY month
ORDER BY month;

-- Any funny days?
SELECT day, COUNT(*)
FROM Competitions
GROUP BY day
ORDER BY day;

-- Days of week where Sun = 1, Mon = 2 ... Fri = 6, Sat = 7
SELECT DAYOFWEEK(DATE_FORMAT(CONCAT(year, "-", month, "-", day), "%Y-%m-%d")) AS dow, COUNT(*)
FROM Competitions
GROUP BY dow
ORDER BY dow;

-- Only two competitions cross years - 2016-12-31 was a Saturday
SELECT *, DAYOFWEEK(DATE_FORMAT(CONCAT(year, "-", month, "-", day), "%Y-%m-%d")) AS dow
FROM Competitions
WHERE endMonth < month
ORDER BY dow;
