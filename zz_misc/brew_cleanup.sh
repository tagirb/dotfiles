#!/bin/bash

for f in $(brew list); do
    if [[ -z $(brew uses --installed $f) ]]; then
        read -p "Formula '$f' is not used by anyone. Remove? [y/n]" input
        if [ "$input" == 'y' ]; then
            brew remove $f
        fi
    fi
done

brew cleanup
