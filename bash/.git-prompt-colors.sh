override_git_prompt_colors() {
    GIT_PROMPT_THEME_NAME="Custom"

    GIT_PROMPT_START_USER="${Yellow}${PathShort}${DimWhite}"
    GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"

    GIT_PROMPT_LEADING_SPACE=0

    GIT_PROMPT_PREFIX="("

    GIT_PROMPT_BRANCH="${Magenta}"
    GIT_PROMPT_SYMBOLS_AHEAD="↥"
    GIT_PROMPT_SYMBOLS_BEHIND="↧"
    GIT_PROMPT_SYMBOLS_PREHASH=":"            # Written before hash of commit, if no name could be found
    GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="○" # This symbol is written after the branch, if the branch is not tracked 

    GIT_PROMPT_SEPARATOR="${DimWhite}|"

    GIT_PROMPT_STAGED="${Yellow}+"
    GIT_PROMPT_CONFLICTS="${Red}×"
    GIT_PROMPT_CHANGED="${BrightGreen}!"

#   GIT_PROMPT_REMOTE=" "                 # the remote branch name (if any) and the symbols for ahead and behind

    GIT_PROMPT_UNTRACKED="${Cyan}?"
    GIT_PROMPT_STASHED="${BoldMagenta}⚑"
    GIT_PROMPT_CLEAN="${BrightGreen}●"

    GIT_PROMPT_SUFFIX="${DimWhite})"

    GIT_PROMPT_END_USER="\$${ResetColor} "
    GIT_PROMPT_END_ROOT="#${ResetColor} "
}

reload_git_prompt_colors "Custom"
