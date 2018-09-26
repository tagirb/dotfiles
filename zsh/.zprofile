# environment {{{
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.share

export LC_ALL='en_US.UTF-8'
export EDITOR='nvim'
export PAGER='less'

export LESS='-FiJmnRWX'
export LESSHISTFILE=-

export GPG_TTY="$(tty)"

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_DEFAULT_OPTS=" \
    --bind=ctrl-f:page-down,ctrl-b:page-up \
    --history=$XDG_CACHE_HOME/.fzf_history"
# }}}

# import the private profile from pass
if pass version >/dev/null 2>&1 \
   && [[ -f .password-store/dotfiles/zprofile ]]; then
    eval $(pass show dotfiles/zprofile)
fi
# }}}

# source OS-specific definitions
if [[ -f $ZDOTDIR/.zprofile.$(uname -s) ]]; then
    source $ZDOTDIR/.zprofile.$(uname -s)
fi
