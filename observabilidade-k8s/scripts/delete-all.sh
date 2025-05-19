#!/bin/bash

echo "🧹 Removendo app de exemplo..."
kubectl delete -f ../manifests/app/deployment.yaml --ignore-not-found
kubectl delete -f ../manifests/app/service.yaml --ignore-not-found

echo "🧹 Removendo Prometheus..."
kubectl delete -f ../manifests/prometheus/prometheus-deployment.yaml --ignore-not-found
kubectl delete -f ../manifests/prometheus/prometheus-service.yaml --ignore-not-found
kubectl delete -f ../manifests/prometheus/prometheus-config.yaml --ignore-not-found

echo "🧹 Removendo Grafana..."
kubectl delete -f ../manifests/grafana/grafana-deployment.yaml --ignore-not-found
kubectl delete -f ../manifests/grafana/grafana-service.yaml --ignore-not-found
kubectl delete -f ../manifests/grafana/grafana-datasource-configmap.yaml --ignore-not-found
kubectl delete -f ../manifests/grafana/grafana-dashboards-configmap.yaml --ignore-not-found

echo "✅ Recursos removidos com sucesso."
