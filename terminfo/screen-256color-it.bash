#!/bin/bash -eu
#
# Screen with italics support
#

terminfo="$HOME/dotfiles/.terminfo"
tmp_file="$(mktemp $(basename $0.XXXXXX))"

[[ -d "$terminfo" ]] \
|| mkdir "$terminfo"

infocmp 'screen-256color' \
| sed -e '
    s/^screen[^|]*|[^,]*,/screen-256color-it|screen-256-color with italics support,/
    s/%?%p1%t;3%/%?%p1%t;7%/
    s/smso=[^,]*,/smso=\\E[7m,/
    s/rmso=[^,]*,/rmso=\\E[27m,/
    $s/$/ sitm=\\E[3m, ritm=\\E[23m,/
' > "$tmp_file"

tic -o "$terminfo" "$tmp_file"

rm "$tmp_file"
