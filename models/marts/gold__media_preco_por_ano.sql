-- models/gold__media_preco_por_ano.sql
with silver as (
    select * from {{ ref('silver__dados_global') }}
)

select
    ano,
    round(avg(preco), 2) as media_preco
from silver
group by ano
order by ano
