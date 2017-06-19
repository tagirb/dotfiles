# .bash_profile

# Get the aliases and functions
if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi

# include the private stuff
if [[ -f ~/.bash_profile_private ]]; then
    source ~/.bash_profile_private
fi

# User specific environment and startup programs
# Git prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM=auto

case "$(uname -s)" in
    'Linux')
        # Git prompt
        source /usr/share/git-core/contrib/completion/git-prompt.sh
    ;;
    'Darwin')
        export CLICOLOR=1
        export LSCOLORS=GxFxCxDxBxegedabagaced

        if [[ -d '/usr/local/etc/profile.d' ]]; then
            for f in /usr/local/etc/profile.d/*; do
                source $f;
            done
        fi

        if [[ -f '/usr/local/bin/aws_completer' ]]; then
            complete -C '/usr/local/bin/aws_completer' aws
        fi

        # Git prompt
        source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
    ;;
esac


PS1="\[$(tput setab 0)$(tput setaf 58)\]"
PS1=$PS1'$(__git_ps1 "%s|")'
PS1=$PS1"\[$(tput sgr0)\]"
PS1=$PS1'\u@\h:\w\$ '
export PS1

export LC_ALL='en_US.UTF-8'
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"
export EDITOR='vim -X'
export LESS='-inr'
export PAGER='/usr/bin/less'

# GPG agent
# both agent and its info must be present
if [[ ! $(pgrep gpg-agent) ]] || [[ ! -f $HOME/.gpg-agent-info ]]; then
    killall gpg-agent
    gpg-agent --daemon --write-env-file >/dev/null 2>&1
fi

source $HOME/.gpg-agent-info
export GPG_TTY=$(tty)
