-- Apenas as 'delivered' (entregues) e ano NOT NULL
-- Por mês e ano
-- Data de aprovação

SELECT 
	STRFTIME('%Y', order_approved_at) AS ano,
	STRFTIME('%m', order_approved_at) AS mes,
	count(*) AS total_vendas
FROM
	olist_orders_dataset ood
WHERE
	ood.order_status = 'delivered' AND ano IS NOT NULL
GROUP BY
	ano,
	mes
ORDER BY
	ano,
	mes