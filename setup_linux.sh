#!/bin/bash
# Unified Linux bootstrap — works on WSL2 (Ubuntu) and native Linux (Mint / Pop!_OS / Debian-based)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
NVM_VERSION="v0.40.1"

echo "=== Linux Machine Bootstrap ==="
echo "Dotfiles dir: $DOTFILES_DIR"
echo

# --- Detect environment ---
if grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
  echo "Detected: WSL2"
else
  IS_WSL=false
  echo "Detected: Native Linux"
fi
echo

# --- Base packages ---
echo "=== Base Packages ==="
PACKAGES=(git curl wget build-essential unzip tmux openssh-server gh)
MISSING=()
for pkg in "${PACKAGES[@]}"; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    MISSING+=("$pkg")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Installing: ${MISSING[*]}"
  sudo apt update && sudo apt install -y "${MISSING[@]}"
else
  echo "All base packages already installed."
fi

# Start and enable SSH server
if systemctl is-system-running &>/dev/null 2>&1; then
  sudo systemctl enable --now ssh
else
  sudo service ssh start
fi
echo

# --- NVM + Node.js ---
echo "=== NVM + Node.js ==="
export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  echo "NVM already installed."
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
else
  echo "Installing NVM ${NVM_VERSION}..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
  echo "NVM installed."
fi

if command -v node &>/dev/null; then
  echo "Node.js already installed: $(node --version)"
else
  echo "Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts
  echo "Node.js installed: $(node --version)"
fi
echo

# --- Claude Code CLI ---
echo "=== Claude Code ==="
if command -v claude &>/dev/null; then
  echo "Claude Code already installed."
else
  echo "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
  echo "Claude Code installed."
fi
echo

# --- Docker Engine ---
echo "=== Docker Engine ==="
if command -v docker &>/dev/null; then
  echo "Docker already installed: $(docker --version)"
else
  echo "Installing Docker Engine..."

  # Prerequisites
  sudo apt update
  sudo apt install -y ca-certificates curl gnupg

  # Add Docker GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
  fi

  # Add Docker repo
  # Use Ubuntu codename — works for Mint / Pop!_OS too (based on Ubuntu)
  UBUNTU_CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Add current user to docker group
  sudo usermod -aG docker "$USER"

  echo "Docker installed: $(docker --version)"
  DOCKER_NEWLY_INSTALLED=true
fi

# Start Docker if not running
if command -v docker &>/dev/null; then
  if ! docker info &>/dev/null 2>&1; then
    if systemctl is-system-running &>/dev/null 2>&1; then
      sudo systemctl start docker
    else
      # WSL2 without systemd
      sudo service docker start
    fi
  fi
fi
echo

# --- Tailscale ---
echo "=== Tailscale ==="
if command -v tailscale &>/dev/null; then
  echo "Tailscale already installed: $(tailscale version | head -1)"
else
  echo "Installing Tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
  echo "Tailscale installed."
  echo "Run 'sudo tailscale up' to connect."
fi
echo

# --- Playwright (for Claude Code MCP) ---
echo "=== Playwright ==="
echo "Installing Playwright Chromium + system dependencies..."
npx playwright install --with-deps chromium
echo

# --- Zsh setup ---
echo "=== Zsh Setup ==="
bash "$DOTFILES_DIR/setup_zsh.sh"
echo

# --- Dotfile symlinks ---
echo "=== Dotfile Symlinks ==="
node "$DOTFILES_DIR/install.mjs"
echo

# --- Summary ---
echo "=== Done ==="
echo
if [[ "${DOCKER_NEWLY_INSTALLED:-}" == "true" ]]; then
  echo "NOTE: Log out and back in for Docker group membership to take effect."
  echo "      Then verify with: docker run hello-world"
  echo
fi
echo "Open a new terminal to use zsh with your dotfiles config."
