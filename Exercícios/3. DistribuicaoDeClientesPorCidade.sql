SELECT 
	customer_city AS Cidade,
	COUNT(customer_city) AS Contagem
FROM 
	olist_customers_dataset ocd 
GROUP BY Cidade
ORDER BY Contagem DESC