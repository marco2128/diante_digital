INSERT INTO `bronze_terranova.macroindicators` (
  id,
  macroindicator,
  description,
  active,
  levelsubarea,
  timestamp
)
SELECT
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"macroindicator":\s*"([^"]+)"') AS macroindicator,
  REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  -- Transformação para converter o array de levelsubarea em uma string separada por vírgulas
  (SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
   FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"levelsubarea":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS levelsubarea,
  CURRENT_TIMESTAMP() AS timestamp
FROM
  `raw_terranova.terranova`
WHERE
  REGEXP_CONTAINS(data, r'rota/macroindicators:')
  AND REGEXP_EXTRACT(data, r'"macroindicator":\s*"([^"]+)"') IS NOT NULL;
