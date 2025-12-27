/*
    Script:   Explore scrambles
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- How long is group_id?
SELECT group_id, COUNT(*)
FROM Scrambles
GROUP BY group_id
ORDER BY LENGTH(group_id) DESC;