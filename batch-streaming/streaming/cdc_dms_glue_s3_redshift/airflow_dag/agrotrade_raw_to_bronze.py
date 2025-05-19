from airflow import DAG
from airflow.providers.amazon.aws.operators.redshift_sql import RedshiftSQLOperator
from datetime import datetime

with DAG(
    dag_id="agrotrade_raw_to_bronze",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["agrotrade", "bronze"]
) as dag:

    transforma_para_bronze = RedshiftSQLOperator(
        task_id="transforma_raw_para_bronze",
        sql="""
        CREATE TABLE IF NOT EXISTS bronze_produtos_agricolas AS
        SELECT
            CAST(id AS INT) AS id,
            nome_produto,
            tipo_cultura,
            CAST(NULLIF(preco_estimado, '') AS DECIMAL(10,2)) AS preco_estimado,
            CASE
                WHEN unidade_medida IN ('kg', 'ton', 'g') THEN unidade_medida
                ELSE 'indefinido'
            END AS unidade_medida,
            PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', criado_em) AS criado_em
        FROM raw.raw_produtos_agricolas
        WHERE nome_produto IS NOT NULL;
        """,
        redshift_conn_id="aws_redshift_conn"
    )

    transforma_para_bronze
