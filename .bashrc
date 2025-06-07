if grep -q "Ubuntu" /etc/os-release; then
  source "/mnt/c/Users/Jan/Dropbox/env/.bashrcdeb"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  return
fi

# TODO: I think this is included by default in arch. learn what this does and remove if not needed
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# https://wiki.archlinux.org/title/Dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias grep='grep --color=auto'
alias la='ls --color=auto -alFh'

printf "%s " "$(dirs -p)"
export PS1="\n$ "

export PATH="$HOME/.tfenv/bin:$PATH"
