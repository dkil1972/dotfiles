# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# --- History ---
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=50000
HISTFILESIZE=100000
# Save history immediately, not just on exit
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

# --- Shell options ---
shopt -s checkwinsize
shopt -s cdspell        # auto-correct minor cd typos
shopt -s autocd         # type a dir name to cd into it
shopt -s globstar       # ** recursive glob
shopt -s nocaseglob     # case-insensitive globbing (handy on Windows)
shopt -s no_empty_cmd_completion  # don't tab-complete on empty line

# --- Colors ---
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- Completions ---
# Git Bash ships its own git completion; source system completions if available
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# --- Source dotfiles ---
source ~/.bash/paths
source ~/.bash/aliases
source ~/.bash/config

# Machine-local overrides (not checked in)
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi

# --- Prompt ---
[[ -s "$HOME/.dotfiles/bash/functions/ps1_functions" ]] && source "$HOME/.dotfiles/bash/functions/ps1_functions"
# Also try the symlinked location
[[ -s "$HOME/.bash/functions/ps1_functions" ]] && source "$HOME/.bash/functions/ps1_functions"
ps1_set --prompt ∴

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
