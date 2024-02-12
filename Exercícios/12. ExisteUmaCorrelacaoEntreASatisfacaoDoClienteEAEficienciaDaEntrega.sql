WITH AUX AS (
SELECT 	
	oord.review_score AS nivel_de_satisfacao,
	JULIANDAY(ood.order_delivered_customer_date) - JULIANDAY(ood.order_purchase_timestamp) AS qtd_dias_em_transporte
FROM
	olist_order_reviews_dataset oord
LEFT JOIN
	olist_orders_dataset ood 
ON
	ood.order_id = oord.order_id
WHERE 	
	review_score <> ''
	AND ood.order_delivered_customer_date <> ''
	AND ood.order_purchase_timestamp <> ''	
)
SELECT 
	nivel_de_satisfacao,
	ROUND(AVG(qtd_dias_em_transporte), 2) AS avg_qtd_dias_em_transporte
FROM 
	AUX
GROUP BY
	nivel_de_satisfacao
ORDER BY 
	avg_qtd_dias_em_transporte DESC