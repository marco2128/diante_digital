INSERT INTO `bronze_terranova.levelsubareas` (id, levelsubarea, description, active, subarea, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  CAST(REGEXP_EXTRACT(data, r'"levelsubarea":\s*(\d+)') AS INT64) AS levelsubarea,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"subarea":\s*(\d+)') AS INT64) AS subarea,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/levelsubareas:');
