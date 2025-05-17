INSERT INTO `bronze_terranova.situation` (
    id, aspect, active, created_at, updated_at, situation, `order`,  timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    STRUCT(
        CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"id":\s*(\d+)') AS INT64) AS id,
        CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
        TIMESTAMP(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"created_at":\s*"([^"]+)"')) AS created_at,
        TIMESTAMP(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"updated_at":\s*"([^"]+)"')) AS updated_at,
        REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"aspect":\s*"([^"]+)"') AS aspect,
        REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"acronym":\s*"([^"]+)"') AS acronym,
        CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"order":\s*(\d+)') AS INT64) AS `order`
    ) AS aspect,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    REGEXP_EXTRACT(data, r'"situation":\s*"([^"]+)"') AS situation,
    CAST(REGEXP_EXTRACT(data, r'"order":\s*(\d+)') AS INT64) AS `order`,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/situation:')
