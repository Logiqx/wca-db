/*
    Script:   Explore scrambles
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- How long is groupId?
SELECT groupId, COUNT(*)
FROM Scrambles
GROUP BY groupId
ORDER BY LENGTH(groupId) DESC;