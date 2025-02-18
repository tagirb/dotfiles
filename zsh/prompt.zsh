# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst
# only show the rprompt on the current prompt
setopt transient_rprompt

autoload -Uz promptinit
promptinit

#export PROMPT='%B%F{red}%(?..[%?])%f%b%n@%U%m%u> '
#export PROMPT='%B%F{red}%(?..[%?])%f%b> '
export PROMPT='$(PROMPT)'
export RPROMPT='$(RPROMPT)'

PROMPT() {
    path=$(git rev-parse --show-prefix 2>/dev/null)
    if (( $? )); then
        echo '%B%F{1}%(?..[%?])%f%F{4}%~%f%F{243}$%f%b '
    else
        # show relative path in a Git repo
        echo "%B%F{1}%(?..[%?])%F{3}⑃%F{4}/${path%/}%f%F{243}$%f%b "
    fi
}
RPROMPT() {
    # when in Git repo
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true' ]]; then
        # RPROMPT: action stash worktree index remote master core/main 
        local rprompt='%B'

        local info=$(git rev-parse --git-dir 2>/dev/null)

        # action
        local action=$(_rprompt_git_action $info)
        [[ -n "$action" ]] && rprompt+="%F{1}%{\x1b[3m%}$action%{\x1b[0m%}"
        
        # stash
        [[ -f $info/refs/stash || -f $info/logs/refs/stash ]] \
            && rprompt+='%F{226}⭑'

        # working tree + index
        local gst="$(git status --porcelain 2>/dev/null \
            | awk -f $ZDOTDIR/_git_status.awk -F '')"
        [[ -n "$gst" ]] && rprompt+="$gst"

        # remote
        local remote=$(_rprompt_git_remote)
        [[ -n "$remote" ]] && rprompt+="%K{239} $(_rprompt_git_remote) "

        # branch
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        [[ $branch == 'HEAD' ]] && branch='Ø'
        rprompt+="%F{234}%K{3} $branch "

        local root=${info:A:h}
        local name
        if [[ $root =~ ^$HOME\/r ]]; then
            # $HOME/git/path/to/repo => path/to/repo
            name=${root/$HOME\/r\//}
        elif [[ $root =~ ^$HOME ]]; then
            # $HOME/path/to/repo => ~/path/to/repo
            name=${root/$HOME/\~}
        else
            # absolute path to the repo
            name=$root
        fi
        rprompt+="%F{253}%K{22} $name %k%f%b"

    fi

    # show custom python if activated
    local python_version=$(pyenv version-name 2>/dev/null) 
    if (( $? == 0 )) && [[ $python_version != 'system' ]]; then
        rprompt+="%B%F{220}%K{30} $python_version %k%f%b"
    fi
    
    # print the rprompt
    echo $rprompt
}

_rprompt_git_action() {
    [[ -f "$1/rebase-merge/interactive" ]] && {echo 'rebase -i'; return;}
    [[ -d "$1/rebase-merge" ]] && {echo 'rebase -m'; return;}

    if [[ -d "$1/rebase-apply" ]]; then
        [[ -f "$1/rebase-apply/rebasing" ]] && {echo 'rebase'; return;}
        [[ -f "$1/rebase-apply/applying" ]] && {echo 'am'; return;}
        echo 'am/rebase'; return 0
    fi

    [[ -f "$1/MERGE_HEAD" ]] && {echo 'merge'; return;}
    [[ -f "$1/CHERRY_PICK_HEAD" ]] && {echo 'cherry-pick'; return;}
    [[ -f "$1/BISECT_LOG" ]] && {echo 'bisect'; return;}
}

_rprompt_git_remote() {
    local u=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    # no upstream
    if [[ -z $u || $u == '@{upstream}' ]]; then
        echo '○'
        return
    fi

    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)

    local rm
    [[ -n $ahead ]] && (( $ahead )) && rm+="%F{4}↥${ahead}"
    [[ -n $behind ]] && (( $behind )) && rm+="%F{1}↧${behind}"

    echo $rm
}

