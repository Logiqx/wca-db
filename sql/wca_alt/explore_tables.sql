FLUSH TABLES;
DESCRIBE SELECT COUNt(*)
FROM wca_alt.ResultsView
-- WHERE wcaId = '2015GEOR02'
-- WHERE wcaId IN ('2007JOON01', '2012NADA01', '2014HABO01')
WHERE personContinentName = 'Europe'
AND eventName = '3x3x3 Cube';
