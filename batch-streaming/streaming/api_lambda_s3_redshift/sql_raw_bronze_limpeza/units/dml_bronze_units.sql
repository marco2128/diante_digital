INSERT INTO `bronze_terranova.units` (id, sigla, unidade, active, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"sigla":\s*"([^"]*)"') AS sigla,
  REGEXP_EXTRACT(data, r'"unidade":\s*"([^"]*)"') AS unidade,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/units:');
