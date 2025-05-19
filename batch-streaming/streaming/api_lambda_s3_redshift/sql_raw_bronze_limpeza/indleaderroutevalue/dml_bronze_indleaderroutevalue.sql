INSERT INTO `bronze_terranova.indleaderroutevalue` (
  id, uuid, observation, files, active, updated_at, question,  note_type, timestamp
)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"uuid":\s*"([^"]+)"') AS uuid,
  REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"?') AS observation,
  REGEXP_EXTRACT(data, r'"files":\s*"([^"]*)"?') AS files,  -- Caso 'files' seja uma string
  CASE
    WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'true' THEN TRUE
    WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'false' THEN FALSE
    ELSE NULL
  END AS active,
  TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
  REGEXP_EXTRACT(data, r'"question":\s*"([^"]+)"') AS question,
  CAST(REGEXP_EXTRACT(data, r'"note_type":\s*"?(\d+)"?') AS INT64) AS note_type,
  CURRENT_TIMESTAMP() AS timestamp 
FROM 
  `raw_terranova.terranova`
WHERE REGEXP_CONTAINS(data, r'rota/indleaderroutevalue:');




