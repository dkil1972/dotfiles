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

# On Linux, install zsh plugins and clipboard tool
if [[ "$(uname)" == "Linux" ]]; then
  echo "=== Linux Plugin Setup ==="
  echo

  # powerlevel10k
  if [[ -d "$HOME/.powerlevel10k" ]]; then
    echo "powerlevel10k is already installed."
  else
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
  fi

  # zsh-autosuggestions
  if [[ -d "$HOME/.zsh-autosuggestions" ]]; then
    echo "zsh-autosuggestions is already installed."
  else
    echo "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh-autosuggestions"
  fi

  # xclip for clipboard support
  if command -v xclip &>/dev/null; then
    echo "xclip is already installed."
  else
    echo "Installing xclip..."
    sudo apt update && sudo apt install -y xclip
  fi

  echo
fi

echo "=== Done ==="
echo "Open a new terminal tab — you should be in zsh with your dotfiles config loaded."
