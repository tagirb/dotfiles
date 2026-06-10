# allow multiple terminal sessions to all append to one zsh command history
setopt append_history
# save timestamp of command and duration
setopt extended_history
# add comamnds as they are typed, don't wait until shell exit
setopt inc_append_history
# when trimming history, lose oldest duplicates first
setopt hist_expire_dups_first
# Do not write events to history that are duplicates of previous events
setopt hist_ignore_dups
# delete older duplicated entries and keep the newest one
setopt hist_ignore_all_dups
# remove command line from history list when first character on the line is
# a space
setopt hist_ignore_space
# When searching history don't display results already cycled through twice
setopt hist_find_no_dups
# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks
# don't execute, just expand history
setopt hist_verify

# imports new commands and appends typed commands to history.
# Set ZSH_SHARE_HISTORY=0 to disable if this causes latency in many terminals.
if [[ ${ZSH_SHARE_HISTORY:-1} == 1 ]]; then
	setopt share_history
else
	unsetopt share_history
fi

HISTFILE=~/.local/share/zsh/histfile
HISTSIZE=50000
SAVEHIST=50000
