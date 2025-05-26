# Projeto Diante Digital

Este repositório contém a estrutura completa de um projeto de dados com suporte a cargas batch, streaming e modelagem de dados com dbt no Redshift.

## 📁 Estrutura do Projeto



## ⚙️ Tecnologias Utilizadas

- **AWS Glue**
- **AWS Lambda**
- **Amazon Redshift**
- **Amazon S3**
- **DBT**
- **Kubernetes (observabilidade)**

## 🚀 Execução

1. Configure as variáveis de ambiente e credenciais AWS.
2. Execute os jobs batch com Glue ou streaming com Lambda.
3. Utilize o diretório `dbt/redshift_lab` para modelagem no Redshift.


================
# Projeto DBT — Diante Digital

Este repositório implementa uma arquitetura de transformação de dados utilizando **dbt (Data Build Tool)** em três camadas:

## 🧱 Camadas

- **Bronze (`staging`)**: Leitura dos dados brutos da camada `raw` e padronização de nomes.
- **Silver (`intermediate`)**: Aplicação de regras de negócio e tratamento de valores.
- **Gold (`marts`)**: Modelos finais prontos para análise.

---

## 🗃️ Fonte de dados

- **Tabela raw:** `raw_data.dados_global`
- Schema de origem: `raw_data`
- Campos: `tipo`, `cenario`, `trimestre`, `ano`, `preco`

---

## 🏗️ Organização dos modelos

```bash
models/
├── staging/
│   └── stg_dados_global.sql      # Camada bronze
├── intermediate/
│   └── silver_dados_global.sql   # Camada silver
└── marts/
    └── gold_dados_global.sql     # Camada gold


