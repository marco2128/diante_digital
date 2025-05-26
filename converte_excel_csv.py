import pandas as pd

# Lê o Excel
df = pd.read_excel('dados_global_202308.xlsx')

# Exporta como CSV
df.to_csv('dados_global_202308.csv', index=False)
