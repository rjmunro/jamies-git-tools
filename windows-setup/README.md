# Windows Setup for Jamie's Git Tools

This folder contains tools to help you install and use Jamie's Git Tools on Windows.

## Quick Start - Git Bash

1. **Open PowerShell** (you don't need administrator privileges for user-level installation)

2. **Navigate to the repository root:**
   ```powershell
   cd c:\path\to\jamies-git-tools
   ```

3. **Run the installation script:**
   ```powershell
   .\windows-setup\Install-GitTools.ps1
   ```

4. **Open a NEW Git Bash window** and test:
   ```bash
   listgits
   git resolve-formatting-conflicts --help
   ```

## Optional - PowerShell Integration

To use the tools directly in PowerShell (not just Git Bash), run:

```powershell
.\windows-setup\Add-To-PowerShellProfile.ps1
```

Then reload your profile:
```powershell
. $PROFILE
```

Now you can run the tools directly in PowerShell:
```powershell
listgits
git-rebase-all
```

**Note:** The tools still run through Git Bash behind the scenes, but you can call them from PowerShell.

## Installation Script Options

### User Installation (Default)
Installs for the current user only. No administrator privileges required.

```powershell
.\windows-setup\Install-GitTools.ps1
```

### System-Wide Installation
Installs for all users. Requires administrator privileges.

```powershell
.\windows-setup\Install-GitTools.ps1 -Scope Machine
```

### Custom Git Bash Location
If Git Bash is installed in a non-standard location:

```powershell
.\windows-setup\Install-GitTools.ps1 -GitBashPath "C:\Custom\Path\To\Git"
```

## What the Script Does

The installation script performs these steps:

1. **Adds the `bin` directory to your Windows PATH**
   - For User scope: Modifies user environment variables
   - For Machine scope: Modifies system environment variables
   - Allows you to run tools from PowerShell/Command Prompt

2. **Configures Git Bash integration**
   - Updates `~/.bashrc` to include the tools in Git Bash's PATH
   - Ensures `.bash_profile` sources `.bashrc` if needed
   - Converts Windows paths to Unix-style paths for Git Bash

3. **Verifies the installation**
   - Checks that scripts are present
   - Displays next steps

## Requirements

- **Windows 10 or later**
- **Git for Windows** (includes Git Bash)
  - Download from: https://git-scm.com/download/win
- **PowerShell 5.1 or later** (included with Windows 10+)

## Troubleshooting

### "Running scripts is disabled on this system"

If you see this error, you need to enable script execution:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

This is a one-time setup and is safe for running local scripts.

### Tools not found in Git Bash

1. Make sure you opened a **NEW** Git Bash window after installation
2. Check that `~/.bashrc` was created:
   ```bash
   cat ~/.bashrc
   ```
3. Manually source the file to test:
   ```bash
   source ~/.bashrc
   listgits
   ```

### Tools not found in PowerShell

1. **Close and reopen PowerShell** to reload the PATH
2. Check the PATH was updated:
   ```powershell
   $env:Path -split ';' | Select-String "jamies-git-tools"
   ```
3. If the path isn't present, run the installer again

### Git Bash not detected

If the script can't find Git Bash automatically:

1. Find your Git installation directory (usually `C:\Program Files\Git`)
2. Run with the `-GitBashPath` parameter:
   ```powershell
   .\windows-setup\Install-GitTools.ps1 -GitBashPath "C:\Program Files\Git"
   ```

## Manual Installation (Alternative)

If you prefer not to use the automated script:

### For Git Bash

Add this line to `~/.bashrc`:
```bash
export PATH="/c/Users/YourUsername/path/to/jamies-git-tools/bin:$PATH"
```

### For PowerShell

Add the bin directory to your PATH environment variable through Windows Settings:
1. Open **System Properties** → **Environment Variables**
2. Under **User variables**, select **Path** → **Edit**
3. Click **New** and add: `C:\Users\YourUsername\path\to\jamies-git-tools\bin`

## Uninstallation

To remove Jamie's Git Tools:

1. **Remove from Windows PATH:**
   - Open Environment Variables in Windows Settings
   - Remove the `jamies-git-tools\bin` entry from the Path variable

2. **Remove from Git Bash:**
   - Edit `~/.bashrc` and remove the "Jamie's Git Tools" section

## Next Steps

After installation, check out the [main documentation](../README.md) to learn about all available tools, or browse the [tool documentation](../doc/) folder for detailed usage guides.

## Getting Help

For issues specific to Windows installation:
- Check the [Troubleshooting](#troubleshooting) section above
- Review the [main installation guide](../website/installation.md)

For general tool usage:
- See individual tool documentation in the [doc](../doc/) folder
- Check tool help: `git <tool-name> --help`
