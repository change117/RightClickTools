# RightClickTools Build Script for PowerShell
# This script builds the project in Release mode and outputs the EXE

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RightClickTools Build Script" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if MSBuild is available
$msbuild = Get-Command msbuild -ErrorAction SilentlyContinue

if (-not $msbuild) {
    Write-Host "Error: MSBuild not found!" -ForegroundColor Red
    Write-Host "`nPlease install 'Build Tools for Visual Studio':" -ForegroundColor Yellow
    Write-Host "1. Go to: https://visualstudio.microsoft.com/downloads/" -ForegroundColor White
    Write-Host "2. Download 'Build Tools for Visual Studio 2022'" -ForegroundColor White
    Write-Host "3. Run the installer" -ForegroundColor White
    Write-Host "4. Select '.NET desktop build tools'" -ForegroundColor White
    Write-Host "5. Complete the installation" -ForegroundColor White
    Write-Host "6. Run this script again`n" -ForegroundColor White
    Read-Host "Press Enter to exit"
    exit 1
}

# Build the project
Write-Host "Building RightClickTools in Release mode...`n" -ForegroundColor Green

msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nBuild failed! Please check the errors above.`n" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$exePath = "$(Get-Location)\bin\Release\RightClickTools.exe"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Build Complete!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "The compiled EXE is located at:" -ForegroundColor Green
Write-Host "$exePath`n" -ForegroundColor White

Write-Host "This version will:" -ForegroundColor Cyan
Write-Host "  ✓ Automatically install all features" -ForegroundColor White
Write-Host "  ✓ Grant full administrator privileges" -ForegroundColor White
Write-Host "  ✓ Install the privilege elevation task`n" -ForegroundColor White

Write-Host "Ready to use! The EXE is ready for distribution." -ForegroundColor Green
Read-Host "`nPress Enter to exit"
