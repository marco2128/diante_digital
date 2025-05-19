#!/bin/bash

echo "🔁 Redirecionando porta do Grafana (localhost:3000) e Prometheus (localhost:9090)..."

# Redirecionar Grafana
kubectl port-forward svc/grafana 3000:80 -n default &

# Redirecionar Prometheus
kubectl port-forward svc/prometheus-server 9090:9090 -n default &

echo "✅ Acesse Grafana: http://localhost:3000"
echo "✅ Acesse Prometheus: http://localhost:9090"
echo "Pressione Ctrl+C para parar o redirecionamento."

# Manter o script vivo
wait
