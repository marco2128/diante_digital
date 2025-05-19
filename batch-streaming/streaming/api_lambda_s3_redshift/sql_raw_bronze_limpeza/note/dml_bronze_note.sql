INSERT INTO `bronze_terranova.note_headers`
(
    uuid,
    active,
    created_at,
    updated_at,
    date_of_approach,
    init_hour,
    end_hour,
    number_people_approached,
    secure_job,
    job,
    observation,
    insecure_conditions,
    generate_action_plan,
    file,
    user,
    unity,
    administration,
    sector,
    timestamp
)
SELECT
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"uuid"\s*:\s*"(.*?)"') AS uuid,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"active"\s*:\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"created_at"\s*:\s*"(.*?)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"updated_at"\s*:\s*"(.*?)"')) AS updated_at,
    DATE(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"date_of_approach"\s*:\s*"(.*?)"')) AS date_of_approach,
    PARSE_TIME('%H:%M:%S', REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"init_hour"\s*:\s*"(.*?)"')) AS init_hour,
    PARSE_TIME('%H:%M:%S', REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"end_hour"\s*:\s*"(.*?)"')) AS end_hour,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"number_people_approached"\s*:\s*(\d+)') AS INT64) AS number_people_approached,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"secure_job"\s*:\s*(true|false)') AS BOOLEAN) AS secure_job,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"job"\s*:\s*"(.*?)"') AS job,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"observation"\s*:\s*"(.*?)"') AS observation,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"insecure_conditions"\s*:\s*"(.*?)"') AS insecure_conditions,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"generate_action_plan"\s*:\s*(true|false)') AS BOOLEAN) AS generate_action_plan,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"file"\s*:\s*"(.*?)"') AS file,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"user"\s*:\s*(\d+)') AS INT64) AS user,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"unity"\s*:\s*(\d+)') AS INT64) AS unity,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"administration"\s*:\s*(\d+)') AS INT64) AS administration,
    SAFE_CAST(REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"sector"\s*:\s*(\d+)') AS INT64) AS sector,
    CURRENT_TIMESTAMP() AS timestamp 
FROM `raw_terranova.terranova`
WHERE data like '%rota/note:%';
-------------------------------------------------------
INSERT INTO `bronze_terranova.note_values`
(
    id,
    header_uuid,
    active,
    created_at,
    updated_at,
    date_of_approach,
    number_of_people_in_condition,
    description,
    options,
    critical_task,
    aspect,
    situation,
    timestamp
)
SELECT
    SAFE_CAST(REGEXP_EXTRACT(value, r'"id"\s*:\s*(\d+)') AS INT64) AS id,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"uuid"\s*:\s*"(.*?)"') AS header_uuid,
    SAFE_CAST(REGEXP_EXTRACT(value, r'"active"\s*:\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(value, r'"created_at"\s*:\s*"(.*?)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(value, r'"updated_at"\s*:\s*"(.*?)"')) AS updated_at,
    DATE(REGEXP_EXTRACT(value, r'"date_of_approach"\s*:\s*"(.*?)"')) AS date_of_approach,
    SAFE_CAST(REGEXP_EXTRACT(value, r'"number_of_people_in_condition"\s*:\s*(\d+)') AS INT64) AS number_of_people_in_condition,
    REGEXP_EXTRACT(value, r'"description"\s*:\s*"(.*?)"') AS description,
    REGEXP_EXTRACT(value, r'"options"\s*:\s*"(.*?)"') AS options,
    SAFE_CAST(REGEXP_EXTRACT(value, r'"critical_task"\s*:\s*(true|false)') AS BOOLEAN) AS critical_task,
    SAFE_CAST(REGEXP_EXTRACT(value, r'"aspect"\s*:\s*(\d+)') AS INT64) AS aspect,
    CURRENT_TIMESTAMP() AS timestamp 
FROM `raw_terranova.terranova`,
    UNNEST(JSON_EXTRACT_ARRAY(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), '$.values')) AS value
WHERE REGEXP_CONTAINS(data, r'rota/note:');

-----------------------------------------------
INSERT INTO `bronze_terranova.note_action_plan`
(
    id,
    header_uuid,
    active,
    created_at,
    updated_at,
    date_of_approach,
    number_of_people_in_condition,
    critical,
    init_date,
    end_date,
    reprogram_date,
    action,
    observation,
    file,
    finished,
    unity,
    administration,
    sector,
    aspect,
    situation,
    responsible,
    status,
    timestamp
)
SELECT
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"id"\s*:\s*(\d+)') AS INT64) AS id,
    REGEXP_EXTRACT(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), r'"uuid"\s*:\s*"(.*?)"') AS header_uuid,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"active"\s*:\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(plan, r'"created_at"\s*:\s*"(.*?)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(plan, r'"updated_at"\s*:\s*"(.*?)"')) AS updated_at,
    DATE(REGEXP_EXTRACT(plan, r'"date_of_approach"\s*:\s*"(.*?)"')) AS date_of_approach,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"number_of_people_in_condition"\s*:\s*(\d+)') AS INT64) AS number_of_people_in_condition,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"critical"\s*:\s*(true|false)') AS BOOLEAN) AS critical,
    DATE(REGEXP_EXTRACT(plan, r'"init_date"\s*:\s*"(.*?)"')) AS init_date,
    DATE(REGEXP_EXTRACT(plan, r'"end_date"\s*:\s*"(.*?)"')) AS end_date,
    DATE(REGEXP_EXTRACT(plan, r'"reprogram_date"\s*:\s*"(.*?)"')) AS reprogram_date,
    REGEXP_EXTRACT(plan, r'"action"\s*:\s*"(.*?)"') AS action,
    REGEXP_EXTRACT(plan, r'"observation"\s*:\s*"(.*?)"') AS observation,
    REGEXP_EXTRACT(plan, r'"file"\s*:\s*"(.*?)"') AS file,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"finished"\s*:\s*(true|false)') AS BOOLEAN) AS finished,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"unity"\s*:\s*(\d+)') AS INT64) AS unity,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"administration"\s*:\s*(\d+)') AS INT64) AS administration,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"sector"\s*:\s*(\d+)') AS INT64) AS sector,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"aspect"\s*:\s*(\d+)') AS INT64) AS aspect,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"situation"\s*:\s*(\d+)') AS INT64) AS situation,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"responsible"\s*:\s*(\d+)') AS STRING) AS responsible,
    SAFE_CAST(REGEXP_EXTRACT(plan, r'"status"\s*:\s*(\d+)') AS INT64) AS status,
    CURRENT_TIMESTAMP() AS timestamp 
FROM `raw_terranova.terranova`,
    UNNEST(JSON_EXTRACT_ARRAY(REGEXP_REPLACE(data, r'^.*?rota/note:\s*', ''), '$.action_plan')) AS plan
WHERE data LIKE '%rota/note:%';
