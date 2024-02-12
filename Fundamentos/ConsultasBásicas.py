# Importando as bibliotecas
import pandas as pd
import pandasql as psql

# Criando os dataframes
data_clientes = {
    'id_cliente': [1, 2, 3, 4, 5, 6],
    'nome': ['João', 'Maria', 'Pedro', 'Ana', 'Carlos', 'Guilherme'],
    'idade': [28, 34, 22, 45, 31, 29],
    'cidade': ['São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Porto Alegre', 'Brasília', 'Vitória']
}
clientes = pd.DataFrame(data_clientes)

# DataFrame de Pedidos
data_pedidos = {
    'id_pedido': [101, 102, 103, 104, 105, 106, 107, 108, 109, 110],
    'id_cliente': [1, 2, 4, 5, 3, 1, 5, 1, 4, 1],
    'data_pedido': ['2023-01-10', '2023-02-15', '2023-03-20', '2023-04-25', '2023-05-30', '2023-06-01', '2023-06-07', '2023-07-01', '2023-07-05', '2023-09-20'],
    'valor': [150.00, 200.50, 99.90, 300.40, 180.75, 180.5, 190.9, 209.78, 136.90, 136.9]
}
pedidos = pd.DataFrame(data_pedidos)

# Selecionando todas as colunas da tabela e todas as linhas
query = """
SELECT * FROM clientes
"""
result = psql.sqldf(query)

# Selecionando todas as colunas da tabela e as 3 primeiras linhas
query = """
/* Selecionando todas as colunas da tabela cliente, porém apenas as 3 primeiras linhas */
SELECT * FROM clientes LIMIT 3
"""
result = psql.sqldf(query)

# Consulta para selecionar clientes de São Paulo
query = """
SELECT * FROM clientes WHERE cidade = 'São Paulo'
"""
result = psql.sqldf(query)

# Consulta para selecionar clientes com idade maior que 30 anos 
query = """
SELECT * FROM clientes WHERE idade < 30
"""
result = psql.sqldf(query)

# Consulta para selecionar clientes com idade maior que 30 anos que moram no Rio De Janeiro
query = """
SELECT * FROM clientes WHERE idade > 30 AND cidade = 'Rio de Janeiro'
"""
result = psql.sqldf(query)

# Consulta para selecionar clientes que possuem um nome que termina com a letra 'o'
query = """
SELECT * FROM clientes WHERE LOWER(nome) LIKE '%o'
"""
result = psql.sqldf(query)

# Consulta para selecionar pedidos do cliente com id igual a 1 cujo valor foi entre 160 e 210
query = """
SELECT * FROM pedidos WHERE id_cliente = 1 AND valor BETWEEN 160 AND 210
"""
result = psql.sqldf(query)

# Contando o número de clientes de São Paulo
query_count = """
SELECT COUNT(*) FROM clientes WHERE cidade = 'São Paulo'
"""
result = psql.sqldf(query_count)

# Contando o número de clientes de São Paulo, renomeando a coluna
query_count = """
SELECT COUNT(*) AS 'Clientes de São Paulo' FROM clientes WHERE cidade = 'São Paulo'
"""
result = psql.sqldf(query_count)

# Calculando o valor total dos pedidos
query_sum = """
SELECT SUM(valor) AS 'Total Pedidos' FROM pedidos 
"""
result = psql.sqldf(query_sum)

# Calculando a idade média dos clientes
query_avg = """
SELECT AVG(idade) AS 'Média das idades' FROM clientes
"""
result = psql.sqldf(query_avg)

# Contando o número de pedidos por cliente e o valor total, filtrando clientes com o número de pedidos maior ou igual a 2
query = """
SELECT
    id_cliente,
    COUNT(id_cliente) AS 'Número de Pedidos',
    SUM(valor) AS 'Valor Total'
FROM
    pedidos
GROUP BY
    id_cliente
HAVING
    COUNT(id_cliente) >= 2
"""
result = psql.sqldf(query)

# Selecionando o id e nome do cliente e o valor do pedido que ele fez
query = """
SELECT
    clientes.id_cliente,
    clientes.nome,
    pedidos.valor
FROM
    clientes
INNER JOIN
    pedidos
ON
    clientes.id_cliente = pedidos.id_cliente
"""
result = psql.sqldf(query)

# Selecionando o nome do cliente e o valor do pedido que ele fez
query = """
SELECT
    clientes.nome,
    pedidos.valor
FROM
    clientes
LEFT JOIN
    pedidos
ON
    clientes.id_cliente = pedidos.id_cliente
"""
result = psql.sqldf(query)

# Explicação da ordem de precedência
query = """
SELECT
    clientes.id_cliente,
    clientes.nome,
    clientes.idade,
    COUNT(*) AS 'Quantidade de Pedidos',
    SUM(pedidos.valor) AS 'Valor Total'
FROM
    clientes
INNER JOIN
    pedidos
ON
    clientes.id_cliente = pedidos.id_cliente
WHERE
    valor > 160
GROUP BY
    clientes.id_cliente
HAVING
    SUM(pedidos.valor) > 240
ORDER BY
    SUM(pedidos.valor) DESC
LIMIT
    1
"""
result = psql.sqldf(query)

# Selecionando o id, nome e valor total gasto pelo cliente. Depois, categorizando de acordo com a regra de negócio
# Se tiver um total maior que 500, é Gold. Se tiver menos que isso, mas maior que 250, é VIP. Se for menor que isso, é Regular.
query = """
SELECT
    clientes.id_cliente,
    clientes.nome,
    SUM(pedidos.valor) AS 'Valor Total',
    CASE
        WHEN SUM(pedidos.valor) > 500 THEN 'Gold'
        WHEN SUM(pedidos.valor) > 250 THEN 'VIP'
        ELSE 'Regular'
    END AS 'Categoria Cliente'
FROM
    clientes
INNER JOIN
    pedidos
ON
    clientes.id_cliente = pedidos.id_cliente
GROUP BY
    clientes.id_cliente
ORDER BY
    SUM(pedidos.valor) DESC
"""
result = psql.sqldf(query)

