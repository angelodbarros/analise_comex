-- Criando as duas tabelas fato que referenciam os dados históricos de comércio: importação e exportação
DROP TABLE IF EXISTS ncm_exportacao;
CREATE TABLE ncm_exportacao (
	ano NUMERIC,
	mes NUMERIC,
	id_ncm BIGINT, 
	id_unidade BIGINT,
	id_pais BIGINT, 
	sigla_uf_ncm TEXT,
	id_via BIGINT,
	id_urf BIGINT,
	quantidade_estatistica NUMERIC,
	peso_liquido_kg NUMERIC,
	valor_fob_dolar NUMERIC
	);

-- Importando os dados de um arquivo CSV para a tabela anteriormente criada
COPY ncm_exportacao
FROM 'C:\Users\Public\ncm_exportacao.csv'
DELIMITER ','
CSV HEADER;

-- Definindo as chaves primárias e estrangeiras
ALTER TABLE ncm_exportacao ADD COLUMN id SERIAL PRIMARY KEY; 
ALTER TABLE ncm_exportacao ADD FOREIGN KEY (id_unidade) REFERENCES ncm_unidade(CO_UNID),
							ADD FOREIGN KEY (id_pais) REFERENCES pais(CO_PAIS),
							ADD FOREIGN KEY (id_via) REFERENCES via(CO_VIA),
							ADD FOREIGN KEY (id_urf) REFERENCES urf(CO_URF),
							ADD FOREIGN KEY (id_ncm) REFERENCES ncm(co_ncm);

-- Repetindo o mesmo processo observado na tabela ncm_exportacao para a tabela ncm_importacao
DROP TABLE IF EXISTS ncm_importacao
CREATE TABLE ncm_importacao (
	ano NUMERIC,
	mes NUMERIC,
	id_ncm BIGINT, 
	id_unidade BIGINT,
	id_pais BIGINT,
	sigla_uf_ncm TEXT,
	id_via BIGINT,
	id_urf BIGINT,
	quantidade_estatistica NUMERIC,
	peso_liquido_kg NUMERIC,
	valor_fob_dolar NUMERIC
);

COPY ncm_importacao
FROM 'C:\Users\Public\ncm_importacao.csv'
DELIMITER ','
CSV HEADER;

DELETE FROM ncm_importacao WHERE id_urf = 710304;

ALTER TABLE ncm_importacao ADD COLUMN id SERIAL PRIMARY KEY,
							ADD FOREIGN KEY (id_unidade) REFERENCES ncm_unidade(CO_UNID),
							ADD FOREIGN KEY (id_pais) REFERENCES pais(CO_PAIS),
							ADD FOREIGN KEY (id_via) REFERENCES via(CO_VIA),
							ADD FOREIGN KEY (id_urf) REFERENCES urf(CO_URF),
							ADD FOREIGN KEY (id_ncm) REFERENCES ncm(co_ncm);


-- Criando tabelas dimensão: ncm, ncm_unidade, pais, via e URF. 
-- Processo de criação semelhante às tabelas anteriores, com exceção da definição de chaves estrangeiras

-- Tabela ncm
DROP TABLE IF EXISTS ncm
CREATE TABLE ncm (
	CO_NCM NUMERIC,
	CO_UNID NUMERIC,
	CO_SH6 NUMERIC,
	CO_PPE NUMERIC,
	CO_PPI NUMERIC,
	CO_FAT_AGREG NUMERIC,
	CO_CUCI_ITEM NUMERIC,
	CO_CGCE_N3 NUMERIC,
	CO_SIIT NUMERIC,
	CO_ISIC_CLASSE NUMERIC,
	CO_EXP_SUBSET NUMERIC,
	NO_NCM_POR TEXT,
	NO_NCM_ING TEXT,
	CONSTRAINT ncm_pkey PRIMARY KEY (CO_NCM)
);

COPY ncm
FROM 'C:\Users\Public\ncm.csv'
DELIMITER ','
CSV HEADER;

-- Tabela ncm_unidade
DROP TABLE IF EXISTS ncm_unidade
CREATE TABLE ncm_unidade (
	CO_UNID BIGINT,
	NO_UNID TEXT,
	SG_UNID TEXT,
	CONSTRAINT pkey_ncm_unidade PRIMARY KEY (CO_UNID)
);

COPY ncm_unidade
FROM 'C:\Users\Public\ncm_unidade.csv'
DELIMITER ';'
CSV HEADER;

-- Tabela país
DROP TABLE IF EXISTS pais
CREATE TABLE pais (
	CO_PAIS BIGINT,
	CO_PAIS_ISON3 BIGINT,
	CO_PAIS_ISOA3 TEXT,
	NO_PAIS TEXT,
	NO_PAIS_ING TEXT,
	CONSTRAINT pkey_pais PRIMARY KEY (CO_PAIS)
);

COPY pais
FROM 'C:\Users\Public\pais.csv'
DELIMITER ';'
CSV HEADER;


-- Tabela via
DROP TABLE IF EXISTS via
CREATE TABLE via (
	CO_VIA BIGINT,
	NO_VIA TEXT,
	CONSTRAINT pkey_via PRIMARY KEY (CO_VIA)
);

COPY via
FROM 'C:\Users\Public\via.csv'
DELIMITER ';'
CSV HEADER;


-- Tabela urf
DROP TABLE IF EXISTS urf
CREATE TABLE urf (
	CO_URF BIGINT,
	NO_URF TEXT,
	CONSTRAINT pkey_urf PRIMARY KEY (CO_URF)
);

COPY urf
FROM 'C:\Users\Public\urf.csv'
DELIMITER ';'
CSV HEADER;