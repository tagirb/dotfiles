# source OS-specific definitions
if [[ -f ~/.zshrc.$(uname -s) ]]; then
    source ~/.zshrc.$(uname -s)
fi

# zsh settings per module/functionality
source $ZDOTDIR/complist.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/zle.zsh
source $ZDOTDIR/setopt.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/history.zsh

