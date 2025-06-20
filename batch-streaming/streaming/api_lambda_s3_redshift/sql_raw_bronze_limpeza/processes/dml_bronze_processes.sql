INSERT INTO `bronze_terranova.processes` (id, processo, description, active, macroprocesso, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"processo":\s*"([^"]*)"') AS processo,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"macroprocesso":\s*(\d+)') AS INT64) AS macroprocesso,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/processes:');
