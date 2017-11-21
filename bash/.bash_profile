#
# .bash_profile
#

# source additional stuff {{{

## .bashrc
if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi

## OS-specific .bash_profile
if [[ -f ~/.bash_profile.$(uname -s) ]]; then
    source ~/.bash_profile.$(uname -s) 
fi

# }}}

# environment {{{
export LC_ALL='en_US.UTF-8'
export EDITOR='nvim'
export LESSOPEN='| highlight %s --quiet --force --line-numbers
    --out-format xterm256
    --style solarized-dark'
export LESS='-FiJmnruX'
export PAGER='less'
# }}}

# SSH and GPG agent {{{

## SSH agent
ssh-add -l >/dev/null 2>&1 \
|| ssh-add ~/.ssh/id_rsa

## GPG agent
if ! pgrep gpg-agent >/dev/null 2>&1; then
    # start up GPG agent
    gpg-agent --daemon >/dev/null 2>&1
    # trigger asking the passphrase
    echo 'test' | gpg --symmetric >/dev/null 2>&1
fi
export GPG_TTY=$(tty)

# import the private bash profile from pass
if pass version >/dev/null 2>&1 \
   && [[ -f .password-store/dotfiles/.bash_profile ]]; then
    eval $(pass show dotfiles/.bash_profile)
fi
# }}}

# bash prompt {{{

## git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    GIT_PROMPT_THEME=Custom
    GIT_PROMPT_THEME_FILE=~/dotfiles/tagir/.git-prompt-colors.sh
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
# }}}


# dirs {{{
function _dirs() {
    dirs -v | perl -ne '
        BEGIN {
            @cd = map {`tput setaf $_`} (255, 247, 244, 241, 238, 235);
        }
        next unless /^(\s+\d+)(\s+.+)$/;
        if ($. < $#cd) {
            print "$cd[$.-1]$1\t$2\n";
        }
        else {
            print "$cd[$#cn]$1\t$2\n";
        }
        system("tput sgr0");
    '
}
function _pushd() {
    (( $# == 1 )) && [[ -d "$1" ]] || { echo "Usage: + <directory>"; return 1; }
    pushd $1 >/dev/null 2>&1
    _dirs
}
function _rotate() {
    case $# in
        0) pushd +1 >/dev/null && _dirs ;;
        1) [[ $1 =~ ^-?[0-9]+$ ]] && pushd +$1 >/dev/null && _dirs ;;
        *) echo "Usage: r [0-9]"; return 1 ;;
    esac
}
alias d='_dirs'
alias r='_rotate'
alias +='_pushd '
alias -- -='popd >/dev/null && _dirs'
# }}}

# yaml {{{
function _y() {
    /usr/bin/env python -c '
import sys, yaml
print(yaml.load(sys.stdin))
'
}

function _y2j() {
    /usr/bin/env python -c '
import sys, yaml, json
json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'
}
# }}}

