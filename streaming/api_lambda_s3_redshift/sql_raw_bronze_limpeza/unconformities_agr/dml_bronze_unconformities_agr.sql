INSERT INTO `bronze_terranova.unconformities_agr` (
    id,
    active,
    created_at,
    updated_at,
    date,
    what,
    observation,
    id_header,
    user,
    unity,
    macroprocess,
    proccess,
    subarea,
    pilar,
    aspect,
    route,
    subroute,
    id_question,
    equipment,
    task,
    timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    -- Extraindo somente a data de created_at
    SUBSTR(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"'), 1, 10) AS created_at,
    -- Extraindo somente a data de updated_at
    SUBSTR(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"'), 1, 10) AS updated_at,
    REGEXP_EXTRACT(data, r'"date":\s*"([^"]+)"') AS date,
    REGEXP_EXTRACT(data, r'"what":\s*"([^"]+)"') AS what,
    REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"') AS observation,
    REGEXP_EXTRACT(data, r'"id_header":\s*"([^"]+)"') AS id_header,
    CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CAST(REGEXP_EXTRACT(data, r'"macroprocess":\s*(\d+)') AS INT64) AS macroprocess,
    CAST(REGEXP_EXTRACT(data, r'"proccess":\s*(\d+)') AS INT64) AS proccess,
    CAST(REGEXP_EXTRACT(data, r'"subarea":\s*(\d+)') AS INT64) AS subarea,
    CAST(REGEXP_EXTRACT(data, r'"pilar":\s*(\d+)') AS INT64) AS pilar,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*(\d+)') AS INT64) AS aspect,
    CAST(REGEXP_EXTRACT(data, r'"route":\s*(\d+)') AS INT64) AS route,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*(\d+)') AS INT64) AS subroute,
    REGEXP_EXTRACT(data, r'"id_question":\s*"([^"]+)"') AS id_question,
    REGEXP_EXTRACT(data, r'"equipment":\s*"([^"]*)"') AS equipment,
    -- Corrigindo o campo task para extrair uma lista de strings
    REGEXP_EXTRACT_ALL(data, r'"task":\s*\[([^\]]*)\]') AS task,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/unconformities_agr:');
