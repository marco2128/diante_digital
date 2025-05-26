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
