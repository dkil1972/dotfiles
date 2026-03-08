# Windows dev machine bootstrap — run in PowerShell on a fresh Windows 11 machine
# Usage: Open PowerShell and run:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#   .\bootstrap.ps1
$ErrorActionPreference = 'Stop'

Write-Host "=== Windows Machine Bootstrap ===" -ForegroundColor Cyan
Write-Host ""

# --- Scoop ---
Write-Host "=== Scoop ===" -ForegroundColor Yellow
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop already installed."
} else {
    Write-Host "Installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    Write-Host "Scoop installed."
}
Write-Host ""

# --- Git + NVM ---
Write-Host "=== Git + NVM ===" -ForegroundColor Yellow
scoop install git
scoop install nvm
Write-Host ""

# --- Node.js LTS ---
Write-Host "=== Node.js ===" -ForegroundColor Yellow
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Node.js already installed: $(node --version)"
} else {
    Write-Host "Installing Node.js LTS via NVM..."
    nvm install lts
    nvm use lts
    Write-Host "Node.js installed: $(node --version)"
}
Write-Host ""

# --- pnpm ---
Write-Host "=== pnpm ===" -ForegroundColor Yellow
if (Get-Command pnpm -ErrorAction SilentlyContinue) {
    Write-Host "pnpm already installed: $(pnpm --version)"
} else {
    Write-Host "Installing pnpm..."
    npm install -g pnpm
    Write-Host "pnpm installed: $(pnpm --version)"
}
Write-Host ""

# --- Claude Code ---
Write-Host "=== Claude Code ===" -ForegroundColor Yellow
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "Claude Code already installed."
} else {
    Write-Host "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    Write-Host "Claude Code installed."
}
Write-Host ""

# --- Python + UV ---
Write-Host "=== Python + UV ===" -ForegroundColor Yellow
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "Python already installed: $(python --version)"
} else {
    Write-Host "Installing Python via Scoop..."
    scoop install python
    Write-Host "Python installed: $(python --version)"
}
if (Get-Command uv -ErrorAction SilentlyContinue) {
    Write-Host "UV already installed: $(uv --version)"
} else {
    Write-Host "Installing UV via Scoop..."
    scoop install uv
    Write-Host "UV installed: $(uv --version)"
}
Write-Host ""

# --- SSH agent ---
Write-Host "=== SSH Agent ===" -ForegroundColor Yellow
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$agentService = Get-Service ssh-agent
if ($agentService.StartType -ne 'Automatic' -or $agentService.Status -ne 'Running') {
    Write-Host "Configuring ssh-agent service..."
    if ($isAdmin) {
        Get-Service ssh-agent | Set-Service -StartupType Automatic
        Start-Service ssh-agent
    } else {
        Write-Host "Elevating to configure ssh-agent service..." -ForegroundColor Yellow
        Start-Process powershell -Verb RunAs -Wait -ArgumentList "-Command", "Get-Service ssh-agent | Set-Service -StartupType Automatic; Start-Service ssh-agent"
    }
    Write-Host "ssh-agent service enabled and started."
} else {
    Write-Host "ssh-agent service already running."
}

# Tell git to use Windows OpenSSH so it connects to the Windows ssh-agent
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
Write-Host "Configured git to use Windows OpenSSH."
Write-Host ""

# --- SSH key ---
Write-Host "=== SSH Key ===" -ForegroundColor Yellow
$sshKey = "$HOME\.ssh\id_ed25519"
if (Test-Path $sshKey) {
    Write-Host "SSH key already exists at $sshKey"
} else {
    $email = Read-Host "Enter your email for the SSH key"
    ssh-keygen -t ed25519 -C $email

    Write-Host ""
    Write-Host "Your public key:" -ForegroundColor Green
    Write-Host ""
    Get-Content "$sshKey.pub"
    Write-Host ""
    Write-Host "Add this key to GitHub: Settings -> SSH and GPG keys -> New SSH key" -ForegroundColor Green
    Read-Host "Press Enter after adding the key to GitHub"
}

