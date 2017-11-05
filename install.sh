#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
        echo "I'm a Mac!"
            # Do something under Mac OS X platform        
            #fish is now default shell    
            chsh -s /usr/local/bin/fish
            
            curl -L https://get.oh-my.fish | fish

            brew install z
            omf install z
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

        # Do something under GNU/Linux platform

        # Install or update vim & tmux dependencies
        # Requires some sudo action
        apt-get update
        apt-get install -y vim tmux curl python3-neovim

        #install oh my fish
        curl -L https://get.oh-my.fish | fish
        omf install z
else 
        echo "what OS are you using?"

fi





source ~/.dotfiles/bin/link.sh

# now we run nvim and vim to install the plugins
nvim +PlugInstall +qall
vim +PlugInstall +qall
# compile youcompleteme
cd ~/.dotfiles/config/nvim/plugged/YouCompleteMe
./install.py
