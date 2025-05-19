INSERT INTO `bronze_terranova.goodday` (
    id, name, description, initial_date, final_date, reprogram_date, planned, accomplished,
    comment, action, created_at, updated_at, responsible, status, timestamp
)
SELECT 
    SAFE_CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    REGEXP_EXTRACT(data, r'"name":\s*"([^"]*)"') AS name,
    REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"initial_date":\s*"([^"]*)"') AS DATE) AS initial_date,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"final_date":\s*"([^"]*)"') AS DATE) AS final_date,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"reprogram_date":\s*"([^"]*)"') AS DATE) AS reprogram_date,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"planned":\s*(\d+)') AS INT64) AS planned,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"accomplished":\s*(\d+)') AS INT64) AS accomplished,
    REGEXP_EXTRACT(data, r'"comment":\s*"([^"]*)"') AS comment,
    REGEXP_EXTRACT(data, r'"action":\s*"([^"]*)"') AS action,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]*)"') AS TIMESTAMP) AS created_at,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]*)"') AS TIMESTAMP) AS updated_at,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"responsible":\s*(\d+)') AS INT64) AS responsible,
    SAFE_CAST(REGEXP_EXTRACT(data, r'"status":\s*(\d+)') AS INT64) AS status,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/goodday:');
