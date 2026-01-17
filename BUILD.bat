@echo off
REM RightClickTools Build Script
REM This script builds the project in Release mode and outputs the EXE

setlocal enabledelayedexpansion

echo.
echo ========================================
echo RightClickTools Build Script
echo ========================================
echo.

REM Check if MSBuild is available
where msbuild >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: MSBuild not found. Please install Build Tools for Visual Studio.
    echo.
    echo Download from: https://visualstudio.microsoft.com/downloads/
    echo Then select ".NET desktop build tools"
    echo.
    pause
    exit /b 1
)

REM Build the project
echo Building RightClickTools in Release mode...
echo.
msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU

if %errorlevel% neq 0 (
    echo.
    echo Build failed! Please check the errors above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo The compiled EXE is located at:
echo %cd%\bin\Release\RightClickTools.exe
echo.
echo This version will:
echo  - Automatically install all features
echo  - Grant full administrator privileges
echo  - Install the privilege elevation task
echo.
pause
