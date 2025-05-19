CREATE TEMP TABLE temp_result AS
SELECT
    qm.question_id,
    qm.question,
    qm.origin,
    qm.evidence,
    qm.active AS main_active,
    CURRENT_TIMESTAMP() AS timestamp,
    qa.aspect_id,
    qa.aspecto,
    qa.equipament,
    qa.active AS aspect_active,
    qr.route_id,
    qr.rota,
    qr.description AS route_description,
    qr.active AS route_active,
    qsr.subroute_id,
    qsr.passo,
    qsr.subrota,
    qsr.active AS subroute_active,
    qsr.rota AS subroute_rota,
    qc.checklist_id,
    qc.checklist,
    qc.active AS checklist_active,
    qcr.criticality_id,
    qcr.criticidade,
    qcr.active AS criticality_active,
    qp.pilar_id,
    qp.pilar,
    qp.active AS pilar_active,
    qp.ordered AS pilar_ordered,
    qu.unity_id,
    qu.sigla,
    qu.unidade,
    qu.active AS unity_active
FROM
    `bronze_terranova.questions_main` qm
LEFT JOIN
    `bronze_terranova.questions_aspect` qa
ON
    qm.question_id = qa.question_id
LEFT JOIN
    `bronze_terranova.questions_route` qr
ON
    qm.question_id = qr.question_id
LEFT JOIN
    `bronze_terranova.questions_subroute` qsr
ON
    qm.question_id = qsr.question_id
LEFT JOIN
    `bronze_terranova.questions_checklist` qc
ON
    qm.question_id = qc.question_id
LEFT JOIN
    `bronze_terranova.questions_criticality` qcr
ON
    qm.question_id = qcr.question_id
LEFT JOIN
    `bronze_terranova.questions_pilar` qp
ON
    qm.question_id = qp.question_id
LEFT JOIN
    `bronze_terranova.questions_unity` qu
ON
    qm.question_id = qu.question_id;

-- Agora insira na tabela final
INSERT INTO `silver_terranova.questions` (
    question_id,
    question,
    origin,
    evidence,
    active,
    timestamp,
    aspect_id,
    aspecto,
    equipament,
    aspect_active,
    route_id,
    rota,
    route_description,
    route_active,
    subroute_id,
    passo,
    subrota,
    subroute_active,
    subroute_rota,
    checklist_id,
    checklist,
    checklist_active,
    criticality_id,
    criticidade,
    criticality_active,
    pilar_id,
    pilar,
    pilar_active,
    pilar_ordered,
    unity_id,
    sigla,
    unidade,
    unity_active
)
SELECT
    question_id,
    question,
    origin,
    evidence,
    main_active AS active,
    timestamp,
    aspect_id,
    aspecto,
    equipament,
    aspect_active,
    route_id,
    rota,
    route_description,
    route_active,
    subroute_id,
    passo,
    subrota,
    subroute_active,
    subroute_rota,
    checklist_id,
    checklist,
    checklist_active,
    criticality_id,
    criticidade,
    criticality_active,
    pilar_id,
    pilar,
    pilar_active,
    pilar_ordered,
    unity_id,
    sigla,
    unidade,
    unity_active
FROM temp_result;
