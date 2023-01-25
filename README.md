# 🚢 Analisando Dados de Comércio Exterior 🚢

Esse projeto explora uma base de dados do comércio exterior brasileiro divulgada pelo Ministério da Economia. As principais habilidades demandadas foram: importação de dados a partir de CSVs, criação de tabelas temporárias, cálculos utilizando funções de agregação e funções de janela (_window functions_), realização de subconsultas, _common table expressions_ (CTEs) e junção de múltiplas tabelas.


## Primeiros Passos

Para obter acesso facilitado aos dados, foi utilizado o site do projeto [Base dos Dados](https://basedosdados.org/dataset/br-me-comex-stat?bdm_table=municipio_exportacao), que visa proporcionar acesso a dados públicos de qualidade e maneira organizada. Antes de tudo, **para acessar o _datalake_ do projeto é necessário possuir conta no _Google Cloud_**. Contudo, esse é um processo rápido e bem explicado através de [tutorial](https://basedosdados.github.io/mais/access_data_bq/). 



Após isso, o acesso ao _datalake_ se dá através do pacote [basedosdados](https://pypi.org/project/basedosdados/) (utilizei a versão para Python). Na sequência, é feito o download dos dados e a exportação para o formato CSV utilizando o método _to_csv_ do pacote [pandas](https://pandas.pydata.org/). A imagem abaixo ilustra esse processo, que foi realizado também para a obtenção dos dados de importação.

![Exemplo_ImportandoDados](https://user-images.githubusercontent.com/60938249/214632078-50e38b98-8f8f-41d4-a718-ceb077f78fcb.png)



Uma visão inicial do dados permite observar que a maioria das colunas das tabelas de importação e exportação referenciam dados de outras tabelas, sendo necessário acessá-las para obtenção de maior detalhamento. Isso é feito utilizando o portal [Estatísticas de Comércio Exterior em Dados Abertos](https://www.gov.br/produtividade-e-comercio-exterior/pt-br/assuntos/comercio-exterior/estatisticas/base-de-dados-bruta), que concentra em arquivos CSV as 5 tabelas que serão utilizadas nesse processo de análise (NCM, Unidades Estatísticas da NCM, Países, Via e Unidade da RFB).

![Exemplo_TabelaExportacao](https://user-images.githubusercontent.com/60938249/214668176-2dc1455c-cab4-49f8-b9b5-2c8170c49c95.png)

## Respondendo Perguntas sobre os Dados

Após obter acesso às bases, é realizada a elaboração de consultas utilizando o SQL. A análise acabou sendo dividida em duas etapas:

  a. **[Importação dos dados para o PostgreSQL](https://github.com/angelodbarros/analise_comex/blob/main/importacao_dados.sql)**: foram criadas as tabelas no banco de dados, importados os dados e estabelecidas as diversas restrições que favorecerão a eficácia das consultas (definição de chaves primárias e estrangeiras entre as tabelas de importação e exportação com relação às demais.
  
  b. **[Busca por insights](https://github.com/angelodbarros/analise_comex/blob/main/analise_exploratoria.sql)**: nessa etapa foi selecionada a década de 2010 visando responder quatro perguntas a respeito do padrão de comércio exterior do Brasil no período:
  
  - Qual o saldo comercial registrado em cada ano?
  
  - Qual o principal item importado e exportado (US$ FOB) em cada ano?

  - Com quais países o Brasil possui balança comercial mais superavitária? E deficitária? Em qual patamar?
  
  - Qual o item mais comercializado na pauta de importação e exportação brasileira com cada um dos países com os quais se tem registro disponível?
