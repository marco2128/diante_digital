INSERT INTO `bronze_terranova.typenotes` (id, tipoapontamento, active, checklist, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"tipoapontamento":\s*"([^"]*)"') AS tipoapontamento,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"checklist":\s*(\d+)') AS INT64) AS checklist,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/typenotes:');

