@echo off
title Remoção de ReasonLabs (RAV) e VPN
echo ============================================
echo     REMOÇÃO DE RAV VPN / ENDPOINT / SAFER
echo ============================================

REM Finaliza processos conhecidos
echo Finalizando serviços da ReasonLabs...
taskkill /F /IM ravvpn.exe >nul 2>&1
taskkill /F /IM ravendpoint.exe >nul 2>&1
taskkill /F /IM saferweb.exe >nul 2>&1
taskkill /F /IM vpn.exe >nul 2>&1
taskkill /F /IM ReasonLabs.exe >nul 2>&1
taskkill /F /IM rlav.exe >nul 2>&1

REM Remove programas
echo Desinstalando pacotes RAV...
wmic product where "name like '%%RAV%%'" call uninstall /nointeractive
wmic product where "name like '%%ReasonLabs%%'" call uninstall /nointeractive
wmic product where "name like '%%Safer Web%%'" call uninstall /nointeractive

REM Espera 10 segundos para limpeza
timeout /t 10 /nobreak >nul

REM Reinicia serviço de rede
echo Reiniciando serviços de rede...
ipconfig /flushdns
netsh winsock reset

echo.
echo >>> REINICIE O COMPUTADOR manualmente para aplicar as mudanças.
pause
exit
