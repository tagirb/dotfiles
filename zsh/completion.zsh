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

_has_command() {
	(( $+commands[$1] ))
}

# paths to local completions
fpath=(
	"$XDG_CONFIG_HOME/zsh/completion"
	$fpath
)

if [[ -n ${HOMEBREW_PREFIX:-} && -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
	fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# init completion
zmodload zsh/complist
autoload -Uz compinit

zcompdump_path="$XDG_DATA_HOME/zsh/zcompdump"
if [[ -f "$zcompdump_path" ]]; then
	compinit -C -d "$zcompdump_path"
else
	compinit -d "$zcompdump_path"
fi

# configure completion
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_DATA_HOME/zsh/completion"
# use menu selection
zstyle ':completion:*' menu select=long interactive
# use verbose style
zstyle ':completion:*' verbose yes
# group completions by their type
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# completer control functions to use
zstyle ':completion:*' completer _complete _match

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# additional completions

# terraform
if _has_command terraform; then
	autoload -Uz bashcompinit
	bashcompinit
	complete -o nospace -C "${commands[terraform]}" terraform
fi

# fzf
_has_command fzf && source <(fzf --zsh)

# python
_has_command uv && eval "$(uv generate-shell-completion zsh 2>/dev/null)"
_has_command uvx && eval "$(uvx --generate-shell-completion zsh 2>/dev/null)"

# zoxide
_has_command zoxide && eval "$(zoxide init zsh)"

# bun
[ -s "/Users/tagir.bakirov/.bun/_bun" ] && source "/Users/tagir.bakirov/.bun/_bun"
