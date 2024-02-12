--Diferença média entre a data estimada e a data efetiva de entrega
 
SELECT 
	AVG(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp)) AS DIAS_ENTREGA,
	AVG(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp)) AS DIAS_ESTIMADO
FROM
	olist_orders_dataset ood 
WHERE
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''


/* Verificar a porcentagem de casos em que a data de entrega foi superestimada

WITH AUX AS (
SELECT 
	JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ENTREGA,
	JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ESTIMADO
FROM
	olist_orders_dataset ood 
WHERE
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''
)
SELECT 
	ROUND(AVG(DIAS_ESTIMADO > DIAS_ENTREGA) * 100, 2) AS '% PEDIDOS SUPERESTIMADOS' 
FROM
	AUX
*/

/* Verificar a diferença média, máxima e mínima de dias entre a data estimada e a data de entrega nos casos em que a data prevista foi superestimada
  
WITH AUX AS (
SELECT 
	JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ENTREGA,
	JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ESTIMADO
FROM
	olist_orders_dataset ood
WHERE
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''
)
SELECT 
	AVG(DIAS_ESTIMADO - DIAS_ENTREGA),
	MAX(DIAS_ESTIMADO - DIAS_ENTREGA),
	MIN(DIAS_ESTIMADO - DIAS_ENTREGA)
FROM
	AUX
WHERE 	
	DIAS_ESTIMADO > DIAS_ENTREGA
*/

/* Verificar a diferença média, máxima e mínima de dias entre a data estimada e a data de entrega nos casos em que a data prevista foi subestimada
  
WITH AUX AS (
SELECT 
	JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ENTREGA,
	JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ESTIMADO
FROM
	olist_orders_dataset ood
WHERE
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''
)
SELECT 
	AVG(DIAS_ESTIMADO - DIAS_ENTREGA),
	MAX(DIAS_ESTIMADO - DIAS_ENTREGA),
	MIN(DIAS_ESTIMADO - DIAS_ENTREGA)
FROM
	AUX
WHERE 	
	DIAS_ESTIMADO < DIAS_ENTREGA
*/

/* Listar as diferenças entre as datas estimadas e as datas de entrega nos casos em que a data prevista foi subestimada

WITH AUX AS (
SELECT 
	JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ENTREGA,
	JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ESTIMADO
FROM
	olist_orders_dataset ood 
WHERE
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''
)
SELECT 
	(DIAS_ESTIMADO - DIAS_ENTREGA)
FROM
	AUX
WHERE
	DIAS_ESTIMADO < DIAS_ENTREGA