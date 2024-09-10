@echo off
:: Check if the script is running with elevated privileges
NET SESSION >nul 2>&1
if %errorLevel% NEQ 0 (
    echo This script requires Administrator privileges.
    echo Please grant permission when prompted.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: If already running as admin, continue with the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0BootMenu.ps1"
pause
