/* 
    Script:   Check Views
    Created:  2019-05-11
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Check explain plans for views
*/

-- Scrambles
EXPLAIN SELECT * FROM wca_alt.ScramblesView ORDER BY id;

-- Rankings
EXPLAIN SELECT * FROM wca_alt.RanksSingleView ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.RanksAverageView ORDER BY id;

-- Results
EXPLAIN SELECT * FROM wca_alt.ResultsView ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.PersonResultsView ORDER BY id;
EXPLAIN SELECT * FROM wca_alt.CompetitionResultsView ORDER BY id;
