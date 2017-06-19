#!/bin/bash

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

#for fgbg in 38 48 ; do #Foreground/Background
for color in {0..256}; do #Colors
    # Display the color
    #        echo -en "\e[${fgbg};5;${color}m ${color}    \e[0m"
    echo -en "|$(tput setaf $color)${color}$(tput sgr0)|$(tput setab $color)${color}$(tput sgr0)|"
    # newline after 16 first colors
    (( color == 15 )) && echo
    # Display 6 colors per lines if color's above 15
    if (( color > 15 && (color + 3) % 6 == 0 )); then
        echo
    fi
done
echo
