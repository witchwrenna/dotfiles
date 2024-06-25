source $ZDOTDIR/.aliases

# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt beep extendedglob nomatch notify
setopt INC_APPEND_HISTORY

bindkey -e


# End of lines configured by zsh-newuser-install

eval "$(starship init zsh)"
source <(fzf --zsh)
