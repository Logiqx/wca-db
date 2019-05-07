/* 
    Script:   Create databases
    Created:  2019-05-05
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Create the WCA databases
*/

-- Create the standard WCA results database
CREATE DATABASE IF NOT EXISTS wca DEFAULT CHARACTER SET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Grant full access to the WCA user
GRANT ALL ON wca.* TO wca;
