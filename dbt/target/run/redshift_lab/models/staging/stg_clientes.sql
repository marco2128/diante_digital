

  create view "dev"."public_public"."stg_clientes__dbt_tmp" as (
    -- models/staging/stg_clientes.sql

with fonte as (
    select
        id_cliente,
        nome
    from "dev"."public"."raw_clientes"
)

select * from fonte
  ) ;
