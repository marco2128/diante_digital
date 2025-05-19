INSERT INTO `bronze_terranova.criticalities` (
    id,
    criticidade,
    active,
    timestamp
)
SELECT 
    CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id,
    REGEXP_EXTRACT(data, r'"criticidade":\s*"([^"]+)"') AS criticidade,
    CASE
        WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'true' THEN TRUE
        WHEN REGEXP_EXTRACT(data, r'"active":\s*(true|false)') = 'false' THEN FALSE
        ELSE NULL
    END AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/criticalities:');
