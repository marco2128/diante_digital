INSERT INTO `bronze_terranova.responsibles` (id, nome, email, active, unidade, macroprocesso, processo, subarea, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"nome":\s*"([^"]+)"') AS nome,
  REGEXP_EXTRACT(data, r'"email":\s*"([^"]+)"') AS email,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"unidade":\s*"?(\d+)"?') AS INT64) AS unidade,
  CAST(REGEXP_EXTRACT(data, r'"macroprocesso":\s*"?(\d+)"?') AS INT64) AS macroprocesso,
  CAST(REGEXP_EXTRACT(data, r'"processo":\s*"?(\d+)"?') AS INT64) AS processo,
  CAST(REGEXP_EXTRACT(data, r'"subarea":\s*"?(\d+)"?') AS INT64) AS subarea,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/responsibles:');
