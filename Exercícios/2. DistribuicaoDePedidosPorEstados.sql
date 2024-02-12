SELECT 
	customer_state AS UF,
	count(order_id) AS cont_pedidos 
FROM 
	olist_orders_dataset ood 
LEFT JOIN olist_customers_dataset ocd 
	on ood.customer_id = ocd.customer_id 
GROUP BY UF 
ORDER BY cont_pedidos