# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst
# only show the rprompt on the current prompt
setopt transient_rprompt

zmodload zsh/datetime

autoload -Uz promptinit
promptinit

if [[ $TERM_PROGRAM == 'vscode' ]]; then
  PROMPT='%~$ '
  RPROMPT=''
else
    export PROMPT='$(PROMPT)'
    export RPROMPT='$(RPROMPT)'
fi

typeset -gi _prompt_git_cache_ms=1000
typeset -gi _prompt_git_fast_mode=${PROMPT_GIT_FAST_MODE:-1}
typeset -gi _prompt_git_last_refresh=0
typeset -g _prompt_git_last_pwd=''
typeset -g _prompt_git_in_repo='0'
typeset -g _prompt_git_prefix=''
typeset -g _prompt_git_action=''
typeset -g _prompt_git_stash=''
typeset -g _prompt_git_status=''
typeset -g _prompt_git_remote=''
typeset -g _prompt_git_branch=''
typeset -g _prompt_git_repo_name=''

_prompt_refresh_git_cache() {
    local now_ms=$(( EPOCHREALTIME * 1000 ))

    if [[ $PWD == $_prompt_git_last_pwd ]] && (( now_ms - _prompt_git_last_refresh < _prompt_git_cache_ms )); then
        return
    fi

    _prompt_git_last_pwd=$PWD
    _prompt_git_last_refresh=$now_ms

    _prompt_git_in_repo='0'
    _prompt_git_prefix=''
    _prompt_git_action=''
    _prompt_git_stash=''
    _prompt_git_status=''
    _prompt_git_remote=''
    _prompt_git_branch=''
    _prompt_git_repo_name=''

    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null) || return

    _prompt_git_in_repo='1'

    if [[ $PWD == $root ]]; then
        _prompt_git_prefix=''
    else
        _prompt_git_prefix=${PWD#$root/}
    fi

    local info
    info=$(git rev-parse --git-dir 2>/dev/null) || return

    _prompt_git_action=$(_rprompt_git_action "$info")

    if [[ -f $info/refs/stash || -f $info/logs/refs/stash ]]; then
        _prompt_git_stash='%F{226}⭑'
    fi

    local -a git_status_args
    git_status_args=(--porcelain=2 --branch)
    # Fast mode skips untracked files, which are often the most expensive part.
    (( _prompt_git_fast_mode )) && git_status_args+=(--untracked-files=no)

    local status_out
    status_out=$(git status $git_status_args 2>/dev/null) || return

    local has_upstream=0
    local ahead=0
    local behind=0
    local idx_add=''
    local idx_mod=''
    local idx_del=''
    local wt_mod=''
    local wt_del=''
    local wt_untracked=''

    local line
    while IFS= read -r line; do
        case "$line" in
            '# branch.head '*)
                _prompt_git_branch=${line#'# branch.head '}
                ;;
            '# branch.upstream '*)
                has_upstream=1
                ;;
            '# branch.ab '*)
                local ab=${line#'# branch.ab '}
                local a=${ab%% *}
                local b=${ab##* }
                ahead=${a#+}
                behind=${b#-}
                ;;
            \?\ *)
                wt_untracked='%F{cyan}?'
                ;;
            [12u]' '*)
                local xy=${line[3,4]}
                local x=${xy[1,1]}
                local y=${xy[2,2]}

                case "$x" in
                    A) idx_add='+' ;;
                    C|M|R) idx_mod='*' ;;
                    D) idx_del='-' ;;
                esac

                case "$y" in
                    M) wt_mod='%F{green}*' ;;
                    D) wt_del='%F{red}-' ;;
                esac
                ;;
        esac
    done <<< "$status_out"

    if [[ $_prompt_git_branch == '(detached)' || -z $_prompt_git_branch ]]; then
        _prompt_git_branch='Ø'
    fi

    local gst=''
    if [[ -n $wt_mod$wt_del$wt_untracked ]]; then
        if [[ -n $idx_add$idx_mod$idx_del ]]; then
            gst+=' '
        fi
        gst+=" ${wt_mod}${wt_del}${wt_untracked} "
    fi
    if [[ -n $idx_add$idx_mod$idx_del ]]; then
        gst+="%K{059} %F{yellow}${idx_add}${idx_mod}${idx_del} "
    fi
    _prompt_git_status=$gst

    if (( !has_upstream )); then
        _prompt_git_remote='○'
    else
        local remote=''
        (( ahead > 0 )) && remote+="%F{4}↥${ahead}"
        (( behind > 0 )) && remote+="%F{1}↧${behind}"
        _prompt_git_remote=$remote
    fi

    if [[ $root == $HOME/w/* ]]; then
        _prompt_git_repo_name=${root#$HOME/w/}
    elif [[ $root == $HOME/* ]]; then
        _prompt_git_repo_name="~/${root#$HOME/}"
    else
        _prompt_git_repo_name=$root
    fi
}

PROMPT() {
    _prompt_refresh_git_cache
    if [[ $_prompt_git_in_repo != '1' ]]; then
        echo '%B%F{1}%(?..[%?])%f%F{4}%~%f%F{243}$%f%b '
    else
        # show relative path in a Git repo
        echo "%B%F{1}%(?..[%?])%F{3}⑃%F{4}/${_prompt_git_prefix%/}%f%F{243}$%f%b "
    fi
}
RPROMPT() {
    _prompt_refresh_git_cache

    # when in Git repo
    if [[ $_prompt_git_in_repo == '1' ]]; then
        # RPROMPT: action stash worktree index remote master core/main
        local rprompt='%B'

        [[ -n $_prompt_git_action ]] && rprompt+="%F{1}%{\x1b[3m%}${_prompt_git_action}%{\x1b[0m%}"
        [[ -n $_prompt_git_stash ]] && rprompt+="${_prompt_git_stash}"
        [[ -n $_prompt_git_status ]] && rprompt+="${_prompt_git_status}"
        [[ -n $_prompt_git_remote ]] && rprompt+="%K{239} ${_prompt_git_remote} "
        rprompt+="%F{234}%K{3} ${_prompt_git_branch} "
        rprompt+="%F{253}%K{22} ${_prompt_git_repo_name} %k%f%b"

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
