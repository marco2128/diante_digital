#!/bin/bash

echo "📋 Verificando status dos pods:"
kubectl get pods -o wide

echo ""
echo "🔌 Verificando status dos serviços:"
kubectl get svc

echo ""
echo "📦 Verificando deployments:"
kubectl get deployments

echo ""
echo "🔍 Verificando ConfigMaps:"
kubectl get configmaps
