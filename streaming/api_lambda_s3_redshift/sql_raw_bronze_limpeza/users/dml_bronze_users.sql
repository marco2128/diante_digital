INSERT INTO `bronze_terranova.users` (
    id, username, email, cpf, unidade, macroprocesso, processo, subarea, checklist, rota, subrota, active, timestamp
)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"username":\s*"([^"]*)"') AS username,
  REGEXP_EXTRACT(data, r'"email":\s*"([^"]*)"') AS email,
  REGEXP_EXTRACT(data, r'"cpf":\s*"([^"]*)"') AS cpf,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"unidade":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS unidade,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"macroprocesso":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS macroprocesso,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"processo":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS processo,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"subarea":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS subarea,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"checklist":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS checklist,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"rota":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS rota,

  (
    SELECT STRING_AGG(CAST(TRIM(value) AS STRING), ',')
    FROM UNNEST(SPLIT(REGEXP_EXTRACT(data, r'"subrota":\s*\[(.*?)\]'), r',\s*')) AS value
  ) AS subrota,

  COALESCE(CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL), FALSE) AS active,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/users:');
