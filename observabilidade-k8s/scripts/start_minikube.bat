@echo off
echo 🚀 Iniciando Minikube com driver Docker...
minikube start --driver=docker --cpus=2 --memory=2200mb --disk-size=20g

if %errorlevel% neq 0 (
    echo ❌ Erro ao iniciar o Minikube.
) else (
    echo ✅ Minikube iniciado com sucesso!
    minikube status
)
pause
