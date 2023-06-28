# environment {{{
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export LC_ALL='en_US.UTF-8'
export EDITOR='nvim'
export PAGER='less'

export LESS='-FiJmnRWX'
export LESSHISTFILE=-

export GPG_TTY="$(tty)"

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_DEFAULT_OPTS=" \
    --bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-p:up,ctrl-n:down \
    --history=$XDG_CACHE_HOME/.fzf_history"

# Bitwarden handling
bw_session_file="$HOME/.config/Bitwarden CLI/bw_session"
if ! ( [[ -f $bw_session_file ]] \
     && export BW_SESSION=$(cat $bw_session_file) \
     && bw unlock --check &>/dev/null )
then
    if bw login --check &>/dev/null; then
        if ! bw unlock --check &>/dev/null; then
            >&2 echo 'Unlock Bitwarden..'
            export BW_SESSION=$(bw unlock --raw)
            echo $BW_SESSION > $bw_session_file
            bw sync &>/dev/null
        fi
    else
        >&2 echo 'Log in to Bitwarden..'
        export BW_SESSION=$(bw unlock --raw)
        echo $BW_SESSION > $bw_session_file
        bw sync &>/dev/null
    fi
fi

# # Additional paths
# path+=(
#     '~/go/bin'
#     "$(gem env gempath | cut -d: -f1)/bin"
#     )
# # }}}

# source OS-specific definitions
if [[ -f $ZDOTDIR/.zprofile.$(uname -s) ]]; then
    source $ZDOTDIR/.zprofile.$(uname -s)
fi
