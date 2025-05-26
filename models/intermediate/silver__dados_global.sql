-- models/gold__media_preco_por_ano.sql
with silver_data_cte as (
    select * from {{ ref('silver__dados_global') }}
)

select
    ano,
    round(avg(preco), 2) as media_preco
from silver_data
group by ano
order by ano
