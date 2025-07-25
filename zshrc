# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval $(/opt/homebrew/bin/brew shellenv)

. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

source ~/.zlogin
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#enable vi movements in zsh
bindkey -v
#copy highlighted text to the clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

bindkey '^R' history-incremental-search-backward

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=/Users/kilroys/g.nvm/versions/node/v20.11.1/bin:/Users/kilroys/gbin:/Users/kilroys/g.bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/git/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/usr/bin/ruby:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:/Library/Frameworks/Mono.framework/Versions/6.12.0/bin

export PATH="/Users/kilroys/Library/Python/3.9/bin:$PATH"
