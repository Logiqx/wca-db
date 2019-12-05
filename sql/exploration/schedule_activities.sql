/*
    Script:   Explore schedule activities
    Created:  2019-05-08
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- Number of days for each round
-- 1	19767
-- 2	295
SELECT DATEDIFF(end_time, start_time) + 1 AS days, COUNT(*)
FROM wca_dev.schedule_activities
GROUP BY days
ORDER BY days;
