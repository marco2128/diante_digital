{{ config(materialized='view') }}

SELECT
    tipo,
    cenario,
    trimestre,
    ano,
    preco
FROM
    raw_data.dados_global

