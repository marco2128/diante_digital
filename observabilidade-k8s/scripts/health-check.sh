#!/bin/bash

echo "🔎 Verificando IP do Service observ-app-service..."
SERVICE_IP=$(kubectl get svc observ-app-service -o jsonpath='{.spec.clusterIP}')

if [ -z "$SERVICE_IP" ]; then
  echo "❌ Não foi possível obter o IP do serviço."
  exit 1
fi

echo "🌐 IP do serviço: $SERVICE_IP"

echo "🔄 Testando conectividade com curl..."
kubectl run curl-check --rm -i --tty --restart=Never --image=busybox:1.28 -- /bin/sh -c "wget -qO- http://$SERVICE_IP"

echo "✅ Fim do teste."
