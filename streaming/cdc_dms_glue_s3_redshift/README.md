
# AgroTrade – Pipeline CDC com AWS DMS, S3, Glue, Redshift e Airflow

Este projeto simula uma arquitetura moderna de ingestão e transformação de dados no contexto do agronegócio, usando como exemplo a tabela `produtos_agricolas`.

---

## 🧱 Arquitetura

```
MySQL (produtos_agricolas)
       │
       ▼
[DMS - full-load + CDC]
       │
       ▼
S3 (camada raw)
       │
       ├─▶ Glue Job (validação + transformação)
       │       │
       │       ▼
       │    S3 (camada bronze)
       │
       └─▶ DAG 1 (Airflow: agrotrade_raw_loader)
               ▼
           Redshift (raw_produtos_agricolas)
                   ▼
              DAG 2 (agrotrade_raw_to_bronze)
                      ▼
                 Redshift (bronze_produtos_agricolas)
```

---

## 🧩 Componentes

### ✅ Tabela origem – MySQL

```sql
CREATE TABLE produtos_agricolas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto VARCHAR(100) NOT NULL,
  tipo_cultura VARCHAR(50),
  preco_estimado DECIMAL(10,2),
  unidade_medida VARCHAR(10),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## ⚙️ AWS DMS

- Realiza **full-load** + **CDC**
- Envia arquivos JSON para:
  - `s3://meu-bucket-agrotrade/raw/produtos_agricolas/full-load/`
  - `s3://meu-bucket-agrotrade/raw/produtos_agricolas/cdc/`

---

## 🧪 AWS Glue Job

### Nome sugerido:
`agrotrade_raw_to_bronze_produtos`

### Funções:
- Valida campos como `preco_estimado` e `unidade_medida`
- Converte para tipos adequados
- Escreve dados em Parquet na camada `bronze`

---

## ⛓ DAG 1 – `agrotrade_raw_loader`

- Aguarda novos arquivos `.json` no S3
- Usa `S3ToRedshiftOperator` para copiar para tabela raw no Redshift

---

## ⛓ DAG 2 – `agrotrade_raw_to_bronze`

- Usa `RedshiftSQLOperator` para transformar dados raw em bronze
- Limpa campos e converte tipos

---

## 📁 Simulação de dados

- `full-load/part-00001.json`: carga inicial
- `cdc/part-00001.json`: alterações com metadados

---

## 🗂 Estrutura recomendada

```
project/
├── dags/
│   ├── agrotrade_raw_loader.py
│   └── agrotrade_raw_to_bronze.py
├── glue_jobs/
│   └── agrotrade_raw_to_bronze_produtos.py
├── simulados_dms/
│   └── produtos_agricolas/
│       ├── full-load/
│       └── cdc/
└── README.md
```

---

## 🧠 Observações

- A arquitetura é extensível para múltiplas tabelas (parametrizável)
- Permite auditoria completa mantendo `raw` intocado
- Pode evoluir para camadas **silver** e **gold**, ou alimentar dashboards

---
