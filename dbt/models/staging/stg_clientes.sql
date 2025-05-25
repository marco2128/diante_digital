-- models/staging/stg_clientes.sql

with fonte as (
    select
        id_cliente,
        nome
    from {{ source('raw', 'raw_clientes') }}
)

select * from fonte
