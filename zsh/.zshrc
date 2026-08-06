# Basic Options
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

# Changing Directories
# If you type foo, and it isn't a command, and it is a directory in your cdpath,
# go there
setopt auto_cd
# if argument to cd is the name of a parameter whose value is a valid directory,
# it will become the current directory
setopt cdablevarS
# don't push multiple copies of the same directory onto the directory stack
setopt pushd_ignore_dups

# ZLE
bindkey -e
zle_highlight=(default:bold region:standout isearch:underline)

# Additional setting files
#source /etc/profile.d/vte-2.91.sh # move to Linux
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/history.zsh


# Aliases
# files and directories
# alias ls='eza -F=auto'
# alias ll='eza -l -F=auto'
# alias ld='eza -ld -F=auto'
# alias la='eza -la -F=auto'

ls(){ eza -F=auto "$@"; }; compdef _eza ls
ll(){ eza -l -F=auto "$@"; }; compdef _eza ll
ld(){ eza -ld -F=auto "$@"; }; compdef _eza ld
la(){ eza -la -F=auto "$@"; }; compdef _eza la

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# editors
alias vim='nvim'
alias vi='nvim'

# tools
alias dc='docker compose'
alias tf='terraform'
alias dbx='databricks'

# User-tunable flags
: ${PROMPT_GIT_FAST_MODE:=0}
: ${ZSH_SHARE_HISTORY:=1}

# additional PATHs
typeset -U path
path=(
    "$HOME/.venvs/local/bin"
    "$HOME/.local/bin"
    $path
)

# Custom functions
tslog() {
  gawk '@load "time"
  {
    ts = gettimeofday()
    sec = int(ts)
    usec = int((ts - sec) * 1000000)
    printf "%s.%06d %s\n", strftime("%F %T", sec), usec, $0
    fflush()
  }'
}

