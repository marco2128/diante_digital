-- Inserção na tabela goodday_attendance_att
INSERT INTO `bronze_terranova.goodday_attendance_att` (
    id, date, hour, created_at, updated_at, user, unity, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    DATE(REGEXP_EXTRACT(data, r'"date":\s*"([^"]+)"')) AS date,
    PARSE_TIME('%H:%M:%S', REGEXP_EXTRACT(data, r'"hour":\s*"([^"]+)"')) AS hour,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/goodday_attendance:');


-- Inserção na tabela goodday_attendance_areas
INSERT INTO `bronze_terranova.goodday_attendance_areas` (
    att_id, area_id, name, description, active, created_at, updated_at, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS att_id, -- Referência ao `id` da tabela `goodday_att`
    CAST(REGEXP_EXTRACT(area_item, r'"id":\s*(\d+)') AS INT64) AS area_id,
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_EXTRACT(area_item, r'"name":\s*"([^"]+)"'),
                    r'\\u00e1', 'á'
                ),
                r'\\u00e9', 'é'
            ),
            r'\\u00ed', 'í'
        ),
        r'\\u00e7', 'ç'
    ) AS name,
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_EXTRACT(area_item, r'"description":\s*"([^"]+)"'),
                    r'\\u00e1', 'á'
                ),
                r'\\u00e9', 'é'
            ),
            r'\\u00ed', 'í'
        ),
        r'\\u00e7', 'ç'
    ) AS description,
    CAST(REGEXP_EXTRACT(area_item, r'"active":\s*(true|false)') AS BOOLEAN) AS active,
    TIMESTAMP(REGEXP_EXTRACT(area_item, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(area_item, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`,
    UNNEST(REGEXP_EXTRACT_ALL(data, r'(\{[^}]*\})')) AS area_item
WHERE
    REGEXP_CONTAINS(data, r'rota/goodday_attendance:');
