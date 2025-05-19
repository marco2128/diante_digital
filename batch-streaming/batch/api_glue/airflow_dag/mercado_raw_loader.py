# DAG Airflow - Coleta dados da API Mercado Eletrônico e salva JSON no S3 (camada RAW)

from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import requests
from requests.auth import HTTPBasicAuth
import json
import urllib3
import boto3
from io import BytesIO
import os
from airflow.models import Variable

# Suprimir avisos HTTPS
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Função principal

def coleta_e_salva_api(**context):
    url = "https://api.mercadoe.com/boost/v1/Products/"
    username = Variable.get("mercadoe_username")
    password = Variable.get("mercadoe_password")
    bucket = Variable.get("mercadoe_bucket")

    todos_os_resultados = []
    urls_processadas = set()
    total_paginas = 0

    while url:
        if url in urls_processadas:
            break
        urls_processadas.add(url)

        response = requests.get(url, auth=HTTPBasicAuth(username, password), verify=False)
        response.raise_for_status()
        data = response.json()

        todos_os_resultados.extend(data.get("value", []))
        total_paginas += 1
        url = data.get("@odata.nextLink")

    if todos_os_resultados:
        s3 = boto3.client("s3")
        agora = datetime.now()
        s3_key = f"raw/mercadoe/products/ano={agora.year}/mes={agora.month}/dia={agora.day}/products.json"

        buffer = BytesIO(json.dumps(todos_os_resultados, indent=2, ensure_ascii=False).encode("utf-8"))
        s3.upload_fileobj(buffer, bucket, s3_key)
        print(f"Dados salvos em s3://{bucket}/{s3_key}")
    else:
        raise ValueError("Nenhum dado retornado da API.")

# DAG
with DAG(
    dag_id="mercadoe_raw_loader",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["mercadoe", "raw"]
) as dag:

    coleta_dados = PythonOperator(
        task_id="coleta_api_mercadoe",
        python_callable=coleta_e_salva_api,
        provide_context=True
    )

    coleta_dados
