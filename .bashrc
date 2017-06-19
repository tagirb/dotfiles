# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
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

function _y() {
    /usr/bin/env python -c '
import yaml
print(yaml.load(sys.stdin))
'
}

function _y2j() {
    /usr/bin/env python -c '
import sys, yaml, json
json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'
}

alias d='_dirs'
alias r='_rotate'
alias +='_pushd '
alias -- -='popd >/dev/null && _dirs'

alias vi='vim -X'
alias vim='vim -X'
alias ll='ls -lF'
alias la='ls -laF'
alias ltr='ls -ltr'

alias psu='ps -fu $USER'

