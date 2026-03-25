# environment {{{
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export LC_ALL='en_US.UTF-8'
export EDITOR='nvim'
export PAGER='less'
export LS_COLORS=$(vivid generate one-dark)

export LESS='-FiJmnRWX'
export LESSHISTFILE=-

export GPG_TTY="$(tty)"

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export FZF_DEFAULT_COMMAND='fdfind --type file'
export FZF_DEFAULT_OPTS=" \
    --bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-p:up,ctrl-n:down \
    --history=$XDG_CACHE_HOME/.fzf_history"

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"
# }}}


if [[ -f $ZDOTDIR/.zprofile.private ]]; then
    source $ZDOTDIR/.zprofile.private
fi

# OS-specific definitions
if [[ -f $ZDOTDIR/.zprofile.$(uname -s) ]]; then
    source $ZDOTDIR/.zprofile.$(uname -s)
fi

# work-related profile
if [[ -f $HOME/w/.config/zsh/.zprofile ]]; then
    source $HOME/w/.config/zsh/.zprofile
fi
