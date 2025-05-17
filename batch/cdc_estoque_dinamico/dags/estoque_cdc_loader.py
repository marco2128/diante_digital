# DAG Airflow - Aciona Glue Job estoque_cdc_dinamico após chegada de arquivos CDC no S3

from airflow import DAG
from airflow.providers.amazon.aws.sensors.s3_key import S3KeySensor
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from datetime import datetime, timedelta

with DAG(
    dag_id="estoque_cdc_loader",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    default_args={"retries": 1, "retry_delay": timedelta(minutes=5)},
    tags=["estoque", "cdc", "glue"]
) as dag:

    aguarda_arquivo_cdc = S3KeySensor(
        task_id="aguarda_arquivo_cdc_estoque",
        bucket_key="raw/estoque/cdc/*.json",
        bucket_name="bucket-agrotrade",
        aws_conn_id="aws_default",
        timeout=600,
        poke_interval=60
    )

    executa_glue_cdc = GlueJobOperator(
        task_id="executa_glue_job_estoque_cdc",
        job_name="glue_estoque_cdc_dinamico",
        script_location="s3://bucket-agrotrade/scripts/glue_estoque_cdc_dinamico.py",
        aws_conn_id="aws_default",
        region_name="us-east-1",
        iam_role_name="AWSGlueServiceRoleDefault"
    )

    aguarda_arquivo_cdc >> executa_glue_cdc
