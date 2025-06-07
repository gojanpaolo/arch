if grep -q "Ubuntu" /etc/os-release; then
  source "/mnt/c/Users/Jan/Dropbox/env/.bashrcdeb"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  return
fi

# If not running interactively, don't do anything
export LKJLKJ='sdfsdf'
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$HOME/.tfenv/bin:$PATH"
