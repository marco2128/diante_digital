SELECT
    tipo,
    cenario,
    trimestre,
    ano,
    preco,
    data_base
FROM {{ source('public', 'dados_global') }}
