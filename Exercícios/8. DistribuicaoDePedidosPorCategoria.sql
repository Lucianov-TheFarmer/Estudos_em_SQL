WITH TBL_CATEGORIA AS (
	SELECT 
		opd.product_category_name AS categoria_produto,
		count(ooid.product_id) AS total_produtos_vendidos
	FROM
		olist_order_items_dataset ooid 
	LEFT JOIN 
		olist_products_dataset opd 
	ON 
		ooid.product_id = opd.product_id
	GROUP BY
		opd.product_category_name
	ORDER BY
		total_produtos_vendidos DESC	
)
SELECT 
	CASE WHEN 
		categoria_produto == ''
	THEN
		'desconhecido'
	ELSE
		categoria_produto
	END AS categoria_produto, total_produtos_vendidos
FROM TBL_CATEGORIA	
