# RightClickTools Complete Installation Script
# This script automatically installs all dependencies and builds RightClickTools
# No manual configuration required - just run and it does everything!

param(
    [switch]$SkipDependencies
)

# Check if running as administrator
$isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

Write-Host ""
Write-Host "RightClickTools - Complete Installation Setup"
Write-Host ""

if ($isAdmin) {
    Write-Host "[OK] Running as Administrator"
} else {
    Write-Host "[WARNING] Not running as Administrator"
}

Write-Host ""
Write-Host "This script will:"
Write-Host "  1. Check for .NET Framework 4.8"
Write-Host "  2. Check for Visual Studio Build Tools"
Write-Host "  3. Build RightClickTools"
Write-Host "  4. Copy to Desktop"
Write-Host ""

# Function to check .NET Framework 4.8
function Test-DotNetFramework {
    $dotNetKey = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
    try {
        $releaseValue = Get-ItemProperty -Path $dotNetKey -Name "Release" -ErrorAction SilentlyContinue
        if ($releaseValue) {
            if ($releaseValue.Release -ge 528372) {
                return $true
            }
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to install .NET Framework 4.8
function Install-DotNetFramework {
    Write-Host ""
    Write-Host "Installing .NET Framework 4.8..."
    
    try {
        $downloadUrl = "https://download.microsoft.com/download/0/7/c/07c8a670-5766-4054-aead-143e482f9186/NDP48-x86_x64-WebInstaller.exe"
        $installerPath = "$env:TEMP\NDP48-WebInstaller.exe"
        
        Write-Host "Downloading..."
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($downloadUrl, $installerPath)
        
        Write-Host "Running installer..."
        $process = Start-Process -FilePath $installerPath -ArgumentList "/q /norestart" -Wait -PassThru
        
        if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
            Write-Host "[OK] .NET Framework 4.8 installed"
            Remove-Item $installerPath -ErrorAction SilentlyContinue
            return $true
        } else {
            Write-Host "[ERROR] Installation failed with code: $($process.ExitCode)"
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] $($_)"
        return $false
    }
}

# Function to check MSBuild
function Test-MSBuild {
    $msbuild = Get-Command msbuild -ErrorAction SilentlyContinue
    return ($null -ne $msbuild)
}

# Function to install Visual Studio Build Tools
function Install-VisualStudioBuildTools {
    Write-Host ""
    Write-Host "Installing Visual Studio Build Tools 2022..."
    Write-Host "This may take 15-30 minutes..."
    
    try {
        $downloadUrl = "https://aka.ms/vs/17/release/vs_buildtools.exe"
        $installerPath = "$env:TEMP\vs_buildtools.exe"
        
        Write-Host "Downloading..."
        try {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($downloadUrl, $installerPath)
        }
        catch {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
        }
        
        if (-not (Test-Path $installerPath)) {
            Write-Host "[ERROR] Failed to download"
            return $false
        }
        
        Write-Host "Running installer..."
        
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
        
        Write-Host "Installation in progress..."
        
        $counter = 0
        while (-not $process.HasExited) {
            $counter++
            if ($counter % 30 -eq 0) {
                Write-Host "Still installing... $(Get-Date -Format 'HH:mm:ss')"
            }
            Start-Sleep -Seconds 2
        }
        
        $exitCode = $process.ExitCode
        
        if ($exitCode -eq 0 -or $exitCode -eq 3010) {
            Write-Host "[OK] Visual Studio Build Tools installed"
            Remove-Item $installerPath -ErrorAction SilentlyContinue -Force
            
            # Refresh PATH
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
            return $true
        }
        else {
            Write-Host "[ERROR] Installation failed with code: $exitCode"
            Remove-Item $installerPath -ErrorAction SilentlyContinue -Force
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] $($_)"
        return $false
    }
}

# Check dependencies
if (-not $SkipDependencies) {
    Write-Host ""
    Write-Host "Checking dependencies..."
    
    # Check .NET Framework
    Write-Host ""
    Write-Host "Checking .NET Framework 4.8..."
    if (Test-DotNetFramework) {
        Write-Host "[OK] .NET Framework 4.8 is installed"
    }
    else {
        Write-Host "[ERROR] .NET Framework 4.8 is not installed"
        if ($isAdmin) {
            if (-not (Install-DotNetFramework)) {
                Write-Host "[ERROR] Cannot proceed without .NET Framework 4.8"
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host "[ERROR] Please run as Administrator"
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    
    # Check MSBuild
    Write-Host ""
    Write-Host "Checking Visual Studio Build Tools..."
    if (Test-MSBuild) {
        Write-Host "[OK] MSBuild is available"
    }
    else {
        Write-Host "[ERROR] Visual Studio Build Tools is not installed"
        if ($isAdmin) {
            if (-not (Install-VisualStudioBuildTools)) {
                Write-Host "[ERROR] Cannot proceed without Visual Studio Build Tools"
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host "[ERROR] Please run as Administrator"
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
}

# Build the Project
Write-Host ""
Write-Host "Building RightClickTools..."

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

$msbuild = Get-Command msbuild -ErrorAction SilentlyContinue
if (-not $msbuild) {
    Write-Host "[ERROR] MSBuild not found in PATH"
    Write-Host "Please restart your computer and run this script again"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Running: msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU"
Write-Host ""

msbuild RightClickTools.csproj /p:Configuration=Release /p:Platform=AnyCPU

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build failed!"
    Read-Host "Press Enter to exit"
    exit 1
}

$exePath = "$(Get-Location)\bin\Release\RightClickTools.exe"

if (-not (Test-Path $exePath)) {
    Write-Host ""
    Write-Host "[ERROR] EXE not found at: $exePath"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "[OK] Build completed successfully!"
Write-Host ""

# Copy to Desktop
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop", "RightClickTools.exe")
Write-Host "Copying to your Desktop..."
try {
    Copy-Item -Path $exePath -Destination $desktopPath -Force
    Write-Host "[OK] File ready on Desktop: $desktopPath"
    Write-Host ""
    Write-Host "Build location: $exePath"
    $exePath = $desktopPath
}
catch {
    Write-Host "[WARNING] Could not copy to Desktop"
    Write-Host "File is available at: $exePath"
}

# Run the Application
Write-Host ""
Write-Host "Launching RightClickTools installer..."
Write-Host ""

Write-Host "An installation dialog will open. Click 'Install' to add all context menu features."
Write-Host ""

if ($isAdmin) {
    & $exePath
}
else {
    Write-Host "Note: You may be prompted for Administrator privileges."
    & $exePath
}

Write-Host ""
Write-Host "[OK] Installation Complete!"
Write-Host ""
Write-Host "RightClickTools features are now available in your context menu."
Write-Host ""
Write-Host "You can now:"
Write-Host "  - Right-click in Windows Explorer"
Write-Host "  - Find the RightClickTools menu with all available features"
Write-Host ""

Read-Host "Press Enter to exit"
