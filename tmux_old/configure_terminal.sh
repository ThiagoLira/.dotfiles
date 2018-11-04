echo "set-option -g default-shell "$(which fish)"" | cat - tmuxconf_pre > temp && mv temp tmux.conf.symlink

