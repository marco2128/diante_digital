INSERT INTO `bronze_terranova.valueapproach` (
    id, active, created_at, updated_at, date_of_approach, number_of_people_in_condition,
    description, options, critical_task, header_approach_stop, aspect, situation, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    DATE(REGEXP_EXTRACT(data, r'"date_of_approach":\s*"([^"]+)"')) AS date_of_approach,
    CAST(REGEXP_EXTRACT(data, r'"number_of_people_in_condition":\s*(\d+)') AS INT64) AS number_of_people_in_condition,
    REGEXP_EXTRACT(data, r'"description":\s*"([^"]*)"') AS description,
    REGEXP_EXTRACT(data, r'"options":\s*"([^"]*)"') AS options,
    CAST(REGEXP_EXTRACT(data, r'"critical_task":\s*(true|false)') AS BOOLEAN) AS critical_task,
    REGEXP_EXTRACT(data, r'"header_approach_stop":\s*"([^"]+)"') AS header_approach_stop,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*(\d+)') AS INT64) AS aspect,
    CAST(REGEXP_EXTRACT(data, r'"situation":\s*(\d+)') AS INT64) AS situation,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/valueapproach:');
