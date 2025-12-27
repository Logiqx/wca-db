/*
    Script:   Explore Concise Results
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

-- Show that concise results are the persons best result for each year
SELECT *
FROM wca_dev.concise_single_results
WHERE person_id = '2015GEOR02'
ORDER BY event_id, year;

-- Show that the country and continent are for that particular result
SELECT *
FROM wca_dev.concise_single_results
WHERE person_id = '1982FRID01'
ORDER BY event_id, year;

-- Check that DNF singles are not included
SELECT *
FROM wca_dev.concise_single_results
WHERE best <= 0;

-- Check that DNF averages are not included
SELECT *
FROM wca_dev.concise_average_results
WHERE average <= 0;