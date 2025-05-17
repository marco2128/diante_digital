INSERT INTO `bronze_terranova.operationalkpis` (id, operationalkpi, description, active, origininfo, subarea, levelsubarea, timestamp)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"operationalkpi":\s*"([^"]+)"') AS operationalkpi,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"origininfo":\s*(\d+)') AS INT64) AS origininfo,
  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"subarea":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS subarea,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"levelsubarea":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS levelsubarea,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/operationalkpis:');


