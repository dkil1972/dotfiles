#!/bin/bash
# Linux Mint dev machine bootstrap — run on a fresh install
# Usage: curl -fsSL https://raw.githubusercontent.com/dkil1972/dotfiles/master/linux/bootstrap.sh | bash
set -euo pipefail

echo "=== Linux Mint Machine Bootstrap ==="
echo

# --- Base packages (just enough to clone dotfiles) ---
echo "=== Base Packages ==="
PACKAGES=(git curl wget openssh-client)
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
echo

# --- SSH key ---
echo "=== SSH Key ==="
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY" ]]; then
  echo "SSH key already exists at $SSH_KEY"
else
  read -rp "Enter your email for the SSH key: " EMAIL
  ssh-keygen -t ed25519 -C "$EMAIL"

  echo
  echo "Your public key:"
  echo
  cat "${SSH_KEY}.pub"
  echo
  echo "Add this key to GitHub: Settings -> SSH and GPG keys -> New SSH key"
  read -rp "Press Enter after adding the key to GitHub..."
fi

# Ensure ssh-agent is running and key is loaded
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY" 2>/dev/null || true

# Verify GitHub connection
echo "Verifying GitHub connection..."
ssh -T git@github.com 2>&1 || true
echo

# --- Clone dotfiles ---
echo "=== Dotfiles ==="
DOTFILES_DIR="$HOME/dev/personal/dotfiles"
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles already cloned at $DOTFILES_DIR"
  git -C "$DOTFILES_DIR" pull
else
  echo "Cloning dotfiles..."
  mkdir -p "$HOME/dev/personal"
  git clone git@github.com:dkil1972/dotfiles.git "$DOTFILES_DIR"
  echo "Dotfiles cloned."
fi
echo

# --- Run full setup ---
echo "=== Running setup_linux.sh ==="
bash "$DOTFILES_DIR/setup_linux.sh"
