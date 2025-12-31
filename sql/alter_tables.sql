/* 
    Script:   Alter Tables
    Created:  2019-02-19
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Add columns to the "persons" and "competitions" tables
*/

-- Add date of birth (DOB) column to the "persons" table
ALTER TABLE persons
ADD COLUMN
(
    `dob` date
);

-- Add date columns to the "competitions" table
ALTER TABLE competitions
ADD COLUMN
(
    `start_date` date,
    `end_date` date
);

-- Populate dates in the "competitions" table
UPDATE competitions
SET start_date = STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'),
    end_date = STR_TO_DATE(CONCAT(end_year, '-', end_month, '-', end_day), '%Y-%m-%d');
