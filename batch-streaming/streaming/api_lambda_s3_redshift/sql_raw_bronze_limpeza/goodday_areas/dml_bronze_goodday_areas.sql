INSERT INTO `bronze_terranova.goodday_areas` (id, name, description, active, created_at, updated_at, timestamp)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    REGEXP_EXTRACT(data, r'"name":\s*"([^"]+)"') AS name,
    REGEXP_EXTRACT(data, r'"description":\s*"([^"]+)"') AS description,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/goodday_areas:');
