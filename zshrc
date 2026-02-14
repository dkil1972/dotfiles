# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

source ~/.zlogin

# powerlevel10k
if [[ -f "$HOME/.powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
elif (( $+commands[brew] )); then
  source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

# zsh-autosuggestions
if [[ -f "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh"
elif (( $+commands[brew] )); then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

#enable vi movements in zsh
bindkey -v
#copy highlighted text to the clipboard
function vi-yank-xclip {
    zle vi-yank
    if command -v pbcopy &>/dev/null; then
      echo "$CUTBUFFER" | pbcopy
    elif command -v xclip &>/dev/null; then
      echo "$CUTBUFFER" | xclip -selection clipboard
    fi
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

bindkey '^R' history-incremental-search-backward

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Google Cloud SDK
if [ -f '/home/dermotkilroy/google-cloud-sdk/path.zsh.inc' ]; then . '/home/dermotkilroy/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/home/dermotkilroy/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/dermotkilroy/google-cloud-sdk/completion.zsh.inc'; fi
