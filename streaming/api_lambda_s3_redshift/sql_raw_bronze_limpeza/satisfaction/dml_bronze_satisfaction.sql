INSERT INTO `bronze_terranova.satisfaction` (
    id, comment, note, creat_at, user, timestamp
)
SELECT 
  SAFE_CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  REGEXP_EXTRACT(data, r'"comment":\s*"([^"]*)"') AS comment,
  SAFE_CAST(REGEXP_EXTRACT(data, r'"note":\s*(\d+)') AS INT64) AS note,
  SAFE_CAST(REGEXP_EXTRACT(data, r'"creat_at":\s*"([^"]*)"') AS TIMESTAMP) AS creat_at,
  SAFE_CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,
  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/satisfaction:');
