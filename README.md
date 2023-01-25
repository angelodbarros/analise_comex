##  🚢 Analisando Dados de Comércio Exterior 🚢

Esse projeto explora uma base de dados do comércio exterior brasileiro divulgada pelo Ministério da Economia. Para obter acesso facilitado aos dados, foi utilizado o site do projeto [Base dos Dados](https://basedosdados.org/dataset/br-me-comex-stat?bdm_table=municipio_exportacao), que visa proporcionar acesso a dados públicos de qualidade e maneira organizada.


Antes de tudo, para acessar o _datalake_ do projeto é necessário possuir conta no _Google Cloud_. Contudo, esse é um processo rápido e bem explicado por [tutorial](https://basedosdados.github.io/mais/access_data_bq/) da Base dos Dados. 


Após isso, o acesso ao _datalake_ se dá através do pacote [basedosdados](https://pypi.org/project/basedosdados/) (utilizei a versão para Python). Na sequência, é feito o download dos dados e a exportação para o formato CSV utilizando o método _to_csv_ do pacote [pandas](https://pandas.pydata.org/). A imagem abaixo ilustra esse processo, que foi realizado também para a obtenção dos dados de importação.

![Exemplo_ImportandoDados](https://user-images.githubusercontent.com/60938249/214632078-50e38b98-8f8f-41d4-a718-ceb077f78fcb.png)

Uma visão inicial do dados permite observar que a maioria das colunas das tabelas de importação e exportação referenciam dados de outras tabelas, sendo necessário acessá-las para maior detalhamento. A obtenção destas é facilitada pelo portal de [Estatísticas de Comércio Exterior em Dados Abertos](https://www.gov.br/produtividade-e-comercio-exterior/pt-br/assuntos/comercio-exterior/estatisticas/base-de-dados-bruta), que concentra em arquivos CSV as 5 tabelas que serão utilizadas nesse processo de análise (NCM, Unidades Estatísticas da NCM, Países, Via e Unidade da RFB).

Após obter acesso às bases
