# Installation

To use these git tools, you need to make the scripts in the `bin/` directory available in your system's `PATH`. Here are the recommended approaches:

## Option 1: Add bin Directory to PATH (Recommended)

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

## Option 2: Create Symbolic Links

Create symbolic links to the scripts in a directory that's already in your PATH:

```bash
# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Create symbolic links for all scripts
for script in bin/*; do
    ln -sf "$(pwd)/$script" ~/.local/bin/
done
```

## Option 3: Copy Scripts to Local Bin

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

- Git repository
- Bash shell environment
- Python 3.6+ (for git-grep-blame)
- Standard Unix utilities (sed, awk, etc.)

## Platform Support

These tools are designed for Unix-like systems (Linux, macOS) and should work in:
- Native Linux/macOS terminals
- Windows Subsystem for Linux (WSL)
- Git Bash on Windows (with some limitations)