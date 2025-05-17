INSERT INTO `bronze_terranova.sector` (
    id, administration, active, created_at, updated_at, sector, acronym, `order`, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    STRUCT(
        CAST(REGEXP_EXTRACT(data, r'"administration":\s*\{"id":\s*(\d+)') AS INT64) AS id,
        CAST(REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
        TIMESTAMP(REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"created_at":\s*"([^"]+)"')) AS created_at,
        TIMESTAMP(REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"updated_at":\s*"([^"]+)"')) AS updated_at,
        REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"administration":\s*"([^"]+)"') AS administration,
        REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"acronym":\s*"([^"]+)"') AS acronym,
        CAST(REGEXP_EXTRACT(data, r'"administration":\s*\{"[^}]*"order":\s*(\d+)') AS INT64) AS `order`
    ) AS administration,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    REGEXP_EXTRACT(data, r'"sector":\s*"([^"]+)"') AS sector,
    REGEXP_EXTRACT(data, r'"acronym":\s*"([^"]+)"') AS acronym,
    CAST(REGEXP_EXTRACT(data, r'"order":\s*(\d+)') AS INT64) AS `order`,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/sector:');
