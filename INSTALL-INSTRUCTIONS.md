# RightClickTools - One-Click Installation Guide

## Quick Start (Easiest)

**For the absolute simplest installation experience:**

1. **Download** the latest version from the [GitHub Releases page](https://github.com/LesFerch/RightClickTools/releases)
2. Extract the ZIP file to any location
3. **Double-click `INSTALL-COMPLETE.bat`** in the folder
4. That's it! Everything will be installed automatically.

---

## What Does This Script Do?

The `INSTALL-COMPLETE.bat` script is a fully automated installation that:

✅ **Automatically installs all missing dependencies:**
- .NET Framework 4.8 (if not already installed)
- Visual Studio Build Tools 2022 (if not already installed)

✅ **Builds the application** from source code

✅ **Installs all context menu features** so they're ready to use immediately

✅ **Requires Administrator privileges** (will prompt automatically)

✅ **No manual configuration needed** - just click and wait!

---

## System Requirements

- **Windows 7 or later** (Windows 10/11 recommended)
- **Internet connection** (to download dependencies if needed)
- **Administrator account** (required to install context menu features)
- **~2-3 GB free disk space** (for build tools installation if needed)

---

## How to Use

### Option 1: INSTALL-COMPLETE.bat (Recommended - Works on All Windows)

1. Extract the RightClickTools folder
2. Double-click **`INSTALL-COMPLETE.bat`**
3. Click **Yes** when prompted for Administrator privileges
4. Wait for installation to complete
5. Click **Install** in the RightClickTools dialog when it appears
6. Done! All features are now available in your right-click menu

### Option 2: INSTALL-COMPLETE.ps1 (PowerShell - Advanced Users)

1. Extract the RightClickTools folder
2. Right-click **`INSTALL-COMPLETE.ps1`**
3. Select **"Run with PowerShell"**
4. If prompted about security, click **"Run anyway"**
5. Wait for installation to complete
6. Click **Install** in the RightClickTools dialog when it appears
7. Done!

### Option 3: Manual Build & Install

If you prefer to build manually:

1. Ensure .NET Framework 4.8 is installed:
   - Download from: https://aka.ms/dotnet-framework-4-8
   
2. Ensure Visual Studio Build Tools are installed:
   - Download from: https://visualstudio.microsoft.com/downloads/
   - Select "Desktop development with C++"

3. Extract the RightClickTools folder

4. Double-click **`BUILD.bat`** to compile

5. Navigate to `bin\Release\` folder

6. Double-click **`RightClickTools.exe`**

7. Click **Install** in the dialog that appears

---

## What Gets Installed?

Once installation is complete, you'll have access to these features in your right-click context menu:

- **Open Command Window Here** - Open CMD at current location
- **Open PowerShell Here** - Open PowerShell at current location  
- **Open Command Window Here as Administrator** - Admin CMD prompt (if privilege elevation task is installed)
- And more tools depending on your RightClickTools version

---

## Troubleshooting

### "Administrator privileges required"
- The script needs admin rights to install system components
- Windows will prompt you automatically - click **Yes**

### "Build failed"
- Ensure your internet connection is stable
- Make sure you have at least 3GB free disk space
- Try running the script again

### ".NET Framework 4.8 installation failed"
- Check your internet connection
- Ensure Windows Update is running in the background
- Restart your computer and try again

### "MSBuild not found"
- The script will attempt to install Visual Studio Build Tools
- This can take 15-20 minutes on first install
- Restart your computer after installation completes
- Run the script again

### "RightClickTools features don't appear"
- Right-click in an empty area of Windows Explorer
- Check if "RightClickTools" menu item appears
- If not, re-run the install script and click Install again
- On Windows 11, you may need to enable "Show full context menu" option in Windows Settings

---

## Uninstalling

To remove RightClickTools:

1. Navigate to the RightClickTools folder
2. Double-click **`RightClickTools.exe`**
3. Click **Remove** in the dialog
4. Click **Yes** to confirm
5. Done! The context menu features are removed

The files will remain in your folder - you can delete them manually if desired.

---

## Need Help?

For issues or questions:
- Check the main [README.md](README.md) file for detailed feature descriptions
- Visit the [GitHub Issues page](https://github.com/LesFerch/RightClickTools/issues)
- Contact the developer: lesferch@gmail.com

---

## Notes

- The installation is safe and doesn't modify Windows system files (only context menu registry entries)
- All dependencies installed are legitimate, signed Microsoft components
- You can verify the EXE integrity on VirusTotal (though false positives are common for privilege elevation tools)
- The privilege elevation task is optional but recommended for seamless admin access without UAC prompts
