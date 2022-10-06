# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

source ~/.zlogin
source /usr/local/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval 'export RBENV_SHELL=bash
source '/usr/local/Homebrew/Cellar/rbenv/1.2.0/libexec/../completions/rbenv.bash'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}'
export PATH='/Users/dermotkilroy/.rbenv/bin:/Users/dermotkilroy/.rbenv/shims:/Users/dermotkilroy/.nvm/versions/node/v14.17.1/bin:/Users/dermotkilroy/bin:/Users/dermotkilroy/.bin:/usr/local/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin:/usr/local/homebrew/bin:/usr/local/homebrew/sbin:/usr/local/bin:/usr/bin:/usr/bin/ruby:/bin:/usr/sbin:/sbin:/Users/dermotkilroy/.nvm/versions/node/v14.17.1/bin:/Users/dermotkilroy/bin:/Users/dermotkilroy/.bin:/usr/local/homebrew/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin:/usr/local/homebrew/sbin:/Users/dermotkilroy/.cargo/bin'
