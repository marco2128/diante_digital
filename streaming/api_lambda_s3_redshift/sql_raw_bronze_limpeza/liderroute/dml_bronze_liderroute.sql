INSERT INTO `bronze_terranova.liderroute` (
  unidade, macroprocesso, processo, subarea, usuario, rota, subrota, data, uuid, active, timestamp
)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"unidade":\s*"?(\d+)"?') AS INT64) AS unidade,
  CAST(REGEXP_EXTRACT(data, r'"macroprocesso":\s*"?(\d+)"?') AS INT64) AS macroprocesso,
  CAST(REGEXP_EXTRACT(data, r'"processo":\s*"?(\d+)"?') AS INT64) AS processo,
  CAST(REGEXP_EXTRACT(data, r'"subarea":\s*"?(\d+)"?') AS INT64) AS subarea,
  REGEXP_EXTRACT(data, r'"usuario":\s*"([^"]+)"') AS usuario,
  CAST(REGEXP_EXTRACT(data, r'"rota":\s*"?(\d+)"?') AS INT64) AS rota,
  CAST(REGEXP_EXTRACT(data, r'"subrota":\s*"?(\d+)"?') AS INT64) AS subrota,
  TIMESTAMP(REGEXP_EXTRACT(data, r'"data":\s*"([^"]+)"')) AS data,
  REGEXP_EXTRACT(data, r'"uuid":\s*"([^"]+)"') AS uuid,
  CASE
    WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'true' THEN TRUE
    WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'false' THEN FALSE
    ELSE NULL
  END AS active,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE REGEXP_CONTAINS(data, r'rota/liderroute:');
