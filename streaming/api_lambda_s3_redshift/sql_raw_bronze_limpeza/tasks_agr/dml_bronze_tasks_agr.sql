INSERT INTO `bronze_terranova.tasks_agr` (
    id,
    active,
    created_at,
    updated_at,
    task,
    initial_date,
    final_date,
    reprogrammed_date,
    evidence,
    observation,
    responsible,
    new_responsible,
    status,
    timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    -- Converte a data para STRING
    FORMAT_DATE('%Y-%m-%d', DATE(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"'))) AS created_at,
    FORMAT_DATE('%Y-%m-%d', DATE(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"'))) AS updated_at,
    REGEXP_EXTRACT(data, r'"task":\s*"([^"]+)"') AS task,
    REGEXP_EXTRACT(data, r'"initial_date":\s*"([^"]+)"') AS initial_date,
    REGEXP_EXTRACT(data, r'"final_date":\s*"([^"]+)"') AS final_date,
    REGEXP_EXTRACT(data, r'"reprogrammed_date":\s*"([^"]*)"') AS reprogrammed_date,
    REGEXP_EXTRACT(data, r'"evidence":\s*"([^"]*)"') AS evidence,
    REGEXP_EXTRACT(data, r'"observation":\s*"([^"]+)"') AS observation,
    CAST(REGEXP_EXTRACT(data, r'"responsible":\s*(\d+)') AS INT64) AS responsible,
    CAST(REGEXP_EXTRACT(data, r'"new_responsible":\s*(\d+)') AS INT64) AS new_responsible,
    CAST(REGEXP_EXTRACT(data, r'"status":\s*(\d+)') AS INT64) AS status,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/tasks_agr:');
