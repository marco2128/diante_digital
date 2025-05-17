INSERT INTO `bronze_terranova.routes` (id, rota, description, active, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"rota":\s*"([^"]+)"') AS rota,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/routes:');
