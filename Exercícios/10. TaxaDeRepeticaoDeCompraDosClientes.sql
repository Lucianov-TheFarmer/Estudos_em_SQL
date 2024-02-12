-- De todos os produtos comprados pelo cliente, quantos foram comprados mais de uma vez?

WITH TBL_AUX AS (
	SELECT 
		ood.customer_id,
		ooid.product_id,
		COUNT(ooid.product_id) AS numero_de_compras	
	FROM 
		olist_order_items_dataset ooid 
	LEFT JOIN
		olist_orders_dataset ood 
	ON
		ood.order_id = ooid.order_id 
	GROUP BY 	
		ood.customer_id, ooid.product_id 
	ORDER BY 
		numero_de_compras DESC
), TBL_AUX_2 AS (
	SELECT 
		customer_id,
		SUM(numero_de_compras) AS total_produtos_comprados,
		SUM(CASE WHEN numero_de_compras == 1 THEN numero_de_compras ELSE 0 END) AS num_compras_1,
		SUM(CASE WHEN numero_de_compras > 1 THEN numero_de_compras ELSE 0 END) AS num_compras_mais_1
	FROM TBL_AUX
	GROUP BY customer_id
)
SELECT 
	customer_id,
	num_compras_mais_1,
	total_produtos_comprados,
	ROUND(num_compras_mais_1*1.0/total_produtos_comprados, 2) AS taxa_de_produtos_repetidos
FROM 
	TBL_AUX_2
--WHERE taxa_de_produtos_repetidos NOT IN (0, 1)
ORDER BY 
	taxa_de_produtos_repetidos DESC, total_produtos_comprados DESC



