import os
import ast
import logging
from datetime import datetime, timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.operators.dummy import DummyOperator
from airflow.providers.google.cloud.operators.bigquery import RedshiftSQLOperator
from airflow.utils.task_group import TaskGroup
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor
from common.config.owners import Owners

department = "terranova"
str_tables_list = Variable.get(f"{department}_silver_tables")
tables_list = ast.literal_eval(str_tables_list)

def create_taskgroup(task_group_prefix, table, department):
    with TaskGroup(group_id=f"{task_group_prefix}_{table}") as tg1:
        ddl_path = f"queries/silver/{department}/{table}/ddl_silver_{table}.sql"
        dml_path = f"queries/silver/{department}/{table}/dml_silver_{table}.sql"

        # Logs detalhados sobre o processo
        logging.info(f"Preparando para criar e popular a tabela: {table}")
        logging.info(f"Usando DDL: {ddl_path}")
        logging.info(f"Usando DML: {dml_path}")

        try:
            logging.info(f"Iniciando execução do DDL para a tabela: {table}")
            create_table = _create_table(
                table,
                ddl_path,
            )
            logging.info(f"DDL executado com sucesso para a tabela: {table}")
        except Exception as e:
            logging.error(f"Erro ao criar a tabela {table}: {e}")
            raise  # Rethrow exception to falhar o DAG corretamente

        try:
            logging.info(f"Iniciando execução do DML para a tabela: {table}")
            populate_table = _populate_table(
                table,
                dml_path,
            )
            logging.info(f"DML executado com sucesso para a tabela: {table}")
        except Exception as e:
            logging.error(f"Erro ao popular a tabela {table}: {e}")
            raise  # Rethrow exception to falhar o DAG corretamente

        # Define dependência entre as tarefas
        create_table >> populate_table

        return tg1

def _create_table(table, sql_name):

    return RedshiftSQLOperator(
        task_id=f"create_query_{table}_job",
        configuration={
            "query": {
                "query": f"{sql_name}",
                "useLegacySql": False,
            }
        },
        location="us-east1",
        redshift_conn_id="aws_redshift_conn",
    )

def _populate_table(table, sql_name):
    # Lê o conteúdo do arquivo SQL
    dml_query_path = f"/home/airflow/gcs/plugins/{sql_name}"
    try:
        with open(dml_query_path, "r") as file:
            dml_query = file.read()
    except Exception as e:
        logging.error(f"Erro ao ler o DML da tabela {table}: {e}")
        raise

    # Loga o conteúdo do DML
    logging.info(f"Executando DML para a tabela {table}:")
    logging.info(f"\n{dml_query}")

    # Retorna a tarefa RedshiftSQLOperator
    return RedshiftSQLOperator(
        task_id=f"populate_query_{table}_job",
        sql=dml_query,
        location="us-east1",
        redshift_conn_id="aws_redshift_conn",
    )

default_args = {
    "owner": Owners.DATA_ENGINEERING.value,
    "depends_on_past": False,
    "email": [""],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
    "max_active_runs": 1,
}

with DAG(
    f"bronze_to_silver_{department}",
    default_args=default_args,
    description="",
    schedule_interval=None,
    start_date=datetime(2024, 1, 10),
    
    catchup=False
) as dag:

    start = DummyOperator(task_id="start")
    end = DummyOperator(task_id="end")

    for table_info in tables_list:
        table = table_info["table"]

        # Aqui removemos o sensor, indo direto para o TaskGroup de criação e popularização
        tg_group = create_taskgroup("carrega_silver", table, department)

        # Encadeamento das tarefas sem o sensor
        start >> tg_group >> end

