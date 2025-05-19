# 🔍 Observabilidade com Kubernetes, Prometheus, Grafana e CloudWatch

Este repositório contém uma estrutura completa para monitoramento de aplicações em Kubernetes usando Prometheus, Grafana e integração com AWS CloudWatch.

## 📁 Estrutura do Projeto

```
observabilidade-k8s/
├── app/                  # Aplicativo de exemplo (ex: API ou scraper)
├── dashboards/           # JSONs dos dashboards do Grafana
├── docs/                 # Documentação adicional
├── helm-charts/          # (opcional) Charts Helm customizados
├── manifests/            # Manifests Kubernetes para Prometheus, Grafana, etc.
│   ├── grafana/
│   └── prometheus/
├── scripts/              # Scripts utilitários (port-forward, apply-all)
├── .gitignore
└── README.md
```

---

## 🚀 Como iniciar

### 1. Pré-requisitos

- Kubernetes (Minikube, KIND ou EKS)
- `kubectl` instalado
- Git Bash ou WSL no Windows
- (Opcional) `helm` instalado

### 2. Aplicar os manifests

```bash
kubectl apply -f manifests/prometheus/
kubectl apply -f manifests/grafana/
```

### 3. Redirecionar portas para acesso local

```bash
./scripts/port-forward.sh
```

Acesse:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

Login padrão do Grafana:
- **usuário:** `admin`
- **senha:** `admin`

---

## ☁️ Integração com CloudWatch (opcional)

Você pode configurar o `CloudWatch Agent` e enviar métricas/logs da aplicação para a AWS. Ideal para produção.

---

## 📊 Dashboards

- Dashboards customizados devem ser salvos em `dashboards/` e importados no Grafana.
- Recomendado usar [Grafana Cloud](https://grafana.com/products/cloud/) para backups e alertas.

---

## 📌 Observações

- Este projeto é voltado para aprendizado, testes e POCs.
- Para produção, recomenda-se configurar namespaces, RBAC e usar charts Helm oficiais.

---

## 🙌 Autor

Projeto criado por [Marco](https://www.linkedin.com/in/seu-perfil/) como parte de um laboratório de observabilidade com AWS e Kubernetes.
# Observabilidade com Kubernetes, Prometheus, Grafana e CloudWatch 

==============
# Observabilidade com Kubernetes, Prometheus, Grafana e CloudWatch

Este projeto configura um laboratório local com Minikube para observabilidade de aplicações usando:

- ✅ Kubernetes (Minikube)
- ✅ Prometheus (coleta de métricas)
- ✅ Grafana (visualização de dashboards)
- ✅ CloudWatch (como extensão futura)
- ✅ App Python simples (`http.server`)

---

## 🗂️ Estrutura do projeto

```
observabilidade-k8s/
├── manifests/
│   ├── app/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── grafana/
│   │   ├── grafana-deployment.yaml
│   │   ├── grafana-service.yaml
│   │   ├── grafana-datasource-configmap.yaml
│   │   └── grafana-dashboards-configmap.yaml
│   ├── prometheus/
│   │   ├── prometheus-config.yaml
│   │   ├── prometheus-deployment.yaml
│   │   └── prometheus-service.yaml
├── scripts/
│   ├── deploy-all.sh
│   ├── delete-all.sh
│   └── status.sh
└── README.md
```

---

## 🚀 Como usar

### 1. Inicie o Minikube

```bash
minikube start --driver=docker
```

### 2. Acesse a pasta do projeto

```bash
cd /d/observabilidade-k8s/scripts
```

### 3. Execute o deploy completo

```bash
./deploy-all.sh
```

### 4. Verifique o status dos pods e serviços

```bash
./status.sh
```

---

## 📊 Acessos locais

> Use o port-forward para acessar Grafana e Prometheus no navegador:

### Grafana

```bash
kubectl port-forward svc/grafana 3000:80
```

Acesse: [http://localhost:3000](http://localhost:3000)  
Login padrão: `admin / admin`

### Prometheus

```bash
kubectl port-forward svc/prometheus-server 9090:9090
```

Acesse: [http://localhost:9090](http://localhost:9090)

---

## 🧹 Para remover tudo

```bash
./delete-all.sh
```

---

## ✍️ Autor

Projeto desenvolvido por Marco Giovannini como laboratório de observabilidade em nuvem.

