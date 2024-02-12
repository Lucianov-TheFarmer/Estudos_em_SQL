WITH AUX AS (
SELECT 
    ooid.order_id AS id_pedido, 
    opd.product_category_name, 
    SUM(ooid.price) + SUM(ooid.freight_value) AS valor_pedido 
FROM olist_order_items_dataset ooid 
LEFT JOIN olist_products_dataset opd ON opd.product_id = ooid.product_id 
WHERE 
    ooid.order_id IN (
        SELECT 
            ooid.order_id 
        FROM 
            olist_order_items_dataset ooid 
        LEFT JOIN olist_products_dataset opd 
            ON opd.product_id = ooid.product_id 
        GROUP BY ooid.order_id
        HAVING COUNT(DISTINCT opd.product_category_name) = 1 
    )
GROUP BY order_id, opd.product_category_name
)
SELECT
    product_category_name AS categoria_produto,
    AVG(valor_pedido) AS preco_medio
FROM AUX
WHERE categoria_produto <> ''
GROUP BY product_category_name
ORDER BY preco_medio DESC
