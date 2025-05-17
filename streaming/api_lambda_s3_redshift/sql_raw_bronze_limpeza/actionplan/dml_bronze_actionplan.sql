INSERT INTO `bronze_terranova.actionplan` (
    id, active, created_at, updated_at, date_of_approach, number_of_people_in_condition, 
    critical, init_date, end_date, reprogram_date, action, observation, file, 
    finished, header_approach_stop, unity, administration, sector, aspect, 
    situation, responsible, status, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    CAST(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"') AS TIMESTAMP) AS created_at,
    CAST(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"') AS TIMESTAMP) AS updated_at,
    CAST(REGEXP_EXTRACT(data, r'"date_of_approach":\s*"([^"]+)"') AS DATE) AS date_of_approach,
    CAST(REGEXP_EXTRACT(data, r'"number_of_people_in_condition":\s*(\d+)') AS INT64) AS number_of_people_in_condition,
    CAST(REGEXP_EXTRACT(data, r'"critical":\s*(true|false)') AS BOOL) AS critical,
    CAST(REGEXP_EXTRACT(data, r'"init_date":\s*"([^"]+)"') AS DATE) AS init_date,
    CAST(REGEXP_EXTRACT(data, r'"end_date":\s*"([^"]+)"') AS DATE) AS end_date,
    CAST(REGEXP_EXTRACT(data, r'"reprogram_date":\s*"([^"]+)"') AS DATE) AS reprogram_date,
    REGEXP_EXTRACT(data, r'"action":\s*"([^"]*)"') AS action,
    REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"') AS observation,
    REGEXP_EXTRACT(data, r'"file":\s*"([^"]*)"') AS file,
    CAST(REGEXP_EXTRACT(data, r'"finished":\s*(true|false)') AS BOOL) AS finished,
    REGEXP_EXTRACT(data, r'"header_approach_stop":\s*"([^"]+)"') AS header_approach_stop,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CAST(REGEXP_EXTRACT(data, r'"administration":\s*(\d+)') AS INT64) AS administration,
    CAST(REGEXP_EXTRACT(data, r'"sector":\s*(\d+)') AS INT64) AS sector,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*(\d+)') AS INT64) AS aspect,
    CAST(REGEXP_EXTRACT(data, r'"situation":\s*(\d+)') AS INT64) AS situation,
    REGEXP_EXTRACT(data, r'"responsible":\s*"([^"]*)"') AS responsible,
    CAST(REGEXP_EXTRACT(data, r'"status":\s*(\d+)') AS INT64) AS status,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/actionplan:');
