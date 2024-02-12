SELECT 
	opd.product_category_name AS Categoria,
	COUNT(ooid.product_id) AS Quantidade,
	AVG(oord.review_score) AS NotaMedia
FROM
	olist_order_items_dataset ooid 
JOIN
	olist_products_dataset opd 
ON
	ooid.product_id = opd.product_id 
JOIN
	olist_order_reviews_dataset oord 
ON
	oord.order_id = ooid.order_id 
WHERE 
	order_item_id = 1 AND Categoria <> ''
GROUP BY 
	Categoria
ORDER BY 
	NotaMedia DESC
	