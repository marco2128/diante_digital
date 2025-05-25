
{{ config(materialized='table') }}

SELECT
  cliente_id,
  nome_cliente,
  email,
  data_nascimento,
  genero,
  cliente_ativo,
  CURRENT_DATE - data_nascimento AS idade_dias
FROM {{ ref('stg_clientes') }}
