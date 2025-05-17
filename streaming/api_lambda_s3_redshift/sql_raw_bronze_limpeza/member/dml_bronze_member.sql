INSERT INTO `bronze_terranova.member` (
    cpf_display, name, email, unity, description_unity, id_office, office,
    board, axle, id_leader, leader, is_leader, timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"cpf_display":\s*"([^"]+)"') AS cpf_display,
    REGEXP_EXTRACT(data, r'"name":\s*"([^"]+)"') AS name,
    REGEXP_EXTRACT(data, r'"email":\s*"([^"]+)"') AS email,
    CAST(REGEXP_EXTRACT(data, r'"unity":\s*(\d+)') AS INT64) AS unity,
    REGEXP_EXTRACT(data, r'"description_unity":\s*"([^"]+)"') AS description_unity,
    CAST(REGEXP_EXTRACT(data, r'"id_office":\s*(\d+)') AS INT64) AS id_office,
    REGEXP_EXTRACT(data, r'"office":\s*"([^"]+)"') AS office,
    REGEXP_EXTRACT(data, r'"board":\s*"([^"]+)"') AS board,
    REGEXP_EXTRACT(data, r'"axle":\s*"([^"]+)"') AS axle,
    CAST(REGEXP_EXTRACT(data, r'"id_leader":\s*(\d+)') AS INT64) AS id_leader,
    REGEXP_EXTRACT(data, r'"leader":\s*"([^"]+)"') AS leader,
    CAST(REGEXP_EXTRACT(data, r'"is_leader":\s*(true|false)') AS BOOL) AS is_leader,
    CURRENT_TIMESTAMP() AS timestamp 
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/member:');
