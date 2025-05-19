INSERT INTO `bronze_terranova.headerapproach` (
    uuid, active, created_at, updated_at, date_of_approach, init_hour, end_hour,
    number_people_approached, secure_job, job, observation, insecure_conditions,
    generate_action_plan, file, user, unity, administration, sector, timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"uuid":\s*"([^"]+)"') AS uuid,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    DATE(REGEXP_EXTRACT(data, r'"date_of_approach":\s*"([^"]+)"')) AS date_of_approach,
    PARSE_TIME('%H:%M:%S', REGEXP_EXTRACT(data, r'"init_hour":\s*"([^"]+)"')) AS init_hour,
    PARSE_TIME('%H:%M:%S', REGEXP_EXTRACT(data, r'"end_hour":\s*"([^"]+)"')) AS end_hour,
    CAST(REGEXP_EXTRACT(data, r'"number_people_approached":\s*(\d+)') AS INT64) AS number_people_approached,
    CAST(REGEXP_EXTRACT(data, r'"secure_job":\s*(true|false)') AS BOOLEAN) AS secure_job,
    REGEXP_EXTRACT(data, r'"job":\s*"([^"]*)"') AS job,
    REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"') AS observation,
    REGEXP_EXTRACT(data, r'"insecure_conditions":\s*"([^"]*)"') AS insecure_conditions,
    CAST(REGEXP_EXTRACT(data, r'"generate_action_plan":\s*(true|false)') AS BOOLEAN) AS generate_action_plan,
    REGEXP_EXTRACT(data, r'"file":\s*"([^"]*)"') AS file,
    CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CAST(REGEXP_EXTRACT(data, r'"administration":\s*(\d+)') AS INT64) AS administration,
    CAST(REGEXP_EXTRACT(data, r'"sector":\s*(\d+)') AS INT64) AS sector,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/headerapproach:');
