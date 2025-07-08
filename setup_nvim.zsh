#!/bin/zsh

# Absolute path to this script's directory (your dotfiles root)
DOTFILES_DIR="$(pwd)"

# Target nvim config path
TARGET="$HOME/.config/nvim"

# Source nvim config path in your dotfiles
SOURCE="$DOTFILES_DIR/nvim_config"

# Check if ~/.config exists, create if not
mkdir -p "$HOME/.config"

# Remove existing ~/.config/nvim if it exists (file, dir, or symlink)
if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
  echo "Removing existing $TARGET..."
  rm -rf "$TARGET"
fi

# Create symlink
echo "Linking $SOURCE -> $TARGET"
ln -s "$SOURCE" "$TARGET"

echo "✅ Neovim config linked successfully."

