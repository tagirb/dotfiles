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

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_DEFAULT_OPTS=" \
    --bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-p:up,ctrl-n:down \
    --history=$XDG_CACHE_HOME/.fzf_history"

# # Additional paths
# path+=(
#     '~/go/bin'
#     )
# # }}}

# private profile {{{{
source $ZDOTDIR/.zprofile.private
# }}}

# source OS-specific definitions
if [[ -f $ZDOTDIR/.zprofile.$(uname -s) ]]; then
    source $ZDOTDIR/.zprofile.$(uname -s)
fi
