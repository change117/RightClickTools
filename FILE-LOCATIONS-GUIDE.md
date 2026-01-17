# RightClickTools - File Locations & Build Output Guide

## Current File Locations

All your source files are located in:
```
/workspaces/RightClickTools/
```

### Source Code Files
- `Program.cs` - Main application code
- `RightClickTools.csproj` - Project configuration
- `RightClickTools.sln` - Solution file
- `App.config` - Application configuration
- `app.manifest` - Windows manifest file
- `RightClickTools.ico` - Application icon

### Installation Scripts (NEW - What We Created)
- **`INSTALL-COMPLETE.bat`** ← Use this! (Windows only)
- **`INSTALL-COMPLETE.ps1`** ← PowerShell version
- `BUILD.bat` - Original build script
- `BUILD.ps1` - Original PowerShell build

### Documentation
- `README.md` - Main project documentation
- `BUILD_INSTRUCTIONS.md` - Original build instructions
- `INSTALL-INSTRUCTIONS.md` - Complete setup guide (NEW)
- `LICENSE` - MIT License

### Other Folders
- `Properties/` - Assembly info and settings
- `assets/` - CSS and styling files
- `obj/` - Build intermediate files

---

## Where Build Output Goes

When you build this project on **Windows**, the compiled files will be created here:

```
RightClickTools/bin/Release/
```

### What You'll Find After Build:

| File | Purpose |
|------|---------|
| `RightClickTools.exe` | **The main application** ← This is what you install! |
| `RightClickTools.pdb` | Debug symbols (optional) |
| `App.config` | Application settings (copied) |

---

## Step-by-Step: How to Build & Install

### On a Windows Computer:

1. **Get the files:**
   - Download the entire RightClickTools folder from GitHub, or
   - Copy the files from `/workspaces/RightClickTools/` to your Windows machine

2. **Run the automatic installer:**
   - Double-click **`INSTALL-COMPLETE.bat`** in the RightClickTools folder
   - Click **Yes** when prompted for admin rights
   - Wait for it to complete (15-30 minutes on first run for dependencies)

3. **After completion:**
   - The built EXE will be at: `RightClickTools\bin\Release\RightClickTools.exe`
   - The installer will automatically launch
   - Click **Install** in the dialog that appears
   - Done! All features are now in your right-click menu

### Alternative: Manual Build

If you prefer manual control:

1. Extract the RightClickTools folder on Windows
2. Double-click **`BUILD.bat`** (requires dependencies already installed)
3. When complete, find the EXE at: `bin\Release\RightClickTools.exe`
4. Double-click the EXE
5. Click **Install** in the dialog

---

## Output Files Summary

After building, you'll have:

```
RightClickTools/
├── bin/
│   ├── Debug/              (if you build Debug version)
│   │   └── RightClickTools.exe
│   └── Release/            (if you build Release version)
│       └── RightClickTools.exe  ← This is what you install!
└── obj/                   (build artifacts - ignore these)
```

---

## Quick Reference Checklist

✓ **Source code:** Located in `/workspaces/RightClickTools/`
✓ **Installation script:** `INSTALL-COMPLETE.bat` (the file you double-click)
✓ **Output location after build:** `bin\Release\RightClickTools.exe`
✓ **Requirements:** Windows computer (Linux doesn't support .NET Framework 4.8)

---

## Summary

| Item | Location |
|------|----------|
| All source files | `/workspaces/RightClickTools/` |
| What to download | The entire `/workspaces/RightClickTools/` folder |
| What to run | `INSTALL-COMPLETE.bat` (on Windows) |
| Where it builds to | `bin\Release\RightClickTools.exe` |
| Where to find the EXE | After build: `RightClickTools\bin\Release\` |

The built executable will be in a `bin\Release\` folder inside the RightClickTools directory when the build completes.
