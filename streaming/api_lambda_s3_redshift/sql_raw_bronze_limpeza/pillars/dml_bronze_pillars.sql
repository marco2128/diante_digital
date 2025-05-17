INSERT INTO `bronze_terranova.pillars` (id, pilar, active, order_1, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"pilar":\s*"([^"]+)"') AS pilar,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"order":\s*"?(\d+)"?') AS INT64) AS order_1,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/pillars:');