# Add key to agent if not already added
$addedKeys = & "C:\Windows\System32\OpenSSH\ssh-add.exe" -l 2>&1
if ($addedKeys -notmatch "ed25519") {
    Write-Host "Adding SSH key to agent (you will be prompted for your passphrase)..."
    & "C:\Windows\System32\OpenSSH\ssh-add.exe" $sshKey
} else {
    Write-Host "SSH key already in agent."
}

# Verify GitHub connection
Write-Host "Verifying GitHub connection..."
& "C:\Windows\System32\OpenSSH\ssh.exe" -T git@github.com 2>&1 | Write-Host
Write-Host ""

# --- Clone dotfiles ---
Write-Host "=== Dotfiles ===" -ForegroundColor Yellow
$dotfilesDir = "$HOME\dev\personal\dotfiles"
if (Test-Path $dotfilesDir) {
    Write-Host "Dotfiles already cloned at $dotfilesDir"
    git -C $dotfilesDir pull
} else {
    Write-Host "Cloning dotfiles..."
    New-Item -ItemType Directory -Path "$HOME\dev\personal" -Force | Out-Null
    git clone git@github.com:dkil1972/dotfiles.git $dotfilesDir
    Write-Host "Dotfiles cloned."
}
Write-Host ""

# --- Claude Code CLI ---
Write-Host "=== Claude Code ===" -ForegroundColor Yellow
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "Claude Code already installed."
} else {
    Write-Host "Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
    Write-Host "Claude Code installed."
}
Write-Host ""

# --- Scoop packages ---
Write-Host "=== Scoop Packages ===" -ForegroundColor Yellow
$scoopfile = "$dotfilesDir\windows\scoopfile.json"
if (Test-Path $scoopfile) {
    scoop bucket add extras 2>$null

    # Install gsudo first so we can elevate for packages that need admin
    Write-Host "Installing gsudo..."
    scoop install main/gsudo

    Write-Host "Importing packages from scoopfile.json..."
    scoop import $scoopfile

    # Tailscale requires admin privileges to install
    Write-Host "Installing Tailscale (requires elevation)..."
    gsudo scoop install extras/tailscale

    Write-Host "Packages installed."
} else {
    Write-Host "WARNING: scoopfile.json not found at $scoopfile" -ForegroundColor Red
}
Write-Host ""

# --- Symlinks ---
Write-Host "=== Dotfile Symlinks ===" -ForegroundColor Yellow
Push-Location $dotfilesDir
node install.mjs
Pop-Location
Write-Host ""

# --- WSL2 ---
Write-Host "=== WSL2 ===" -ForegroundColor Yellow
$installWSL = Read-Host "Install WSL2 + Ubuntu? [y/n]"
if ($installWSL -eq 'y') {
    Write-Host "Installing WSL2 with Ubuntu..."
    wsl --install -d Ubuntu

    Write-Host ""
    Write-Host "WSL2 installation started." -ForegroundColor Green
    Write-Host "A reboot is required to complete the setup." -ForegroundColor Green
    Write-Host ""
    Write-Host "After rebooting:" -ForegroundColor Yellow
    Write-Host "  1. Open Ubuntu from the Start menu and create your Linux user"
    Write-Host "  2. Generate an SSH key (or copy your Windows key):"
    Write-Host "       ssh-keygen -t ed25519 -C `"$email`""
    Write-Host "  3. Add the new key to GitHub if needed"
    Write-Host "  4. Clone and run the Linux setup:"
    Write-Host "       git clone git@github.com:dkil1972/dotfiles.git ~/.dotfiles"
    Write-Host "       cd ~/.dotfiles"
    Write-Host "       bash setup_linux.sh"
} else {
    Write-Host "Skipping WSL2 setup."
}
Write-Host ""

# --- Summary ---
Write-Host "=== Bootstrap Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed:"
Write-Host "  - Scoop (package manager)"
Write-Host "  - Git, NVM, Node.js LTS, pnpm"
Write-Host "  - Claude Code"
Write-Host "  - Dev tools (neovim, ripgrep, fzf, fd, delta, jq, lazygit)"
Write-Host "  - Dotfile symlinks (terminal, vscode, nvim, git bash, claude)"
if ($installWSL -eq 'y') {
    Write-Host "  - WSL2 + Ubuntu (reboot required)"
}
Write-Host ""
Write-Host "Open a new terminal tab to pick up all changes."
