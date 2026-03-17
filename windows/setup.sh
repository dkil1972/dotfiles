#!/usr/bin/env bash
# Windows dotfiles bootstrap — run in Git Bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WINDOWS_DIR="$DOTFILES_DIR/windows"

echo "=== Windows dotfiles bootstrap ==="
echo "Dotfiles dir: $DOTFILES_DIR"
echo ""

# --- Scoop ---
if command -v scoop &>/dev/null; then
  echo "Scoop already installed."
else
  echo "Installing Scoop..."
  powershell.exe -NoProfile -Command \
    "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; irm get.scoop.sh | iex"

  # Add scoop to PATH for the rest of this script
  export PATH="$USERPROFILE/scoop/shims:$PATH"
  echo "Scoop installed."
fi
echo ""

# --- Scoop: use system 7zip if available ---
if [[ -f "/c/Program Files/7-Zip/7z.exe" ]]; then
  scoop config use_system_7zip true
fi

# --- Scoop packages ---
SCOOPFILE="$WINDOWS_DIR/scoopfile.json"
if [[ -f "$SCOOPFILE" ]]; then
  echo "Importing scoop packages from scoopfile.json..."
  scoop import "$SCOOPFILE"
  echo "Scoop packages installed."
else
  echo "No scoopfile.json found, skipping package import."
fi
echo ""

# --- Dotfile symlinks ---
echo "Running dotfile symlinks..."
node "$DOTFILES_DIR/install.mjs"
echo ""

echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  - Open a new terminal tab to pick up changes"
echo "  - Run 'scoop export > windows/scoopfile.json' periodically to capture new packages"
