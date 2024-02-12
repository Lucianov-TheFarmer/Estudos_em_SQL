-- Os adiantamentos promovem maiores notas (4,29) do que os atrasos (2,55), em média.

WITH AUX AS(
SELECT
	JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ENTREGA,
	JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS DIAS_ESTIMADO,
	review_score
FROM
	olist_orders_dataset ood
LEFT JOIN
	olist_order_reviews_dataset oord 
ON
	oord.order_id = ood.order_id
WHERE 	
	order_delivered_customer_date <> ''
	AND order_estimated_delivery_date <> ''
	AND order_purchase_timestamp <> ''
	AND review_score <> ''
)
SELECT 
	AVG(CASE WHEN DIAS_ESTIMADO >= DIAS_ENTREGA THEN review_score END) AS AVG_DIAS_SUPERESTIMADO,
	AVG(CASE WHEN DIAS_ESTIMADO < DIAS_ENTREGA THEN review_score END) AS AVG_DIAS_SUBESTIMADO
FROM
	AUX

/* --Considerando todos os pedidos sub e superestimados, não existe uma correlação direta entre a avaliação e a diferença de tempo previsto e entrega. O mesmo também ocorre para pedidos em que o prazo foi superestimado.
SELECT 
	review_score,
	AVG(ABS(DIAS_ESTIMADO - DIAS_ENTREGA))
FROM
	AUX
GROUP BY
	review_score
*/
/* --Entretanto, considerando-se somente os pedidos em que a data prevista foi subestimada, existe correlação entre a avaliação e a diferença da previsão e entrega. Em outras palavras, um atraso de 12,7 dias diminui mais a avaliação do que um atraso de 5,1 dias. Contudo, um adiantamento de 12 a 13 dias não impacta tanto a avaliação. Isso pode ocorrer devido à própria qualidade do produto ou também devido a outros fatores, como o volume de compra e o desvio padrão.
SELECT 
	review_score,
	AVG(ABS(DIAS_ESTIMADO - DIAS_ENTREGA))
FROM
	AUX
WHERE 
	DIAS_ESTIMADO > DIAS_ENTREGA
GROUP BY
	review_score
*/