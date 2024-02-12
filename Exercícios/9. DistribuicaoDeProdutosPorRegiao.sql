WITH TBL_AUX AS (
	SELECT 
		ocd.customer_state,
		ooid.product_id,
		COUNT(*) AS total_vendas
	FROM
		olist_order_items_dataset ooid 
	LEFT JOIN
		olist_orders_dataset ood 
	ON
		ood.order_id = ooid.order_id
	LEFT JOIN 
		olist_customers_dataset ocd 
	ON
		ocd.customer_id = ood.customer_id
	WHERE 	
		ood.order_status = 'delivered'
	GROUP BY 	
		ocd.customer_state, ooid.product_id
	ORDER BY 
		total_vendas DESC
), TBL_AUX_2 AS (
	SELECT 
		*,
		ROW_NUMBER ()
			OVER (PARTITION BY customer_state ORDER BY total_vendas DESC) AS RK
	FROM 	
		TBL_AUX
)
SELECT 
	*
FROM 
	TBL_AUX_2
WHERE 	
	RK <= 5
	
