#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
        echo "I'm a Mac!"
            # Do something under Mac OS X platform        
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

        # Do something under GNU/Linux platform

        # Install or update vim & tmux dependencies
        # Requires some sudo action
        sudo apt-get update
        sudo apt-get install -y vim tmux

else 
        echo "what OS are you using?"

fi





source ~/.dotfiles/bin/link.sh


