/*
    Script:   Explore Countries
    Created:  2019-05-07
    Author:   Michael George / 2015GEOR02

    Purpose:  Basic exploration of the database to understand exceptions, etc.
*/

/*
 * Explore Countrys
 */

/*
  List of countries where id and name differ

  Cote d_Ivoire	Côte d'Ivoire	_Africa	CI
  Democratic People_s Republic of Korea	Democratic People’s Republic of Korea	_Asia	KP
  Korea	Republic of Korea	_Asia	KR
  USA	United States	_North America	US
  XA	Multiple Countries (Asia)	_Asia	XA
  XE	Multiple Countries (Europe)	_Europe	XE
  XF	Multiple Countries (Africa)	_Africa	XF
  XM	Multiple Countries (Americas)	_Multiple Continents	XM
  XN	Multiple Countries (North America)	_North America	XN
  XO	Multiple Countries (Oceania)	_Oceania	XO
  XS	Multiple Countries (South America)	_South America	XS
  XW	Multiple Countries (World)	_Multiple Continents	XW
*/
SELECT *
FROM  Countries
WHERE name != id;

/*
  How many people are affected?

  Cote d_Ivoire	2
  Korea	1664
  USA	23536
*/
SELECT country_id, COUNT(*)
FROM Persons
WHERE country_id IN
(
	SELECT id
	FROM  Countries
	WHERE name != id
)
GROUP BY country_id;

/*
  How many results are affected?

  Cote d_Ivoire	16
  Korea	20630
  USA	388528
*/
SELECT person_country_id, COUNT(*)
FROM Results
WHERE person_country_id IN
(
	SELECT id
	FROM  Countries
	WHERE name != id
)
GROUP BY person_country_id;
