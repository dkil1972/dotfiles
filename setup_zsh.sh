#!/bin/bash
set -e

echo "=== Zsh Setup ==="
echo

# Install zsh if not present
if command -v zsh &>/dev/null; then
  echo "zsh is already installed: $(zsh --version)"
else
  echo "Installing zsh..."
  sudo apt update && sudo apt install -y zsh
  echo "Installed: $(zsh --version)"
fi

echo

# Set zsh as default shell
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "zsh" ]; then
  echo "zsh is already your default shell."
else
  echo "Setting zsh as your default shell..."
  chsh -s "$(which zsh)"
  echo "Default shell changed to zsh. Open a new terminal tab to use it."
fi

echo
echo "=== Done ==="
echo "Open a new terminal tab — you should be in zsh with your dotfiles config loaded."
