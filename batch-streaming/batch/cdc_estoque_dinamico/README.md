
# Projeto CDC Estoque – MySQL para S3 com DMS, Airflow e Glue

Este projeto implementa uma arquitetura completa de ingestão incremental (CDC) da tabela `estoque` do MySQL para o data lake na AWS, utilizando DMS, S3, Glue e Airflow (MWAA).

---

## 📐 Arquitetura

```
[MySQL - tabela estoque]
        │
        ▼
[AWS DMS - delta-load + CDC]
        ▼
[S3 (raw/estoque/delta-load + cdc/)]
        ▼
[Airflow DAG: cdc_estoque_to_bronze]
        ▼
[AWS Glue Job: glue_estoque_cdc_dinamico]
        ▼
[S3 (bronze/estoque) - particionado por data]
        ▼
[Consulta via Athena ou uso em camadas silver/gold]
```

---

## 🧩 Componentes

### ✅ Tabela MySQL de origem

```sql
CREATE TABLE estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT,
  id_fazenda INT,
  quantidade DECIMAL(10,2),
  data_colheita DATE,
  FOREIGN KEY (id_produto) REFERENCES produtos_agricolas(id),
  FOREIGN KEY (id_fazenda) REFERENCES fazendas(id)
);
```

---

### ✅ AWS DMS
- Faz **full-load inicial** e ativa CDC contínuo (binlog)
- Dados são gravados no S3 como JSON
- Pastas:
  - `raw/estoque/full-load/`
  - `raw/estoque/cdc/`

---

### ✅ Airflow DAG: `cdc_estoque_to_bronze`
- Usa `S3KeySensor` para esperar arquivos `cdc/*.json`
- Aciona o Glue Job `glue_estoque_cdc_dinamico`

---

### ✅ Glue Job: `glue_estoque_cdc_dinamico`
- Lê configurações do YAML `cdc_estoque_dms_config.yaml`
- Faz merge de full-load + cdc
- Valida campos:
  - `quantidade` → decimal
  - `data_colheita` → date
- Escreve dados em Parquet na **camada Bronze**, particionando por ano, mês, dia

---

### ✅ Arquivo YAML

```yaml
pipeline:
  nome: estoque_cdc_dms
  tipo: delta
  origem:
    tabela: estoque
    campos: [id, id_produto, id_fazenda, quantidade, data_colheita]
    monitoramento:
      campo_alteracao: [quantidade, data_colheita]
```

---

## 📁 Estrutura recomendada

```
cdc_estoque_project/
├── dags/
│   └── cdc_estoque_to_bronze.py
├── glue_jobs/
│   └── glue_estoque_cdc_dinamico.py
├── glue/
│   └── configs/
│       └── cdc_estoque_dms_config.yaml
├── docs/
│   └── arquitetura_estoque.png
└── README.md
```

---

## 📊 Resultados

- Dados disponíveis em `bronze/estoque/ano=.../mes=.../dia=...`
- Preparado para alimentar camadas **silver**, **dashboards** ou **ML pipelines**

---

## 📬 Contato

Este projeto é parte do portfólio AgroTrade. Para dúvidas ou sugestões, entre em contato com o responsável técnico.
