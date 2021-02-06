
INSERT INTO e_commerce.customers_stats (customer_id, day, amount_spent, number_order)


 SELECT
 orders.customer_id,
 CURRENT_DATE AS day,
 SUM(items.price) AS amount_spent,
 COUNT(orders.order_status) AS number_order

 FROM e_commerce.orders

 LEFT JOIN e_commerce.items ON e_commerce.orders.id = e_commerce.items.order_id
 WHERE CAST(order_purchase_timestamp AS DATE) = CURRENT_DATE
 GROUP BY orders.customer_id


ON CONFLICT (customer_id, day) DO 
UPDATE 
SET number_order = EXCLUDED.number_order,
    amount_spent = EXCLUDED.amount_spent
;
