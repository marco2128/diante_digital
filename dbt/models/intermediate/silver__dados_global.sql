-- models/silver__dados_global.sql
with bronze as (
    select * from {{ ref('bronze__dados_global') }}
)

select
    cast(tipo as string) as tipo,
    cast(cenario as string) as cenario,
    cast(trimestre as string) as trimestre,
    cast(ano as int) as ano,
    cast(preco as float64) as preco
from bronze
