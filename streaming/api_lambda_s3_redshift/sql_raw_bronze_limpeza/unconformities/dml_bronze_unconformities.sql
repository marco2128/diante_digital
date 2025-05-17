INSERT INTO `bronze_terranova.unconformities` (
    id, data, what, observation, active, unidade, macroprocesso, processo, 
    subarea, pilar, aspecto, rota, subrota, idpergunta, origem, user, tarefa, timestamp
)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*(\d+)') AS INT64) AS id,
  CAST(REGEXP_EXTRACT(data, r'"data":\s*"([^"]*)"') AS DATE) AS data,
  REGEXP_EXTRACT(data, r'"what":\s*"([^"]*)"') AS what,
  REGEXP_EXTRACT(data, r'"observation":\s*"([^"]*)"') AS observation,
  CAST(REGEXP_EXTRACT(data, r'"active":\s*(true|false)') AS BOOL) AS active,
  CAST(REGEXP_EXTRACT(data, r'"unidade":\s*(\d+)') AS INT64) AS unidade,
  CAST(REGEXP_EXTRACT(data, r'"macroprocesso":\s*(\d+)') AS INT64) AS macroprocesso,
  CAST(REGEXP_EXTRACT(data, r'"processo":\s*(\d+)') AS INT64) AS processo,
  CAST(REGEXP_EXTRACT(data, r'"subarea":\s*(\d+)') AS INT64) AS subarea,
  CAST(REGEXP_EXTRACT(data, r'"pilar":\s*(\d+)') AS INT64) AS pilar,
  CAST(REGEXP_EXTRACT(data, r'"aspecto":\s*(\d+)') AS INT64) AS aspecto,
  CAST(REGEXP_EXTRACT(data, r'"rota":\s*(\d+)') AS INT64) AS rota,
  CAST(REGEXP_EXTRACT(data, r'"subrota":\s*(\d+)') AS INT64) AS subrota,
  REGEXP_EXTRACT(data, r'"idpergunta":\s*"([^"]*)"') AS idpergunta,
  CAST(REGEXP_EXTRACT(data, r'"origem":\s*(\d+)') AS INT64) AS origem,
  CAST(REGEXP_EXTRACT(data, r'"user":\s*(\d+)') AS INT64) AS user,

  -- Extrai, concatena e converte a tarefa para INT64
  SAFE_CAST(REGEXP_REPLACE(REGEXP_EXTRACT(data, r'"tarefa":\s*\[([^\]]*)\]'), r'[\s",]', '') AS INT64) AS tarefa,

  CURRENT_TIMESTAMP() AS timestamp
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/unconformities:');
