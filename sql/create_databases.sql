/* 
      Script:   Create databases
      Created:  2019-12-05
      Author:   Michael George / 2015GEOR02
     
      Purpose:  Create wca_ipy and wca_ipy_tst databases
*/

-- wca_ipy is for production activities

CREATE DATABASE IF NOT EXISTS wca;

CREATE USER IF NOT EXISTS 'wca' IDENTIFIED BY 'change.me';
GRANT ALL ON wca.* TO wca;

-- wca_ipy_tst is for testing and CI/CD

CREATE DATABASE IF NOT EXISTS wca_tst;

CREATE USER IF NOT EXISTS 'wca_tst' IDENTIFIED BY 'change.me';
GRANT ALL ON wca_tst.* TO wca_tst;
