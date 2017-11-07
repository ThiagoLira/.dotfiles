set -gx PATH  ~/.dotfiles/bin  $PATH

function mkd
	mkdir -p $argv; and cd $argv
end

set -x LC_ALL en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
