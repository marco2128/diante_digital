WITH normalized_member AS (
  SELECT
    SAFE_CAST(REGEXP_REPLACE(cpf_display, r'[^0-9]', '') AS STRING) AS cpf,
    LOWER(TRIM(REGEXP_REPLACE(name, r'[^\w\s]', ''))) AS normalized_name_member,
    email AS email_member
  FROM
    `dl-bq-prd.bronze_terranova.member`
),
normalized_user AS (
  SELECT
    cpf AS cpf_user,
    LOWER(TRIM(REGEXP_REPLACE(username, r'[^\w\s]', ''))) AS normalized_name_user,
    email AS email_user
  FROM
    `dl-bq-prd.bronze_terranova.user`
)
SELECT
  nu.cpf_user,
  nm.cpf AS cpf_member,
  nu.email_user,
  nm.email_member,
  nu.normalized_name_user,
  nm.normalized_name_member
FROM
  normalized_users nu
LEFT JOIN
  normalized_member nm
ON
  nu.normalized_name_user = nm.normalized_name_member
