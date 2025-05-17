-- Passo 1: Inserção dos registros que possuem files
INSERT INTO `silver_terranova.tasks_un` (
    id, tarefa, data_inicio, data_fim, data_reprogramado, evidencia, observacao, 
    responsavel, new_responsible, origem, status, files, timestamp
)
SELECT
    t.id AS task_id,
    t.tarefa,
    t.data_inicio,
    t.data_fim,
    t.data_reprogramado,
    t.evidencia,
    t.observacao,
    t.responsavel,
    t.new_responsible,
    t.origem,
    t.status,
    i.files,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `bronze_terranova.unconformities` u
LEFT JOIN
    `bronze_terranova.indleaderroutevalue` i
ON
    u.idpergunta = i.question
LEFT JOIN
    `bronze_terranova.tasks_un` t
ON
    SAFE_CAST(u.tarefa AS INT64) = t.id
WHERE
    i.files IS NOT NULL;

-- Passo 2: Remoção de registros com `id` nulo
DELETE FROM `silver_terranova.tasks_un`
WHERE id IS NULL;

-- Passo 3: Remoção de registros duplicados mantendo o mais recente
DELETE FROM `silver_terranova.tasks_un`
WHERE id IN (
    SELECT id
    FROM `silver_terranova.tasks_un`
    GROUP BY id
    HAVING COUNT(*) > 1
);

-- Passo 4: Inserção dos registros que ainda não existem no silver
INSERT INTO `silver_terranova.tasks_un` (
    id, tarefa, data_inicio, data_fim, data_reprogramado, evidencia, observacao, 
    responsavel, new_responsible, origem, status, files, timestamp
)
SELECT
    b.id,
    b.tarefa,
    b.data_inicio,
    b.data_fim,
    b.data_reprogramado,
    b.evidencia,
    b.observacao,
    b.responsavel,
    b.new_responsible,
    b.origem,
    b.status,
    NULL AS files,  -- Ajuste aqui caso precise preencher essa coluna com dados de outra tabela
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `bronze_terranova.tasks_un` b
LEFT JOIN
    `silver_terranova.tasks_un` s
ON
    b.id = s.id
WHERE
    s.id IS NULL;
