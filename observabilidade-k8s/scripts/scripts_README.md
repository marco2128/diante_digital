# 📂 Pasta: scripts/

Este diretório contém scripts auxiliares para gerenciar os recursos de observabilidade no cluster Kubernetes local.

---

## ▶️ deploy-all.sh

Aplica todos os componentes do projeto, incluindo:

- ConfigMaps do Grafana
- Deployments e Services do Grafana
- ConfigMap do Prometheus
- Deployments e Services do Prometheus
- App de exemplo Python (`http.server`)

**Uso:**

```bash
./deploy-all.sh
```

---

## 🧹 delete-all.sh

Remove todos os recursos aplicados no cluster.

**Uso:**

```bash
./delete-all.sh
```

---

## 📊 status.sh

Mostra o status atual do cluster, listando:

- Pods
- Services
- Deployments
- ConfigMaps

**Uso:**

```bash
./status.sh
```

---

## 💡 Observação

Execute esses scripts dentro da pasta `/scripts` ou use caminhos relativos corretamente se estiver fora dela.

---

## ✍️ Autor

Marco Giovannini
