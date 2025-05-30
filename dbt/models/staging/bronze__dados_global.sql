-- models/staging/bronze__dados_global.sql

with raw_data_cte as (
    select * from {{ source('raw_data', 'dados_global') }}
)

select
    tipo,
    cenario,
    trimestre,
    ano,
    preco
from raw_data_cte
where ano is not null and preco is not null
