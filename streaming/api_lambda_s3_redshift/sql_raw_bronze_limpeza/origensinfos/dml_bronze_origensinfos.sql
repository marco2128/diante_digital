INSERT INTO `bronze_terranova.origensinfos` (id, origem, active, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"origem":\s*"([^"]+)"') AS origem,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/origensinfos:');
