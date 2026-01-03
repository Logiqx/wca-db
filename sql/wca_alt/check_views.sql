/* 
    Script:   Check Views
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check explain plans for views
*/

-- Scrambles
EXPLAIN SELECT * FROM wca_alt.scrambles_view ORDER BY id;

-- Rankings
EXPLAIN SELECT * FROM wca_alt.ranks_single_view ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.ranks_average_view ORDER BY id;

-- results
EXPLAIN SELECT * FROM wca_alt.results_view ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.person_results_view ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.competition_results_view ORDER BY id;
