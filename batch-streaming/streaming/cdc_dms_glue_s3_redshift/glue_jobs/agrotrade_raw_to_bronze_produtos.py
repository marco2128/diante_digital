# AWS Glue Job - Transformacao camada Raw para Bronze

import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.sql.functions import when, col

# Inicializacao do contexto Glue
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Caminho de origem (camada Raw)
s3_input_path = "s3://meu-bucket-agrotrade/raw/produtos_agricolas/full-load/"

# Caminho de destino (camada Bronze)
s3_output_path = "s3://meu-bucket-agrotrade/bronze/produtos_agricolas/"

# Leitura dos dados JSON
df_raw = spark.read.json(s3_input_path)

# Transformacoes e validacoes
df_bronze = df_raw \
    .withColumn("preco_estimado", col("preco_estimado").cast("decimal(10,2)")) \
    .withColumn("unidade_medida", when(col("unidade_medida").isin("kg", "ton", "g"), col("unidade_medida"))
                                   .otherwise("indefinido"))

# Escrita no formato Parquet na camada Bronze
df_bronze.write.mode("overwrite").parquet(s3_output_path)

job.commit()
