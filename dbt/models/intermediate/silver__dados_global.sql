with bronze_data as (
    select * from {{ ref('bronze__dados_global') }}
)

select
    cast(tipo as varchar) as tipo,
    cast(cenario as varchar) as cenario,
    cast(trimestre as varchar) as trimestre,
    cast(ano as int) as ano,
    cast(preco as float) as preco
from bronze_data
