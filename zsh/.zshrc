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

# tools
alias tf='terraform'
alias tfp='terraform plan -refresh=false'
alias dc='docker compose'
alias task='go-task'
alias code='ELECTRON_OZONE_PLATFORM_HINT="wayland" electron /usr/lib/vscodium-electron/out/cli.js /usr/lib/vscodium-electron/vscodium-electron.js'

# Additional setting files {{{
source /etc/profile.d/vte.sh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/history.zsh
# }}}
