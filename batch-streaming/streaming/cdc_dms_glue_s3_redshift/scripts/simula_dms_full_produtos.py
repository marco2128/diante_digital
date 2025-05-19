# Script para simular arquivos JSON gerados pelo AWS DMS para a tabela produtos_agricolas

import json
import os
from datetime import datetime
from random import choice, uniform

os.makedirs("simulados_dms/produtos_agricolas/full-load", exist_ok=True)

produtos = [
    ("Milho", "Cereal"),
    ("Soja", "Grão"),
    ("Café", "Bebida"),
    ("Algodão", "Fibra"),
    ("Feijão", "Leguminosa")
]
unidades_validas = ["kg", "ton", "g", "litro", ""]

registros = []
for i in range(1, 11):
    nome, tipo = choice(produtos)
    registro = {
        "id": i,
        "nome_produto": nome,
        "tipo_cultura": tipo,
        "preco_estimado": f"{round(uniform(1.0, 20.0), 2)}",
        "unidade_medida": choice(unidades_validas),
        "criado_em": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
    registros.append(json.dumps(registro))

# Salvar como arquivo simulado no formato que o DMS criaria
with open("simulados_dms/produtos_agricolas/full-load/part-00001.json", "w", encoding="utf-8") as f:
    for linha in registros:
        f.write(linha + "\n")
