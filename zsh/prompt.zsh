# enable parameter expansion, command substitution and arithmetic expansion
setopt prompt_subst

autoload -Uz promptinit
promptinit

#export PROMPT='%B%F{red}%(?..[%?])%f%b%n@%U%m%u> '
#export PROMPT='%B%F{red}%(?..[%?])%f%b> '
export PROMPT='$(PROMPT)'
export RPROMPT='$(RPROMPT)'

PROMPT() {
    # show relative path in a Git repo
    path=$(git rev-parse --show-prefix 2>/dev/null)
    if (( $? )); then
        echo '%B%F{red}%(?..[%?])%f%b> '
    else
        [[ -n "$path" ]] || path='.'
        echo "%B%F{red}%(?..[%?])%F{blue}${path%/}%f>%b "
    fi
}
RPROMPT() {
    # when not in Git repo
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) != 'true' ]]; then
        echo '%F{green}%~%f'
        return 0
    fi

    # when in Git repo
    # RPROMPT: action stash worktree index remote master core 
    local rprompt='%B'

    local info=$(git rev-parse --git-dir 2>/dev/null)
    local name=$(basename $(dirname $info:A))

    # action
    local action=$(_rprompt_git_action $info)
    [[ -n "$action" ]] && rprompt+="%F{red}%{\x1b[3m%}$action%{\x1b[0m%}"
    
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
    rprompt+="%F{black}%K{yellow} $branch "

    # name
    rprompt+="%K{blue} $name %k%f%b"

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
    [[ -n $ahead ]] && (( $ahead )) && rm+="%F{blue}↥${ahead}"
    [[ -n $behind ]] && (( $behind )) && rm+="%F{red}↧${behind}"

    echo $rm
}

