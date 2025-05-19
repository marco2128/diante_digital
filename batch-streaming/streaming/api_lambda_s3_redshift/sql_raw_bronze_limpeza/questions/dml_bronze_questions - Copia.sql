-- Inserir na tabela questions_aspect
INSERT INTO `bronze_terranova.questions_aspect` (
    question_id,
    aspect_id,
    aspecto,
    equipament,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.aspect.id') AS INT64) AS aspect_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.aspect.aspecto') AS aspecto,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.aspect.equipament') AS BOOL) AS equipament,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.aspect.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_route
INSERT INTO `bronze_terranova.questions_route` (
    question_id,
    route_id,
    rota,
    description,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.route.id') AS INT64) AS route_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.route.rota') AS rota,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.route.description') AS description,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.route.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_subroute
INSERT INTO `bronze_terranova.questions_subroute` (
    question_id,
    subroute_id,
    passo,
    subrota,
    active,
    rota,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.subroute.id') AS INT64) AS subroute_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.subroute.passo') AS INT64) AS passo,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.subroute.subrota') AS subrota,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.subroute.active') AS BOOL) AS active,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.subroute.rota') AS INT64) AS rota,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_checklist
INSERT INTO `bronze_terranova.questions_checklist` (
    question_id,
    checklist_id,
    checklist,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.checklist.id') AS INT64) AS checklist_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.checklist.checklist') AS checklist,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.checklist.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_criticality
INSERT INTO `bronze_terranova.questions_criticality` (
    question_id,
    criticality_id,
    criticidade,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.criticality.id') AS INT64) AS criticality_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.criticality.criticidade') AS criticidade,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.criticality.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_pilar
INSERT INTO `bronze_terranova.questions_pilar` (
    question_id,
    pilar_id,
    pilar,
    active,
    ordered,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.pilar.id') AS INT64) AS pilar_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.pilar.pilar') AS pilar,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.pilar.active') AS BOOL) AS active,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.pilar.order') AS INT64) AS ordered,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_unity
INSERT INTO `bronze_terranova.questions_unity` (
    question_id,
    unity_id,
    sigla,
    unidade,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    SAFE_CAST(JSON_EXTRACT_SCALAR(unit, '$.id') AS INT64) AS unity_id,
    JSON_EXTRACT_SCALAR(unit, '$.sigla') AS sigla,
    JSON_EXTRACT_SCALAR(unit, '$.unidade') AS unidade,
    SAFE_CAST(JSON_EXTRACT_SCALAR(unit, '$.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`,
    UNNEST(JSON_EXTRACT_ARRAY(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.unity')) AS unit
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');

-- Inserir na tabela questions_main
INSERT INTO `bronze_terranova.questions_main` (
    question_id,
    question,
    origin,
    evidence,
    active,
    timestamp
)
SELECT
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.id') AS question_id,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.question') AS question,
    JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.origin') AS origin,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.evidence') AS BOOL) AS evidence,
    SAFE_CAST(JSON_EXTRACT_SCALAR(REGEXP_REPLACE(data, r'^.*rota/questions:\s*', ''), '$.active') AS BOOL) AS active,
    CURRENT_TIMESTAMP() AS timestamp
FROM 
    `raw_terranova.terranova`
WHERE 
    REGEXP_CONTAINS(data, r'rota/questions:');
