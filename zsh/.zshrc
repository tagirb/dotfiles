# Basic Options {{{
# don't beep on error
setopt no_beep
# allow comments even in interactive shells
setopt interactive_comments
# no flow control in zsh editor
unsetopt flow_control
# treat #, ~, and ^ as part of patterns for filename generation
setopt extended_glob
# no spelling correction for commands
unsetopt correct
# no spelling correction for arguments
unsetopt correctall
# perform implicit tees or cats when multiple redirections are attempted
setopt multios
# }}}

# Changing Directories {{{
# If you type foo, and it isn't a command, and it is a directory in your cdpath,
# go there
setopt auto_cd
# if argument to cd is the name of a parameter whose value is a valid directory,
# it will become the current directory
setopt cdablevarS
# don't push multiple copies of the same directory onto the directory stack
setopt pushd_ignore_dups
# }}}

# ZLE {{{
bindkey -e
zle_highlight=(default:bold region:standout isearch:underline)
# }}}

# Aliases {{{
# files and directories
alias la='exa -laF'
alias ld='exa -ldF'
alias ll='exa -lF'
alias ls='exa -F'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# editors
alias vim='nvim'
alias vi='nvim'

# core
v_get() {
    vault token lookup >&/dev/null \
        || vault login -method=oidc >&/dev/null
    vault kv get -field=password $1
}
mydev() {
    local server
    if (( $# == 0 )); then
        server='mysql'
    else
        server=$1
        shift
    fi
    mysql -h "${server}.dev.rsvx.it" -u 'rxdev' \
        -p"$(v_get dev_common/mysql/dev/rxdev)" $@ RESERVIERUNG
}
# }}}

# Additional setting files {{{
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/history.zsh
# }}}
