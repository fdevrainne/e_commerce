
SELECT *  FROM  e_commerce.customers_stats ORDER BY e_commerce.customers_stats.number_order DESC LIMIT 10;

SELECT 
COUNT(*) AS number_repeater,
(SELECT COUNT(DISTINCT customers_stats.customer_id) FROM e_commerce.customers_stats) AS number_client
FROM
(
SELECT customers_stats.customer_id, SUM(number_order) AS number_order
FROM  e_commerce.customers_stats
GROUP BY customers_stats.customer_id
) whole_historic
WHERE whole_historic.number_order>1
;
