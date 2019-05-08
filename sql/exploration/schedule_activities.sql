-- Number of days for each round
-- 1	19767
-- 2	295
SELECT datediff(end_time, start_time) + 1 as days, COUNT(*)
FROM wca_dev.schedule_activities
GROUP BY days
ORDER BY days;