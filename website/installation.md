# Installation

To use these git tools, you need to make the scripts in the `bin/` directory available in your system's `PATH`.

## Windows with Git Bash (Recommended)

For Windows users, we provide an automated PowerShell installer:

1. **Open PowerShell**

2. **Navigate to the repository:**
   ```powershell
   cd C:\path\to\jamies-git-tools
   ```

3. **Run the installer:**
   ```powershell
   .\windows-setup\Install-Tools.ps1 -Install
   ```

4. **Test in Git Bash** (open a new window):
   ```bash
   listgits
   git resolve-formatting-conflicts --help
   ```

5. **Test in PowerShell** (reload profile):
   ```powershell
   . $PROFILE
   listgits
   ```

For detailed Windows setup instructions, troubleshooting, and advanced options, see [windows-setup/README.md](../windows-setup/README.md).

## Linux/macOS Installation

### Option 1: Add bin Directory to PATH (Recommended)

This approach allows you to use the scripts directly from this repository without copying files.

1. **Clone or download this repository to a permanent location:**

   ```bash
   git clone <repository-url> ~/git-tools
   cd ~/git-tools
   ```

2. **Add the bin directory to your PATH by adding this line to your shell configuration file** (e.g., `~/.bashrc`, `~/.zshrc`, `~/.profile`):

   ```bash
   export PATH="$HOME/git-tools/bin:$PATH"
   ```

3. **Reload your shell configuration:**

   ```bash
   source ~/.bashrc  # Or your respective shell config file
   ```

## Option 2: Create Symbolic Links (Linux/macOS)

Create symbolic links to the scripts in a directory that's already in your PATH:

```bash
# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Create symbolic links for all scripts
for script in bin/*; do
    ln -sf "$(pwd)/$script" ~/.local/bin/
done
```

## Option 3: Copy Scripts to Local Bin (Linux/macOS)

Copy all scripts to your local bin directory:

```bash
# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Copy all scripts
cp bin/* ~/.local/bin/
```

## Verification

After installation, open a new terminal and verify the tools are available:

```bash
git resolve-formatting-conflicts --help
listgits --help
# etc.
```

## Requirements

- Git (with Git Bash for Windows users)
- Bash shell environment
- Python 3.6+ (for git-grep-blame)
- Standard Unix utilities (sed, awk, etc.)

## Platform Support

These tools work on:
- **Windows** - Using Git Bash (fully supported with automated installer)
- **Linux** - Native bash environment
- **macOS** - Native bash/zsh environment  
- **WSL** - Windows Subsystem for Linux

**Note for Windows users:** These tools require Git Bash, which is included with [Git for Windows](https://git-scm.com/download/win). They will not work in standard Command Prompt or PowerShell (though the installer itself is a PowerShell script).