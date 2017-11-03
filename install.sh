#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
        echo "I'm a Mac!"
            # Do something under Mac OS X platform        
            curl -L https://get.oh-my.fish | fish
            brew install z
            omf install z
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

        # Do something under GNU/Linux platform

        # Install or update vim & tmux dependencies
        # Requires some sudo action
        apt-get update
        apt-get install -y vim tmux curl

        #install oh my fish
        curl -L https://get.oh-my.fish | fish

else 
        echo "what OS are you using?"

fi





source ~/.dotfiles/bin/link.sh


