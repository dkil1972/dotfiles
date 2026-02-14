# Dotfiles

Shell, editor, and terminal config for bash/zsh + Neovim + tmux.

## Setup

### 1. Clone and install symlinks

```sh
git clone git@github.com:<your-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
node install.mjs
```

This creates `~/.zshrc`, `~/.bash_profile`, `~/.tmux`, etc. as symlinks pointing back into this repo. It also links `~/.config/nvim` to the Neovim config.

If a file already exists you'll be prompted: `[y]es / [n]o / [a]ll / [q]uit`.
Existing files are backed up to `~/.dotfiles_backup/` before being replaced.

### 2. Set up zsh (optional)

If you're on a fresh Ubuntu/WSL install without zsh:

```sh
bash setup_zsh.sh
```

This installs zsh and sets it as your default shell. Open a new terminal tab afterwards.

### 3. If something goes wrong

```sh
node restore.mjs
```

This moves everything from `~/.dotfiles_backup/` back to its original location, removing the symlinks.

## What's included

| Path | Description |
|------|-------------|
| `zshrc`, `zsh/` | Zsh config, aliases, completions |
| `bash_profile`, `bash/` | Bash config and aliases |
| `nvim_config/` | Neovim config (linked to `~/.config/nvim`) |
| `tmux/` | Tmux configuration |
| `bin/` | Scripts added to PATH |
| `gitignore` | Global gitignore |

## Requirements

- Node.js (for install/restore scripts)
- Neovim (aliased as `vim` in both bash and zsh)
