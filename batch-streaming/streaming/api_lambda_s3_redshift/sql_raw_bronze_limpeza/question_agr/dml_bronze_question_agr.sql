INSERT INTO `bronze_terranova.questions_agr_aspect` (
    question_id,
    aspect_id,
    aspecto,
    equipament,
    active,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"id":\s*(\d+)') AS INT64) AS aspect_id,
    REGEXP_REPLACE(
        REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"aspecto":\s*"([^"]+)"'),
        r'\\u00eancia',
        'ência'
    ) AS aspecto,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"equipament":\s*(true|false)') AS BOOL) AS equipament,
    CAST(REGEXP_EXTRACT(data, r'"aspect":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');
 

-- Inserir na tabela questions_agr_route
INSERT INTO `bronze_terranova.questions_agr_route` (
    question_id,
    route_id,
    rota,
    description,
    active,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"route":\s*\{"id":\s*(\d+)') AS INT64) AS route_id,
    REGEXP_EXTRACT(data, r'"route":\s*\{"[^}]*"rota":\s*"([^"]+)"') AS rota,
    REGEXP_REPLACE(
        REGEXP_EXTRACT(data, r'"route":\s*\{"[^}]*"description":\s*"([^"]+)"'),
        r'\\u00eancia',
        'ência'
    ) AS description,
    CAST(REGEXP_EXTRACT(data, r'"route":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');

-- Inserir na tabela questions_agr_subroute
INSERT INTO `bronze_terranova.questions_agr_subroute` (
    question_id,
    subroute_id,
    passo,
    subrota,
    active,
    rota,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*\{"id":\s*(\d+)') AS INT64) AS subroute_id,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*\{"[^}]*"passo":\s*(\d+)') AS INT64) AS passo,
    REGEXP_EXTRACT(data, r'"subroute":\s*\{"[^}]*"subrota":\s*"([^"]+)"') AS subrota,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CAST(REGEXP_EXTRACT(data, r'"subroute":\s*\{"[^}]*"rota":\s*(\d+)') AS INT64) AS rota,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');

-- Inserir na tabela questions_agr_checklist
INSERT INTO `bronze_terranova.questions_agr_checklist` (
    question_id,
    checklist_id,
    checklist,
    active,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"checklist":\s*\{"id":\s*(\d+)') AS INT64) AS checklist_id,
    -- Substituições abrangentes para corrigir caracteres Unicode
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_EXTRACT(data, r'"checklist":\s*\{"[^}]*"checklist":\s*"([^"]+)"'),
                        r'\\u00e9',
                        'é'
                    ),
                    r'\\u00e7',
                    'ç'
                ),
                r'\\u00ed',
                'í'
            ),
            r'\\u00ea',
            'ê'
        ),
        r'\\u00e1',
        'á'
    ) AS checklist,
    CAST(REGEXP_EXTRACT(data, r'"checklist":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');


-- Inserir na tabela questions_agr_criticality
INSERT INTO `bronze_terranova.questions_agr_criticality` (
    question_id,
    criticality_id,
    criticidade,
    active,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"criticality":\s*\{"id":\s*(\d+)') AS INT64) AS criticality_id,
    REGEXP_REPLACE(
        REGEXP_EXTRACT(data, r'"criticality":\s*\{"[^}]*"criticidade":\s*"([^"]+)"'),
        r'\\u00ed',
        'í'
    ) AS criticidade,
    CAST(REGEXP_EXTRACT(data, r'"criticality":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');

-- Inserir na tabela questions_agr_pilar
INSERT INTO `bronze_terranova.questions_agr_pilar` (
    question_id,
    pilar_id,
    pilar,
    active,
    ordered,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(data, r'"pilar":\s*\{"id":\s*(\d+)') AS INT64) AS pilar_id,
    REGEXP_REPLACE(
        REGEXP_EXTRACT(data, r'"pilar":\s*\{"[^}]*"pilar":\s*"([^"]+)"'),
        r'\\u00e7a',
        'ça'
    ) AS pilar,
    CAST(REGEXP_EXTRACT(data, r'"pilar":\s*\{"[^}]*"active":\s*(true|false)') AS BOOL) AS active,
    CAST(REGEXP_EXTRACT(data, r'"pilar":\s*\{"[^}]*"order":\s*(\d+)') AS INT64) AS ordered,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');

-- Inserir na tabela questions_agr_unity
INSERT INTO `bronze_terranova.questions_agr_unity` (
    question_id,
    unity_id,
    sigla,
    unidade,
    active,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    CAST(REGEXP_EXTRACT(unity, r'"id":\s*(\d+)') AS INT64) AS unity_id,
    REGEXP_EXTRACT(unity, r'"sigla":\s*"([^"]+)"') AS sigla,
    REGEXP_REPLACE(
        REGEXP_EXTRACT(unity, r'"unidade":\s*"([^"]+)"'),
        r'\\u00e1gua',
        'água'
    ) AS unidade,
    CAST(REGEXP_EXTRACT(unity, r'"active":\s*(true|false)') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`,
    UNNEST(REGEXP_EXTRACT_ALL(data, r'\{"id":\s*\d+[^}]*\}')) AS unity
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');

-- Inserir na tabela questions_agr_main
INSERT INTO `bronze_terranova.questions_agr_main` (
    question_id,
    question,
    origin,
    evidence,
    active,
    created_at,
    updated_at,
    `order`,
    timestamp
)
SELECT
    REGEXP_EXTRACT(data, r'"id":\s*"(.*?)"') AS question_id,
    REGEXP_EXTRACT(data, r'"question":\s*"([^"]+)"') AS question,
    REGEXP_EXTRACT(data, r'"origin":\s*"([^"]+)"') AS origin,
    CAST(REGEXP_EXTRACT(data, r'"evidence":\s*(true|false)') AS BOOL) AS evidence,
    CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"created_at":\s*"([^"]+)"')) AS created_at,
    TIMESTAMP(REGEXP_EXTRACT(data, r'"updated_at":\s*"([^"]+)"')) AS updated_at,
    CAST(REGEXP_EXTRACT(data, r'"order":\s*(\d+)') AS INT64) AS `order`,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/question_agr:');
