# Dotfiles

Shell, editor, and terminal config for bash/zsh + Neovim + tmux. Works on macOS, Linux, and Windows (via Git Bash + WSL2).

## Fresh Windows Machine

Run this in PowerShell on a brand new Windows 11 machine — no prerequisites needed:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://raw.githubusercontent.com/dkil1972/dotfiles/master/windows/bootstrap.ps1 -OutFile bootstrap.ps1
.\bootstrap.ps1
```

This will:
1. Install [Scoop](https://scoop.sh), Git, and NVM
2. Install Node.js LTS
3. Generate an SSH key and help you add it to GitHub
4. Clone this repo and install all dev tools (neovim, ripgrep, fzf, fd, delta, jq, lazygit)
5. Create dotfile symlinks (Windows Terminal, VS Code, Neovim, Git Bash)
6. Optionally install WSL2 + Ubuntu (requires reboot)

After rebooting (if WSL2 was installed), open Ubuntu and run the Linux setup below.

## Fresh Linux / WSL2

Works on WSL2 (Ubuntu) and native Debian-based distros (Pop!_OS, etc.):

```sh
git clone git@github.com:dkil1972/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash setup_linux.sh
```

This will:
1. Install base packages (git, curl, build-essential, etc.)
2. Install NVM + Node.js LTS
3. Install Docker Engine (for running containers — e.g. MCP servers)
4. Set up zsh with powerlevel10k and autosuggestions
5. Create dotfile symlinks

After it finishes, log out and back in for Docker group membership, then open a new terminal.

## Manual Setup

If you already have Git and Node.js, you can run the pieces individually:

### Clone and install symlinks

```sh
git clone git@github.com:dkil1972/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
node install.mjs
```

Creates `~/.zshrc`, `~/.bash_profile`, `~/.tmux`, etc. as symlinks into this repo.
If a file already exists you'll be prompted: `[y]es / [n]o / [a]ll / [q]uit`.
Existing files are backed up to `~/.dotfiles_backup/`.

### Set up zsh (Linux only)

```sh
bash setup_zsh.sh
```

### Windows re-run (from Git Bash)

```sh
bash windows/setup.sh
```

Re-imports Scoop packages and re-runs symlinks. Useful after pulling new changes.

### Restore backups

```sh
node restore.mjs
```

Moves everything from `~/.dotfiles_backup/` back to its original location.

## What's Included

| Path | Description |
|------|-------------|
| `zshrc`, `zsh/` | Zsh config, aliases, completions, functions |
| `bash_profile`, `bash/` | Bash config and aliases |
| `nvim_config/` | Neovim config (`~/.config/nvim` or `~/AppData/Local/nvim`) |
| `tmux/` | Tmux configuration |
| `bin/` | Scripts added to PATH |
| `gitignore` | Global gitignore |
| `windows/bootstrap.ps1` | Fresh Windows machine bootstrap (PowerShell) |
| `windows/setup.sh` | Windows re-run script (Git Bash) |
| `windows/scoopfile.json` | Scoop package manifest |
| `windows/terminal/` | Windows Terminal settings |
| `windows/vscode/` | VS Code settings |
| `setup_linux.sh` | Linux/WSL2 bootstrap (zsh, Docker, NVM, symlinks) |
| `setup_zsh.sh` | Zsh + plugin installer (Linux) |

## Requirements

- **Fresh Windows**: Nothing — `bootstrap.ps1` installs everything
- **Fresh Linux/WSL2**: `git` and `curl` (or just run `setup_linux.sh` which installs them)
- **Manual setup**: Node.js (for install/restore scripts)
