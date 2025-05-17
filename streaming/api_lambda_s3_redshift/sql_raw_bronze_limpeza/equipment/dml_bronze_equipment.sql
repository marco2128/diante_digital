INSERT INTO `bronze_terranova.equipment` (
    id,
    active,
    created_at,
    updated_at,
    kind_equipment,
    last_update_erp,
    unity,
    unity_actual,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"([^"]+)"') AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    CAST(REGEXP_EXTRACT(data, r'"kind_equipment":\s*(\d+)') AS INT64) AS kind_equipment,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"last_update_erp":\s*"([^"]+)"')) AS last_update_erp,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CAST(REGEXP_EXTRACT(data, r'"unity_actual":\s*(\d+)') AS INT64) AS unity_actual,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/equipment:');
