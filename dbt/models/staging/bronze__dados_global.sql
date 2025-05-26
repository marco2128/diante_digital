-- models/bronze__dados_global.sql
with raw as (
    select * from {{ source('raw_data', 'dados_global') }}
)

select
    tipo,
    cenario,
    trimestre,
    ano,
    preco
from raw
where ano is not null and preco is not null
