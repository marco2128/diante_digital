INSERT INTO `bronze_terranova.note_agr` (
    id, active, created_at, updated_at, date, front_of_service, user, unity, macroproccess, proccess, subarea, route, subroute, shift, farm, timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"([^"]+)"') AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"date":\s*"([^"]+)"')) AS date,
    CAST(REGEXP_EXTRACT(data, r'"front_of_service":\s*(\d+)') AS INT64) AS front_of_service,
    CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CAST(REGEXP_EXTRACT(data, r'"macroproccess":\s*(\d+)') AS INT64) AS macroproccess,
    CAST(REGEXP_EXTRACT(data, r'"proccess":\s*(\d+)') AS INT64) AS proccess,
    CAST(REGEXP_EXTRACT(data, r'"subarea":\s*(\d+)') AS INT64) AS subarea,
    CAST(REGEXP_EXTRACT(data, r'"route":\s*(\d+)') AS INT64) AS route,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*(\d+)') AS INT64) AS subroute,
    CAST(REGEXP_EXTRACT(data, r'"shift":\s*(\d+)') AS INT64) AS shift,
    REGEXP_EXTRACT(data, r'"farm":\s*"([^"]+)"') AS farm,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/note_agr:');
