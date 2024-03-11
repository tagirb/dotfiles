# when completing from the middle of a word, move the cursor to the end of the
# word
setopt always_to_end
# show completion menu on successive tab press. needs unsetop menu_complete to
# work
setopt auto_menu
# any parameter that is set to the absolute name of a directory immediately
# becomes a name for that directory
setopt auto_name_dirs
# allow completion from within a word/phrase
setopt complete_in_word
# complete as much of a completion until it gets ambiguous
setopt list_ambiguous
# do not autoselect the first completion entry
unsetopt menu_complete

# local completions
fpath=( "$XDG_CONFIG_HOME/zsh/completion" $fpath )

zmodload zsh/complist
autoload -Uz compinit
autoload -Uz bashcompinit
bashcompinit
compinit -d "$XDG_DATA_HOME/zsh/zcompdump"

# completion settings as per zshcompsys(1)
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_DATA_HOME/zsh/completion"

# use menu selection
zstyle ':completion:*' menu select
# completer control functions to use
zstyle ':completion:*' completer _complete _match

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# additional completions
complete -C /usr/bin/terraform terraform
compdef tf=terraform

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

