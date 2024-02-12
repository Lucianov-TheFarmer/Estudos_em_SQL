WITH AUX_VENDEDORES AS (
SELECT 
	ooid.seller_id,
	COUNT(*) AS ctn_pedidos,
	AVG(JULIANDAY(ood.order_delivered_carrier_date) - JULIANDAY(ood.order_purchase_timestamp)) AS AVG_DIAS_POSTAGEM
FROM
	olist_orders_dataset ood
LEFT JOIN (
	SELECT
		order_id,
		MAX(seller_id) AS seller_id
	FROM
		olist_order_items_dataset
	GROUP BY
		order_id ) ooid 
ON
	ood.order_id = ooid.order_id
WHERE 
	order_delivered_carrier_date <> ''
	AND order_purchase_timestamp <> ''
	AND ooid.seller_id IS NOT NULL
	AND ood.order_delivered_carrier_date >= ood.order_purchase_timestamp
GROUP BY
	ooid.seller_id),
AUX AS (
SELECT
	s.seller_state,
	av.seller_id,
	av.AVG_DIAS_POSTAGEM,
	av.ctn_pedidos,
	RANK() OVER (PARTITION BY seller_state
ORDER BY
	AVG_DIAS_POSTAGEM ASC) AS RK
FROM
	AUX_VENDEDORES AS av
LEFT JOIN sellers s ON
	s.seller_id = av.seller_id
WHERE
	ctn_pedidos > 10
)
SELECT
	*
FROM
	AUX
WHERE
	seller_state LIKE '%MG%'