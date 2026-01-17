@echo off
REM RightClickTools Complete Installation Script
REM Double-click this file to automatically install everything!
REM
REM This script will:
REM   1. Check for required .NET Framework 4.8
REM   2. Check for Visual Studio Build Tools
REM   3. Build RightClickTools
REM   4. Copy the finished EXE to your Desktop
REM   5. Install all context menu features automatically

setlocal enabledelayedexpansion

echo.
echo ╔════════════════════════════════════════════════════╗
echo ║   RightClickTools - Complete Installation Setup    ║
echo ╚════════════════════════════════════════════════════╝
echo.
echo This will build RightClickTools and copy it to:
echo C:\Users\%USERNAME%\Desktop\RightClickTools.exe
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo This script requires Administrator privileges.
    echo Attempting to restart with elevated permissions...
    echo.
    
    REM Try to run as admin
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"!CD!\INSTALL-COMPLETE.bat\"' -Verb RunAs"
    exit /b %errorlevel%
)

REM Switch to script directory
cd /d "%~dp0"

REM Run the PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "INSTALL-COMPLETE.ps1"

if %errorlevel% neq 0 (
    echo.
    echo Installation failed. Check errors above.
    echo.
    pause
    exit /b %errorlevel%
)

exit /b 0
