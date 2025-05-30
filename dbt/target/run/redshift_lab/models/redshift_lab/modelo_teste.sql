

  create view "dev"."public_public"."modelo_teste__dbt_tmp" as (
    select
  current_date as data_atual,
  current_user as usuario_logado
  ) ;
