INSERT INTO `bronze_terranova.tasks_un` (
    id, tarefa, data_inicio, data_fim, data_reprogramado, evidencia, observacao, responsavel, new_responsible, origem, status, timestamp
)
SELECT
    CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
    REGEXP_REPLACE(REGEXP_EXTRACT(data, r'"tarefa":\s*"([^"]+)"'), r'\\r\\n|\\n|\\r', ' ') AS tarefa,  -- Remover quebras de linha
    DATE(REGEXP_EXTRACT(data, r'"data_inicio":\s*"([^"]+)"')) AS data_inicio,
    DATE(REGEXP_EXTRACT(data, r'"data_fim":\s*"([^"]+)"')) AS data_fim,
    SAFE.PARSE_DATE('%Y-%m-%d', REGEXP_EXTRACT(data, r'"data_reprogramado":\s*"([^"]*)')) AS data_reprogramado,
    REGEXP_REPLACE(REGEXP_EXTRACT(data, r'"evidencia":\s*"([^"]*)"'), r'\\r\\n|\\n|\\r', ' ') AS evidencia,  -- Remover quebras de linha
    REGEXP_REPLACE(REGEXP_EXTRACT(data, r'"observacao":\s*"([^"]+)"'), r'\\r\\n|\\n|\\r', ' ') AS observacao,  -- Remover quebras de linha
    REGEXP_EXTRACT(data, r'"responsavel":\s*"([^"]+)"') AS responsavel,
    REGEXP_EXTRACT(data, r'"new_responsible":\s*"([^"]+)"') AS new_responsible,
    CAST(REGEXP_EXTRACT(data, r'"origem":\s*(\d+)') AS INT64) AS origem,
    CAST(REGEXP_EXTRACT(data, r'"status":\s*(\d+)') AS INT64) AS status,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `raw_terranova.terranova`
WHERE
    REGEXP_CONTAINS(data, r'rota/tasks_un:');
