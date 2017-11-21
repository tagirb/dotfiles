#
# .bashrc
#

# source global definitions
if [[ -f /etc/bashrc ]]; then
	source /etc/bashrc
fi

# source OS-specific definitions
if [[ -f ~/.bashrc.$(uname -s) ]]; then
    source ~/.bashrc.$(uname -s)
fi

# direnv
eval "$(direnv hook bash)"

# aliases {{{
alias psu='ps -fu $USER'

## devops password store
if [[ -d ~/.password-store-devops ]]; then
    alias dass='PASSWORD_STORE_DIR=~/.password-store-devops pass'
#    complete -o filenames -F _pass dass
fi
# }}}
