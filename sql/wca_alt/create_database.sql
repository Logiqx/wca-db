/* 
    Script:   Create databases
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create the WCA databases
*/

-- Create the alternative WCA results database
CREATE DATABASE IF NOT EXISTS wca_alt DEFAULT CHARACTER SET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Grant full access to the WCA user
GRANT ALL ON wca_alt.* TO wca;
