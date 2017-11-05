            # Do something under Mac OS X platform        
            #fish is now default shell    
            chsh -s /usr/local/bin/fish
            
            curl -L https://get.oh-my.fish | fish

            brew install z
            omf install z
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
