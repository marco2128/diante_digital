# Projeto dbt - Redshift Serverless

Este projeto utiliza o [dbt (Data Build Tool)](https://www.getdbt.com/) com o Amazon Redshift Serverless.

## Estrutura

- `models/`: modelos SQL com materializações (`view`, `table`, etc)
  - `staging/`: camadas de staging
  - `marts/`: tabelas finais de negócio (fatos e dimensões)
- `macros/`: macros customizadas
- `snapshots/`: snapshots de controle de alterações
- `tests/`: testes customizados
- `seeds/`: arquivos `.csv` de carga inicial

## Comandos úteis

```bash
dbt run                 # Executa os modelos
dbt test                # Executa os testes definidos
dbt docs generate       # Gera a documentação
dbt docs serve          # Inicia a visualização da doc
