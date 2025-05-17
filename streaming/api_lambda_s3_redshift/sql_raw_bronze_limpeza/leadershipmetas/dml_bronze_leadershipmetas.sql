INSERT INTO `bronze_terranova.leadershipmetas` (
    id_role, active, created_at, updated_at, role, kind_role, s1, s2, s3, s4, s5, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id_role":\s*(\d+)') AS INT64) AS id_role,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    REGEXP_EXTRACT(data, r'"role":\s*"([^"]+)"') AS role,
    REGEXP_EXTRACT(data, r'"kind_role":\s*"([^"]+)"') AS kind_role,
    CAST(REGEXP_EXTRACT(data, r'"s1":\s*(\d+)') AS INT64) AS s1,
    CAST(REGEXP_EXTRACT(data, r'"s2":\s*(\d+)') AS INT64) AS s2,
    CAST(REGEXP_EXTRACT(data, r'"s3":\s*(\d+)') AS INT64) AS s3,
    CAST(REGEXP_EXTRACT(data, r'"s4":\s*(\d+)') AS INT64) AS s4,
    CAST(REGEXP_EXTRACT(data, r'"s5":\s*(\d+)') AS INT64) AS s5,
    CURRENT_TIMESTAMP() AS timestamp 
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/leadershipmetas:');