# Selecionando a data do pedido e uma nova coluna com o ano
query = """
SELECT
    data_pedido,
    strftime('%y', data_pedido) as 'Ano do Pedido'
FROM
    pedidos
"""
result = psql.sqldf(query)

# Selecionando a data de hoje
query = """
SELECT
    date('now') as 'Data de hoje'
"""
result = psql.sqldf(query)

# Selecionando o horário atual
query = """
SELECT time('now')
"""
result = psql.sqldf(query)

# Selecionando a data e a hora dos pedidos
query = """
SELECT datetime(data_pedido) AS 'Data e Hora pedido' FROM pedidos
"""
result = psql.sqldf(query)

# Selecionando a data e a quantidade de dias desde os pedidos
query = """
SELECT data_pedido, date('now') AS 'Data de Hoje', ROUND(julianday('now') - julianday(data_pedido), 0) AS 'Quantidade de dias desde o pedido' FROM pedidos
"""
result = psql.sqldf(query)

# Selecionando a data do pedido e a data do pedido 1 mês depois
query = """
SELECT date(data_pedido, '+1 month') FROM pedidos
"""
result = psql.sqldf(query)

# Selecionando os pedidos, numerando-os com base em seu valor
query = """
SELECT *, ROW_NUMBER() OVER(ORDER BY valor DESC) AS 'Row Number' FROM pedidos
"""
result = psql.sqldf(query)

# Selecionando os pedidos, ranqueando-os com base em seu valor
query = """
SELECT 
    *, 
    DENSE_RANK() OVER(ORDER BY valor DESC) AS 'Rank Valores' 
FROM
    pedidos
"""
result = psql.sqldf(query)

# Selecionando o id, data do pedido, valor e o valor do pedido anterior de um determinado cliente
query = """
SELECT 
    id_pedido, 
    id_cliente, 
    data_pedido, 
    valor, 
    LAG(valor, 1) OVER(ORDER BY data_pedido) AS 'Valor Anterior' 
FROM 
    pedidos
WHERE
    id_cliente = 1
"""
result = psql.sqldf(query)

# Selecionando o id, data do pedido, valor e o valor do pedido posterior de um determinado cliente
query = """
SELECT 
    id_pedido, 
    id_cliente, 
    data_pedido, 
    valor, 
    LEAD(valor, 1) OVER(ORDER BY data_pedido) AS 'Valor Posterior' 
FROM 
    pedidos
WHERE
    id_cliente = 1
"""
result = psql.sqldf(query)

# Selecionando o id, valor e o valor do primeiro pedido de um determinado cliente
query = """
SELECT
    id_pedido,
    id_cliente,
    valor,
    FIRST_VALUE(valor) OVER (PARTITION BY id_cliente ORDER BY data_pedido) AS 'Primeiro Valor'
FROM
    pedidos
"""
result = psql.sqldf(query)

# Selecionando o id, valor e o valor do último pedido de um determinado cliente
query = """
SELECT
    id_pedido,
    id_cliente,
    valor,
    LAST_VALUE(valor) OVER (PARTITION BY id_cliente) AS 'Ultimo Valor'
FROM
    pedidos
"""
result = psql.sqldf(query)

# Utilizando GROUP BY
query = """
SELECT
    id_cliente,
    SUM(valor) as 'Total Valor'
FROM
    pedidos
GROUP BY
    id_cliente
"""
result = psql.sqldf(query)

# Utilizando OVER PARTITION BY
query = """
SELECT
    id_cliente,
    SUM(valor) OVER(PARTITION BY id_cliente) AS 'Valor Total'
FROM
    pedidos
"""
result = psql.sqldf(query)

# Selecionando o nome dos clientes juntamente com o total de seus pedidos
query = """
SELECT
    nome,
    (SELECT SUM(valor) FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) AS 'Total Pedidos'
FROM
    clientes
"""
result = psql.sqldf(query)

# Selecionando todos os clientes com um total de valor de pedidos acima de 300 reais
query = """
SELECT
    *
FROM
    (SELECT *, SUM(valor) AS Total_Valor FROM pedidos INNER JOIN clientes ON pedidos.id_cliente = clientes.id_cliente GROUP BY clientes.id_cliente) AS subquery
WHERE
    Total_Valor > 300
"""
result = psql.sqldf(query)

# Selecionando clientes que fizeram pedidos acima de 200 reais
query = """
SELECT
    *
FROM
    clientes
WHERE
    id_cliente IN (SELECT id_cliente FROM pedidos WHERE valor > 200)
"""
result = psql.sqldf(query)

# Selecionando clientes cujos pedidos estão acima da média de pedidos
query = """
SELECT
    *
FROM
    clientes
WHERE
     id_cliente IN (SELECT id_cliente FROM pedidos WHERE valor > (SELECT AVG(valor) FROM pedidos))
"""
result = psql.sqldf(query)

# Selecionando clientes cujos pedidos estão acima da média de pedidos
query = """
WITH subquery AS (
    SELECT 
        id_cliente 
    FROM 
        pedidos 
    WHERE 
        valor > (SELECT AVG(valor) FROM pedidos)
)

SELECT
    *
FROM
    clientes
WHERE
     id_cliente IN (SELECT id_cliente FROM subquery)
"""
result = psql.sqldf(query)

# print(result)