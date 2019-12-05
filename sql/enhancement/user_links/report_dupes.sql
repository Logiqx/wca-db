/* 
      Script:   Report Dupes
      Created:  2019-07-31
      Author:   Michael George / 2015GEOR02
     
      Purpose:  Report duplicate WCA IDs identiofied through competition registrations + results
*/

SELECT l1.wca_id, l1.name, l1.gender, l1.country_id, l1.user_status, l1.user_id
FROM wca_dev.user_links AS l1
JOIN
(
	SELECT user_id, COUNT(DISTINCT wca_id) AS wca_count
	FROM wca_dev.user_links
	WHERE user_id IS NOT NULL
	GROUP by user_id
	HAVING wca_count > 1
) AS l2 ON l2.user_id = l1.user_id
ORDER BY l1.user_id, l1.wca_id;
