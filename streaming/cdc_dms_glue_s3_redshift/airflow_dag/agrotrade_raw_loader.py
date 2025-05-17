from airflow import DAG
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator
from airflow.providers.amazon.aws.sensors.s3_key import S3KeySensor
from datetime import datetime

with DAG(
    dag_id="agrotrade_raw_loader",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@hourly",
    catchup=False,
    tags=["agrotrade", "raw"]
) as dag:

    aguarda_arquivo = S3KeySensor(
        task_id="aguarda_arquivo_dms",
        bucket_key="raw/produtos_agricolas/full-load/*.json",
        bucket_name="meu-bucket-agrotrade",
        aws_conn_id="aws_default",
        timeout=300,
        poke_interval=60
    )

    carrega_raw = S3ToRedshiftOperator(
        task_id="carrega_raw_produtos",
        schema="raw",
        table="raw_produtos_agricolas",
        s3_bucket="meu-bucket-agrotrade",
        s3_key="raw/produtos_agricolas/full-load/",
        copy_options=["FORMAT AS JSON 'auto'"],
        aws_conn_id="aws_default",
        redshift_conn_id="aws_redshift_conn"
    )

    aguarda_arquivo >> carrega_raw
