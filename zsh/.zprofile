# environment {{{
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.share

export LC_ALL='en_US.UTF-8'
export EDITOR='nvim'
export PAGER='less'

export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg

export LESS='-iJmnRW'
export LESSHISTFILE=-

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
# }}}

# SSH and GPG agent {{{

## SSH agent
ssh-add -l >/dev/null 2>&1 \
|| ssh-add ~/.ssh/id_rsa

## GPG agent
if ! pgrep gpg-agent >/dev/null 2>&1; then
    # start up GPG agent
    gpg-agent --daemon --options gpg-agent.conf.$(uname -s) >/dev/null 2>&1
    # trigger asking the passphrase
    echo 'test' | gpg --symmetric >/dev/null 2>&1
fi
export GPG_TTY=$(tty)

# import the private profile from pass
if pass version >/dev/null 2>&1 \
   && [[ -f .password-store/dotfiles/.zprofile ]]; then
    eval $(pass show dotfiles/.zprofile)
fi
# }}}

# source OS-specific definitions
if [[ -f $ZDOTDIR/.zprofile.$(uname -s) ]]; then
    source $ZDOTDIR/.zprofile.$(uname -s)
fi
