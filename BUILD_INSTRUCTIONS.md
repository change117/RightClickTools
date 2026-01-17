# Quick Setup & Build Guide

## What You Need

To build RightClickTools, you only need **Build Tools for Visual Studio** (NOT the full Visual Studio IDE).

### Step 1: Download Build Tools

1. Go to: https://visualstudio.microsoft.com/downloads/
2. Scroll down to "All Downloads" section
3. Find **"Build Tools for Visual Studio 2022"** and click Download
4. Run the installer that downloads

### Step 2: Install .NET Desktop Build Tools

When the Visual Studio Installer opens:
1. Look for the workload cards
2. Select **".NET desktop build tools"**
3. Click **Install** in the bottom right
4. Wait for installation to complete (~5-10 minutes)

*(Optional: You can also uncheck "Desktop development with C++" and other workloads if you want a smaller installation)*

### Step 3: Build the Project

**Option A: Using Batch File (Easiest)**
- Double-click `BUILD.bat`
- Wait for it to complete
- The EXE will be at: `bin\Release\RightClickTools.exe`

**Option B: Using PowerShell**
1. Right-click `BUILD.ps1`
2. Select "Run with PowerShell"
3. If you get a security warning, click "Run anyway"
4. The EXE will be at: `bin\Release\RightClickTools.exe`

**Option C: Manual Build (Command Line)**
```powershell
# Open PowerShell in the RightClickTools folder
msbuild RightClickTools.csproj /p:Configuration=Release
```

## Output

After a successful build:
- **EXE Location**: `RightClickTools\bin\Release\RightClickTools.exe`
- **Size**: ~120-150 KB
- **Features**:
  - ✓ Requires Administrator privileges
  - ✓ Auto-installs all context menu features
  - ✓ Installs privilege elevation task
  - ✓ No installation dialog

## Using the Built EXE

Simply double-click `RightClickTools.exe` to:
1. Request admin privileges (UAC prompt)
2. Automatically install all features
3. Grant full right-click context menu privileges
4. Complete the installation silently

## Troubleshooting

**"MSBuild not found"**
- Install Build Tools for Visual Studio (see Step 1-2 above)

**"Build failed" errors**
- Make sure you have the `.NET desktop build tools` workload installed
- Try running: `msbuild RightClickTools.csproj /p:Configuration=Release` manually

**Need more space?**
- Build Tools installation requires ~10-15 GB
- Make sure your drive has enough free space

## Questions?

If you have issues, check that:
1. Build Tools for Visual Studio is installed correctly
2. `.NET desktop build tools` workload is selected
3. You're running the build script from the RightClickTools folder
