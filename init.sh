#!/bin/bash

# enable strict bash mode
set -euo pipefail

# define some logging functions
info() {
    echo "====  INFO: $* ===============================================" 2>&1 \
        | cut -c-70
}

error() {
    echo "==== ERROR: $* ===============================================" 2>&1 \
        | cut -c-70
    exit 1
}

# get this script directory
mydir=$(cd $(dirname $0) && pwd)

# enable custom sudo prompt
export SUDO_PROMPT="[sudo] Please enter the password of user '%p':"

# bootstrap configuration environment
case $(uname -s) in
    'Darwin')
        info "installing latest software updates"
        sudo softwareupdate -i -a

        if ! xcode-select -p >/dev/null 2>&1; then
            info "installing 'XCode CLI Tools'"
            xcode-select --install
        fi
        if ! ansible --version >/dev/null 2>&1; then
            if ! pip -V >/dev/null 2>&1; then
                info "installing 'pip'"
                sudo easy_install pip
            fi
            info "installing 'ansible'"
            sudo pip install ansible
        fi
        ;;
    *)
        error "This platform is not supported yet"
        ;;
esac


info "running Ansible configuration playbook"
(
    cd $mydir/_init
    # check if sudo needs a password
    if sudo -n true; then
        ansible-playbook playbook.yml
    else
        ansible-playbook --ask-become-pass playbook.yml
    fi
)

