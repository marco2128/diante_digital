# Glue Job dinâmico que carrega config.yaml para tratar CDC da tabela estoque

import sys
import yaml
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.job import Job
from pyspark.sql.functions import col, year, month, dayofmonth, when
from datetime import datetime
import boto3

# Inicialização
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Lê arquivo YAML de configuração do S3
s3 = boto3.client('s3')
bucket = "bucket-agrotrade"
config_key = "glue/configs/cdc_estoque_dms_config.yaml"
obj = s3.get_object(Bucket=bucket, Key=config_key)
config = yaml.safe_load(obj['Body'])

# Extrai caminhos
raw_path = config['raw']['destino_s3'] + 'full-load/'
cdc_path = config['raw']['destino_s3'] + config['raw']['estrutura']['cdc_dir']
bronze_path = config['bronze']['destino_s3']

# Leitura de dados CDC e Full
df_raw = spark.read.json(raw_path)
df_cdc = spark.read.json(cdc_path)

# Merge (assume que cdc tem mesmo schema que raw)
df_merged = df_raw.unionByName(df_cdc, allowMissingColumns=True)

# Valida campos
df_tratado = df_merged \
    .withColumn("quantidade", col("quantidade").cast("decimal(10,2)")) \
    .withColumn("data_colheita", col("data_colheita").cast("date")) \
    .withColumn("ano", year(col("data_colheita"))) \
    .withColumn("mes", month(col("data_colheita"))) \
    .withColumn("dia", dayofmonth(col("data_colheita")))

# Escreve em formato particionado por data
df_tratado.write.mode("overwrite").partitionBy("ano", "mes", "dia").parquet(bronze_path)

job.commit()
