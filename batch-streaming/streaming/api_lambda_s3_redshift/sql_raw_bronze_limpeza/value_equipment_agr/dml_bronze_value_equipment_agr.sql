INSERT INTO `bronze_terranova.value_equipment_agr` (
    id,
    active,
    created_at,
    updated_at,
    observation,
    files,
    id_header,
    question,
    type_note,
    timestamp
)
SELECT 
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    DATE(CAST(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"') AS TIMESTAMP)) AS created_at, -- Apenas a data
    DATE(CAST(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"') AS TIMESTAMP)) AS updated_at, -- Apenas a data
    REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"') AS observation,
    REGEXP_EXTRACT(data, r'"files":\s*"([^"]*)"') AS files,
    REGEXP_EXTRACT(data, r'"id_header":\s*"([^"]*)"') AS id_header,
    REGEXP_EXTRACT(data, r'"question":\s*"([^"]*)"') AS question,
    CAST(REGEXP_EXTRACT(data, r'"type_note":\s*(\d+)') AS INT64) AS type_note,
    CURRENT_TIMESTAMP() AS timestamp
FROM `raw_terranova.terranova`
WHERE REGEXP_CONTAINS(data, r'rota/value_equipment_agr:');
