# Glue Job - Transformacao camada Raw para Bronze (Mercado Eletronico)

import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.sql.functions import col, when
from datetime import datetime

# Parametros
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Data atual para particionamento
hoje = datetime.today()
ano = hoje.year
mes = hoje.month
dia = hoje.day

# Paths S3
input_path = f"s3://bucket-mercado/raw/mercadoe/products/ano={ano}/mes={mes}/dia={dia}/"
output_path = f"s3://bucket-mercado/bronze/mercadoe/products/ano={ano}/mes={mes}/dia={dia}/"

# Leitura do JSON Raw
df_raw = spark.read.json(input_path)

# Transformacoes simples (exemplos)
df_bronze = df_raw \
    .withColumn("ProductID", col("ProductID")) \
    .withColumn("Description", col("Description")) \
    .withColumn("Status", when(col("Status").isNull(), "Indefinido").otherwise(col("Status")))

# Escrita em formato Parquet na camada Bronze
df_bronze.write.mode("overwrite").parquet(output_path)

job.commit()
