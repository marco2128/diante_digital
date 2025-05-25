#!/bin/bash

# === Atualiza pacotes e instala dependências ===
sudo yum update -y
sudo yum install -y git python3

# === Cria e ativa ambiente virtual ===
python3 -m venv ~/dbt_venv
source ~/dbt_venv/bin/activate

# === Atualiza pip e instala dbt-redshift ===
pip install --upgrade pip
pip install dbt-redshift

# === Cria diretório de configuração do dbt ===
mkdir -p ~/.dbt

# === Cria arquivo profiles.yml ===
cat <<EOF > ~/.dbt/profiles.yml
redshift_lab:
  target: dev
  outputs:
    dev:
      type: redshift
      method: iam
      cluster_id: redshift-serverless-workgroup-c35xsydpp79xnt
      host: redshift-serverless-workgroup-c35xsydpp79xnt.190440599924.us-east-2.redshift-serverless.amazonaws.com
      user: marco001
      database: dev
      schema: public
      region: us-east-2
      threads: 4
      sslmode: prefer
EOF

# === Final ===
echo ""
echo "✅ Ambiente dbt com Redshift configurado!"
echo "Ative o ambiente com: source ~/dbt_venv/bin/activate"
echo "Execute comandos dbt normalmente: dbt debug, dbt run, etc."
