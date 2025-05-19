INSERT INTO `bronze_terranova.checklists` (
  id,
  checklist,
  active,
  timestamp
)
SELECT 
  CAST(REGEXP_EXTRACT(data, r'"id":\s*"?(\d+)"?') AS INT64) AS id_extracted,  -- Convertendo para INT64
  REGEXP_EXTRACT(data, r'"checklist":\s*"([^"]+)"') AS checklist_extracted,
  CASE
    WHEN TRIM(REGEXP_EXTRACT(data, r'"active":\s*(true|false)')) = 'true' THEN TRUE
    WHEN TRIM(REGEXP_EXTRACT(data, r'"active":\s*(true|false)')) = 'false' THEN FALSE
    ELSE NULL
  END AS active,
  CURRENT_TIMESTAMP() AS timestamp  
FROM 
  `raw_terranova.terranova`
WHERE 
  REGEXP_CONTAINS(data, r'rota/checklists:');
