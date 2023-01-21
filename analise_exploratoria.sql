-- Verificando o período de tempo para os quais existem dados disponíveis

SELECT DISTINCT ano
FROM ncm_exportacao;

SELECT DISTINCT ano
FROM ncm_importacao;

-- Criando tabelas temporárias para utilizar uma amostra dos dados (década de 2010)
CREATE TEMP TABLE dados_exportacao AS (
SELECT *
FROM ncm_exportacao
WHERE ano >= 2010 AND ano < 2021
);

CREATE TEMP TABLE dados_importacao AS (
SELECT *
FROM ncm_importacao
WHERE ano >= 2010 AND ano < 2021
);

-- 1. Estimando valor exportado e importado ao longo da década através do cálculo do saldo comercial --


-- O resultado apresenta uma tendência do Brasil de possuir uma balança comercial superavitária ao longo da década,
-- aspecto não observado somente no biênio 13/14 (em um patamar relativamente pequeno)
WITH exportacao_anual AS (
SELECT ano,
	SUM(valor_fob_dolar) AS dolares_exportacao
FROM dados_exportacao
GROUP BY ano
ORDER BY ano
),
importacao_anual AS (
SELECT ano,
	SUM(valor_fob_dolar) AS dolares_importacao
FROM dados_importacao
GROUP BY ano
ORDER BY ano
)

SELECT impor.ano,
	impor.dolares_importacao/1e9 AS importacao,
	expor.dolares_exportacao/1e9 AS exportacao,
	(expor.dolares_exportacao - impor.dolares_importacao)/1e9 AS saldo_comercial
FROM importacao_anual AS impor
JOIN exportacao_anual AS expor
ON impor.ano = expor.ano


-- 2. Qual o item mais exportado e importado anualmente? -- 


-- Exportação
-- Os itens com maior valor de negociação foram o minério de ferro (2010-13) e posteriormente a soja, 
-- um demonstrativo da capacidade competitiva brasileira na exportação de commodities
WITH exportacao_por_produto AS(
SELECT ano,
		id_ncm,
		SUM(valor_fob_dolar) AS total_exportado
FROM dados_exportacao
GROUP BY ano, id_ncm
ORDER BY ano, total_exportado DESC
	),

ranking AS(
SELECT *,
		RANK() OVER(PARTITION BY ano
				   ORDER BY ano, total_exportado DESC) AS posicao
FROM exportacao_por_produto
)

SELECT ranking.ano, ranking.total_exportado, ncm.no_ncm_por
FROM ranking
JOIN ncm
ON ranking.id_ncm = ncm.co_ncm
WHERE posicao = 1;

-- Importação
-- A primeira  metade da década teve derivados brutos do petróleo como principal item de importação. Já a segunda metade
-- registrou produtos derivados do refino de petróleo bruto como principal importação, possível reflexo de uma insuficiente capacidade 
-- de refino interna
WITH importacao_por_produto AS(
SELECT ano,
		id_ncm,
		SUM(valor_fob_dolar) AS total_importado
FROM dados_importacao
GROUP BY ano, id_ncm
ORDER BY ano, total_importado DESC
	),

ranking AS(
SELECT *,
		RANK() OVER(PARTITION BY ano
				   ORDER BY ano, total_importado DESC) AS posicao
FROM importacao_por_produto
)

SELECT ranking.ano, ranking.total_importado, ncm.no_ncm_por
FROM ranking
JOIN ncm
ON ranking.id_ncm = ncm.co_ncm
WHERE posicao = 1;


-- 3. Com quais países o Brasil possui os maiores níveis de saldo da balança comercial (superávit e déficit)? --


WITH tabela_exportacao AS(
SELECT id_pais,
		SUM(valor_fob_dolar) AS  valor_exportacao
FROM dados_exportacao
GROUP BY id_pais
ORDER BY id_pais
),
tabela_importacao AS(
SELECT id_pais,
	SUM(valor_fob_dolar) AS  valor_importacao
FROM dados_importacao
GROUP BY id_pais
ORDER BY id_pais
)
SELECT *
	INTO saldo_comercial -- criando tabela temporária 'saldo_comercial'
	FROM tabela_exportacao AS expo
	FULL JOIN tabela_importacao AS impo
	USING(id_pais)

-- Selecionando os saldos comerciais mais superavitários
SELECT pais.no_pais AS pais, (saldo.valor_exportacao - saldo.valor_importacao)/1e9 AS saldo
FROM saldo_comercial AS saldo
JOIN pais
ON saldo.id_pais = pais.co_pais
WHERE saldo IS NOT NULL
ORDER BY saldo DESC
LIMIT 15
-- Selecionando os saldos comerciais mais deficitários
SELECT pais.no_pais AS pais,
		(saldo.valor_exportacao - saldo.valor_importacao)/1e9 AS saldo
FROM saldo_comercial AS saldo
JOIN pais
ON saldo.id_pais = pais.co_pais
WHERE saldo IS NOT NULL
ORDER BY saldo
LIMIT 15;



-- 4. Qual a principal mercadoria exportada e importada no comércio entre Brasil e demais países? --

-- Exportação
SELECT no_pais, no_ncm_por, valor_total/1e9 AS valor_total
FROM (
		SELECT no_pais,
				id_ncm,
				SUM(valor_fob_dolar) AS valor_total,
				RANK() OVER(PARTITION BY no_pais
				   			ORDER BY SUM(valor_fob_dolar) DESC) AS ranking
		FROM dados_exportacao 
		JOIN pais ON dados_exportacao.id_pais = pais.co_pais
		GROUP BY no_pais, id_ncm
		ORDER BY no_pais, valor_total DESC
	) AS subq
JOIN ncm ON subq.id_ncm = ncm.co_ncm
WHERE ranking = 1
ORDER BY valor_total DESC;

-- Importação
SELECT no_pais, no_ncm_por, valor_total/1e9 AS valor_total
FROM (
		SELECT no_pais,
				id_ncm,
				SUM(valor_fob_dolar) AS valor_total,
				RANK() OVER(PARTITION BY no_pais
				   			ORDER BY SUM(valor_fob_dolar) DESC) AS ranking
		FROM dados_importacao 
		JOIN pais ON dados_importacao.id_pais = pais.co_pais
		GROUP BY no_pais, id_ncm
		ORDER BY no_pais, valor_total DESC
	) AS subq
JOIN ncm ON subq.id_ncm = ncm.co_ncm
WHERE ranking = 1
ORDER BY valor_total DESC;