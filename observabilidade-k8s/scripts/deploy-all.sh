#!/bin/bash

echo "📦 Aplicando ConfigMaps do Grafana..."
kubectl apply -f ../manifests/grafana/grafana-datasource-configmap.yaml
kubectl apply -f ../manifests/grafana/grafana-dashboards-configmap.yaml

echo "🚀 Deploy do Grafana..."
kubectl apply -f ../manifests/grafana/grafana-deployment.yaml
kubectl apply -f ../manifests/grafana/grafana-service.yaml

echo "📦 Aplicando ConfigMap do Prometheus..."
kubectl apply -f ../manifests/prometheus/prometheus-config.yaml

echo "🚀 Deploy do Prometheus..."
kubectl apply -f ../manifests/prometheus/prometheus-deployment.yaml
kubectl apply -f ../manifests/prometheus/prometheus-service.yaml

echo "🚀 Deploy do app de exemplo..."
kubectl apply -f ../manifests/app/deployment.yaml
kubectl apply -f ../manifests/app/service.yaml

echo "✅ Todos os componentes foram aplicados!"
