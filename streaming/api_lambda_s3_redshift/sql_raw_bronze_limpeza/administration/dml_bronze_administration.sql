-- Inserir dados na tabela bronze_terranova.administration
INSERT INTO `bronze_terranova.administration` (
    id,
    active,
    created_at,
    updated_at,
    administration,
    acronym,
    `order`,
    timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    REGEXP_EXTRACT(data, r'"administration":\s*"([^"]+)"') AS administration,
    REGEXP_EXTRACT(data, r'"acronym":\s*"([^"]+)"') AS acronym,
    CAST(REGEXP_EXTRACT(data, r'"order":\s*(\d+)') AS INT64) AS `order`,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"timestamp":\s*"([^"]+)"')) AS timestamp
FROM `raw_terranova.terranova`
WHERE REGEXP_CONTAINS(data, r'rota/administration:');
