INSERT INTO `bronze_terranova.subroutes` (id, passo, subrota, active, rota, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  CAST(REGEXP_EXTRACT(data, r'"passo":\s*(\d+)') AS INT64) AS passo,
  REGEXP_EXTRACT(data, r'"subrota":\s*"([^"]*)"') AS subrota,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"rota":\s*(\d+)') AS INT64) AS rota,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/subroutes:');
