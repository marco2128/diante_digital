
# Projeto AWS – Ingestão de API Mercado Eletrônico com Airflow, S3, Glue e Bronze

Este projeto demonstra uma arquitetura completa para ingestão e transformação de dados de uma API com autenticação básica, usando recursos AWS como MWAA (Airflow), Amazon S3, AWS Glue e particionamento por camadas.

---

## 📐 Arquitetura

```
[Airflow DAG (MWAA)]
        ▼
[Chamada API Mercado Eletrônico]
        ▼
[Grava JSON no S3 - Camada Raw]
        ▼
[AWS Glue Job (validação e transformação)]
        ▼
[Grava Parquet no S3 - Camada Bronze]
        ▼
[Athena ou consumo posterior]
```

---

## 🧩 Componentes

### ✅ 1. Airflow DAG: `mercadoe_raw_loader`
- Realiza a chamada paginada à API usando autenticação básica
- Concatena todos os registros e salva como JSON no S3:
  ```
  s3://meu-bucket-mercadoe/raw/mercadoe/products/ano=YYYY/mes=MM/dia=DD/products.json
  ```

### ✅ 2. Glue Job: `glue_job_mercadoe_bronze.py`
- Lê os dados da camada raw
- Converte campos, trata nulos e normaliza formatos
- Salva como Parquet em:
  ```
  s3://meu-bucket-mercadoe/bronze/mercadoe/products/ano=YYYY/mes=MM/dia=DD/
  ```

### ✅ 3. Glue Crawler: `crawler_bronze_mercadoe`
- Atualiza o catálogo de dados automaticamente
- Permite consultas via Athena

---

## 🔐 Autenticação API

O DAG usa autenticação Basic Auth:
- O usuário e senha são armazenados em `Variables` do Airflow:
  - `mercadoe_username`
  - `mercadoe_password`
- A URL é paginada e segue o padrão `@odata.nextLink`

---

## 🗂 Estrutura recomendada do projeto

```
mercadoe_pipeline/
├── dags/
│   └── mercadoe_raw_loader.py
├── glue_jobs/
│   └── glue_job_mercadoe_bronze.py
├── crawlers/
│   └── crawler_bronze_mercadoe.json
├── imagens/
│   └── arquitetura.png
└── README.md
```

---

## 🔍 Observações

- Pode ser estendido para múltiplos endpoints da API
- É possível orquestrar DAGs de Bronze → Silver
- Permite auditoria e validação por data de carga

---

## 📬 Contato

Para dúvidas ou sugestões, entre em contato com o responsável pelo pipeline ou contribua com melhorias no repositório.
