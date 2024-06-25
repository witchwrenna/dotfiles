export ZDOTDIR=$HOME/.config/zsh
source $HOME/.config/zsh/.zshrc

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt beep extendedglob nomatch notify
bindkey -e


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lilith/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
eval "$(starship init zsh)"
source <(fzf --zsh)
