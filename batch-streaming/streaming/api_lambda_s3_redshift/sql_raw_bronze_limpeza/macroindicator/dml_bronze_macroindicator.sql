INSERT INTO `bronze_terranova.macroindicator` (
  id,
  name,
  description,
  created_at,
  updated_at,
  macroprocesses,
  timestamp
)
SELECT
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"name":\s*"([^"]+)"') AS name,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]*)"') AS TIMESTAMP) AS created_at,
  CAST(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]*)"') AS TIMESTAMP) AS updated_at,
  (
    SELECT STRING_AGG(CAST(value AS STRING), ',')
    FROM UNNEST(REGEXP_EXTRACT_ALL(data, r'"macroprocesses":\s*\[(.*?)\]')) AS value
  ) AS macroprocesses,
  CURRENT_TIMESTAMP() AS timestamp
FROM
  `raw_terranova.terranova`
WHERE
  REGEXP_CONTAINS(data, r'rota/macroindicator:')
  AND REGEXP_EXTRACT(data, r'"name":\s*"([^"]+)"') IS NOT NULL;
