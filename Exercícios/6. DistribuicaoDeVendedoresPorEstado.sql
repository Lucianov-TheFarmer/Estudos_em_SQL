SELECT 
	seller_state AS UF,
	COUNT(seller_state) AS Quantidade
FROM 
	sellers s  
GROUP BY 
	seller_state 
ORDER BY
	COUNT(seller_state) DESC