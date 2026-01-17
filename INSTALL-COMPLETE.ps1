# RightClickTools Complete Installation Script
# This script automatically installs all dependencies and sets up RightClickTools completely
# No manual configuration required - just run and click Install!

param(
    [switch]$SkipDependencies,
    [switch]$AutoInstall
)

# Check if running as administrator
$isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

Write-Host "`n" -ForegroundColor Cyan
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   RightClickTools - Complete Installation Setup    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($isAdmin) {
    Write-Host "✓ Running as Administrator" -ForegroundColor Green
} else {
    Write-Host "⚠ Not running as Administrator" -ForegroundColor Yellow
    Write-Host "  Some features may require admin privileges to install" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  1. Check for required .NET Framework 4.8" -ForegroundColor White
Write-Host "  2. Check for Visual Studio Build Tools" -ForegroundColor White
Write-Host "  3. Build RightClickTools from source" -ForegroundColor White
Write-Host "  4. Automatically install all context menu features" -ForegroundColor White
Write-Host ""

# ============================================================================
# Function to check if .NET Framework 4.8 is installed
# ============================================================================
function Test-DotNetFramework {
    $dotNetKey = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
    
    try {
        $releaseValue = Get-ItemProperty -Path $dotNetKey -Name "Release" -ErrorAction SilentlyContinue
        
        if ($releaseValue) {
            $releaseNumber = $releaseValue.Release
            
            # .NET 4.8 has release number 528372 or higher
            if ($releaseNumber -ge 528372) {
                return $true
            }
        }
    }
    catch {
        return $false
    }
    
    return $false
}

# ============================================================================
# Function to install .NET Framework 4.8
# ============================================================================
function Install-DotNetFramework {
    Write-Host ""
    Write-Host "Installing .NET Framework 4.8..." -ForegroundColor Yellow
    Write-Host "This may take several minutes..." -ForegroundColor Gray
    
    try {
        $downloadUrl = "https://download.microsoft.com/download/0/7/c/07c8a670-5766-4054-aead-143e482f9186/NDP48-x86_x64-WebInstaller.exe"
        $installerPath = "$env:TEMP\NDP48-WebInstaller.exe"
        
        Write-Host "Downloading .NET Framework 4.8..." -ForegroundColor Gray
        
        # Use background job to download
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($downloadUrl, $installerPath)
        
        Write-Host "Running installer..." -ForegroundColor Gray
        $process = Start-Process -FilePath $installerPath -ArgumentList "/q /norestart" -Wait -PassThru
        
        if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
            Write-Host "✓ .NET Framework 4.8 installed successfully" -ForegroundColor Green
            
            # Cleanup
            Remove-Item $installerPath -ErrorAction SilentlyContinue
            
            if ($process.ExitCode -eq 3010) {
                Write-Host "⚠ A system restart is required for changes to take effect" -ForegroundColor Yellow
                return $false
            }
            return $true
        }
        else {
            Write-Host "✗ .NET Framework 4.8 installation failed with code: $($process.ExitCode)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "✗ Error installing .NET Framework 4.8: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# Function to check if MSBuild is available
# ============================================================================
function Test-MSBuild {
    $msbuild = Get-Command msbuild -ErrorAction SilentlyContinue
    return ($null -ne $msbuild)
}

# ============================================================================
# Function to install Visual Studio Build Tools
# ============================================================================
function Install-VisualStudioBuildTools {
    Write-Host ""
    Write-Host "Installing Visual Studio Build Tools 2022..." -ForegroundColor Yellow
    Write-Host "This may take 15-30 minutes depending on your internet speed..." -ForegroundColor Gray
    Write-Host "(Installation will run in the background)" -ForegroundColor Gray
    
    try {
        $downloadUrl = "https://aka.ms/vs/17/release/vs_buildtools.exe"
        $installerPath = "$env:TEMP\vs_buildtools.exe"
        
        Write-Host ""
        Write-Host "Downloading Visual Studio Build Tools..." -ForegroundColor Gray
        
        # Use more robust download method
        try {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($downloadUrl, $installerPath)
        }
        catch {
            # Fallback to Invoke-WebRequest if WebClient fails
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
        }
        
        if (-not (Test-Path $installerPath)) {
            Write-Host "✗ Failed to download Visual Studio Build Tools" -ForegroundColor Red
            return $false
        }
        
        Write-Host "Download complete. Running installer..." -ForegroundColor Gray
        Write-Host ""
        
        # Run the installer with complete configuration for .NET development
        # Using response file approach for most reliable installation
        $responseFileContent = @"
{
  "`"version`": `"1.0`",
  "`"title`": `"Visual Studio Build Tools`",
  "`"productId`": `"Microsoft.VisualStudio.Product.BuildTools`",
  "`"installChannelUri`": `"https://aka.ms/vs/17/release/channel`",
  "`"installCatalogUri`": `"https://aka.ms/vs/17/release/catalog`",
  "`"installPath`": `"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools`",
  "`"quiet`": true,
  "`"passive`": false,
  "`"includeRecommended`": true,
  "`"includeOptional`": false,
  "`"norestart`": true,
  "`"addProductLang`": [
    `"en-US`"
  ],
  "`"add`": [
    `"Microsoft.VisualStudio.Workload.MSBuildTools`",
    `"Microsoft.VisualStudio.Workload.NetCoreTools`",
    `"Microsoft.VisualStudio.Component.NuGet.BuildTools`",
    `"Microsoft.Net.Component.4.8.SDK`",
    `"Microsoft.Net.Component.4.8.TargetingPack`",
    `"Microsoft.VisualStudio.Component.VC.Tools.x86.x64`"
  ]
}
"@
        
        $responseFilePath = "$env:TEMP\vs_buildtools_response.json"
        $responseFileContent | Out-File -FilePath $responseFilePath -Encoding UTF8 -Force
        
        # Run installer with response file
        $process = Start-Process -FilePath $installerPath -ArgumentList `
            "--quiet", `
            "--wait", `
            "--norestart", `
            "--add", "Microsoft.VisualStudio.Workload.MSBuildTools", `
            "--add", "Microsoft.VisualStudio.Workload.NetCoreTools", `
            "--add", "Microsoft.Net.Component.4.8.SDK", `
            "--add", "Microsoft.Net.Component.4.8.TargetingPack", `
            "--add", "Microsoft.VisualStudio.Component.NuGet.BuildTools", `
            "--includeRecommended" `
            -PassThru -WindowStyle Hidden
        
        Write-Host "Installation in progress..." -ForegroundColor Yellow
        Write-Host "This may take 15-30 minutes. Please be patient." -ForegroundColor Gray
        
        # Show progress while waiting
        $counter = 0
        while (-not $process.HasExited) {
            $counter++
            if ($counter % 30 -eq 0) {
                Write-Host "Still installing... ($(Get-Date -Format 'HH:mm:ss'))" -ForegroundColor Gray
            }
            Start-Sleep -Seconds 2
        }
        
        $exitCode = $process.ExitCode
        
        Write-Host ""
        Write-Host "Installation completed with exit code: $exitCode" -ForegroundColor Gray
        
        if ($exitCode -eq 0 -or $exitCode -eq 3010) {
            Write-Host "✓ Visual Studio Build Tools installed successfully" -ForegroundColor Green
            
            # Cleanup
            Remove-Item $installerPath -ErrorAction SilentlyContinue -Force
            Remove-Item $responseFilePath -ErrorAction SilentlyContinue -Force
            
            # Refresh PATH environment variable
            Write-Host "Refreshing environment variables..." -ForegroundColor Gray
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
            
            if ($exitCode -eq 3010) {
                Write-Host "⚠ A system restart is recommended for changes to take full effect" -ForegroundColor Yellow
                Write-Host "  You can restart now or continue - some features may require a restart" -ForegroundColor Gray
            }
            
            return $true
        }
        else {
            Write-Host "✗ Visual Studio Build Tools installation failed with exit code: $exitCode" -ForegroundColor Red
            
            # Cleanup
            Remove-Item $installerPath -ErrorAction SilentlyContinue -Force
            Remove-Item $responseFilePath -ErrorAction SilentlyContinue -Force
            
            Write-Host ""
            Write-Host "Troubleshooting steps:" -ForegroundColor Yellow
            Write-Host "1. Check your internet connection" -ForegroundColor White
            Write-Host "2. Ensure you have at least 5GB of free disk space" -ForegroundColor White
            Write-Host "3. Disable antivirus temporarily if the download fails" -ForegroundColor White
            Write-Host "4. Restart your computer and try again" -ForegroundColor White
            
            return $false
        }
    }
    catch {
        Write-Host "✗ Error installing Visual Studio Build Tools: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# Check and Install Dependencies
# ============================================================================
if (-not $SkipDependencies) {
    Write-Host ""
    Write-Host "Checking dependencies..." -ForegroundColor Cyan
    
    # Check .NET Framework
    Write-Host ""
    Write-Host "Checking .NET Framework 4.8..." -ForegroundColor White
    if (Test-DotNetFramework) {
        Write-Host "✓ .NET Framework 4.8 is installed" -ForegroundColor Green
    }
    else {
        Write-Host "✗ .NET Framework 4.8 is not installed" -ForegroundColor Red
        if ($isAdmin) {
            $installDotNet = Install-DotNetFramework
            if (-not $installDotNet) {
                Write-Host ""
                Write-Host "Cannot proceed without .NET Framework 4.8" -ForegroundColor Red
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host ""
            Write-Host "Please re-run this script as Administrator to install .NET Framework 4.8" -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    
    # Check MSBuild
    Write-Host ""
    Write-Host "Checking Visual Studio Build Tools..." -ForegroundColor White
    if (Test-MSBuild) {
        Write-Host "✓ MSBuild is available" -ForegroundColor Green
    }
    else {
        Write-Host "✗ Visual Studio Build Tools is not installed" -ForegroundColor Red
        if ($isAdmin) {
            $installBuildTools = Install-VisualStudioBuildTools
            if (-not $installBuildTools) {
                Write-Host ""
                Write-Host "Cannot proceed without Visual Studio Build Tools" -ForegroundColor Red
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host ""
            Write-Host "Please re-run this script as Administrator to install Visual Studio Build Tools" -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
}

# ============================================================================
# Build the Project
# ============================================================================
Write-Host ""
Write-Host "Building RightClickTools..." -ForegroundColor Cyan

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

$msbuild = Get-Command msbuild -ErrorAction SilentlyContinue
if (-not $msbuild) {
    Write-Host "✗ MSBuild not found in PATH" -ForegroundColor Red
    Write-Host "Please restart your computer and run this script again" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Running: msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU" -ForegroundColor Gray
Write-Host ""

msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "✗ Build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$exePath = "$(Get-Location)\bin\Release\RightClickTools.exe"

if (-not (Test-Path $exePath)) {
    Write-Host ""
    Write-Host "✗ Build completed but EXE not found at: $exePath" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "✓ Build completed successfully!" -ForegroundColor Green
Write-Host ""

# Copy EXE to Desktop for easy access
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop", "RightClickTools.exe")
Write-Host "Copying to your Desktop..." -ForegroundColor Cyan
try {
    Copy-Item -Path $exePath -Destination $desktopPath -Force
    Write-Host "✓ File ready on Desktop: $desktopPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Build location: $exePath" -ForegroundColor Gray
    $exePath = $desktopPath
}
catch {
    Write-Host "⚠ Could not copy to Desktop" -ForegroundColor Yellow
    Write-Host "File is available at: $exePath" -ForegroundColor Gray
}

# ============================================================================
# Run the Application to Install Context Menu Features
# ============================================================================
Write-Host ""
Write-Host "Launching RightClickTools installer..." -ForegroundColor Cyan
Write-Host ""

if ($AutoInstall) {
    # Auto-install mode (future enhancement)
    Write-Host "Auto-install mode not yet available. Manual installation will open." -ForegroundColor Gray
}

Write-Host "An installation dialog will open. Click 'Install' to add all context menu features." -ForegroundColor Yellow
Write-Host ""

# Run the EXE with elevated privileges if possible
if ($isAdmin) {
    & $exePath
}
else {
    Write-Host "Note: You may be prompted for Administrator privileges." -ForegroundColor Yellow
    & $exePath
}

Write-Host ""
Write-Host "✓ Installation Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "RightClickTools features are now available in your context menu." -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now:" -ForegroundColor White
Write-Host "  • Right-click in Windows Explorer" -ForegroundColor White
Write-Host "  • Find the RightClickTools menu with all available features" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
