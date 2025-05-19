# Projeto Terranova - Ingestão de Dados (AWS)

Este projeto migra o sistema de ingestão originalmente desenvolvido na GCP (Projeto Agronex) para a arquitetura da AWS, utilizando serviços como **AWS Lambda**, **Amazon SNS**, **Secrets Manager** e **MWAA (Apache Airflow)**.

---

## 📌 Visão Geral da Arquitetura

- **Fonte de Dados**: APIs autenticadas via Basic Auth
- **Ingestão**: AWS Lambda executando por evento ou chamada Airflow
- **Publicação**: Mensagens formatadas são enviadas ao **Amazon SNS**
- **Orquestração**: Apache Airflow (MWAA) programa e aciona a ingestão
- **Segredos**: Usuário e senha armazenados no **AWS Secrets Manager**

---

## 📁 Estrutura do Projeto

```bash
common/
├── sns_client.py               # Publica mensagens no Amazon SNS
├── secret_client_aws.py        # Obtém segredos do AWS Secrets Manager

terranova/
├── carga_terranova_lambda.py   # Função Lambda principal
├── main_aws.py                 # Endpoint para chamada via API/Gateway ou Airflow
├── carga_terranova_client.py   # Versão adaptada da GCP
├── external_ingestion_aws.py   # DAG do Airflow
├── external_ingestion_aws.yaml # Configurações da DAG
```

---

## 🚀 Execução Local

1. Configure suas variáveis de ambiente:
```bash
export AWS_REGION=us-east-1
export TOPIC_ARN=arn:aws:sns:us-east-1:123456789012:topico-terranova
export URL_BASE=https://api.terranova.com/v1
```

2. Instale dependências:
```bash
pip install -r requirements.txt
```

3. Execute um ingestor manual:
```python
from carga_terranova_client import prep
prep("goodday")
```

---

## 🛠️ Deploy como AWS Lambda

1. Comprima os arquivos com `carga_terranova_lambda.py` + pasta `common/`
2. Faça upload via AWS Console ou CLI
3. Defina a `handler`: `carga_terranova_lambda.lambda_handler`
4. Configure variáveis de ambiente:
   - `TOPIC_ARN`
   - `URL_BASE`

---

## 🔄 Integração com Airflow (MWAA)

- Use a DAG `external_ingestion_aws.py`
- Configure a conexão HTTP: `http_lambda_terranova`
- As tasks chamam o Lambda por `SimpleHttpOperator`

---

## 🔐 Configuração de Segredos (Secrets Manager)

Crie dois segredos:
- `carga_agronex_user`
- `carga_agronex_pass`

Ambos acessados via `get_credential(secret_name)`

---

## 📞 Exemplo de chamada para o Lambda

```json
{
  "option": "goodday"
}
```

---

## 📬 Resultado esperado

Retorno JSON com status HTTP:
```json
{
  "statusCode": 200,
  "body": "{"mensagens_publicadas": 120}"
}
```

---

## 📌 Autor

Engenheiro de Dados: Marco  
Migração GCP → AWS com foco em eficiência, automação e boas práticas.



## 🔄 Versão com Kinesis Firehose

Este projeto foi atualizado para usar **Amazon Kinesis Data Firehose** no lugar do Amazon SNS.

### ✅ Novo fluxo:

```
[Airflow DAG (MWAA)]
        └──► [Lambda: carga_terranova_lambda_firehose]
                   └──► [Kinesis Firehose]
                              └──► [S3 / Redshift / OpenSearch]
```

---

### 🛠️ Deploy como AWS Lambda (Firehose)

1. Empacote `carga_terranova_lambda_firehose.py` junto com a pasta `common/`
2. Faça upload via AWS Console ou CLI
3. Defina como handler:
   ```
   carga_terranova_lambda_firehose.lambda_handler
   ```
4. Configure as variáveis de ambiente:
   - `DELIVERY_STREAM_NAME` → Nome do seu stream Firehose
   - `URL_BASE`, `AWS_REGION`

---

### 📬 Exemplo de chamada via Airflow (ou API Gateway)

```json
{
  "option": "goodday"
}
```

---

### ✅ Resultado esperado

O dado é enviado para o Kinesis Firehose, que irá armazená-lo automaticamente no destino configurado (ex: Amazon S3, Redshift, ou OpenSearch).


---

## 📝 Atualização dos Scripts DML

Todos os arquivos `dml_*.sql` foram adaptados para refletir a nova nomenclatura do projeto **Terranova**.

### 🔄 Mudanças aplicadas:
- Substituição de `"agronex"` por `"terranova"` em todos os arquivos DML
- Aplicado em múltiplas pastas e arquivos compactados:
  - `dml_terranova.zip`
  - `dml_terranova_tasks_un.zip`

### 💡 Uso recomendado
- Estes arquivos podem ser referenciados diretamente pelas DAGs `raw_to_bronze_terranova` e `bronze_to_silver_terranova` com `RedshiftSQLOperator`.

Certifique-se de que o caminho dos arquivos `.sql` esteja disponível no diretório onde o Airflow executa (`/opt/airflow/dags/queries/...` ou em um bucket S3 montado).

