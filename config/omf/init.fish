set -gx PATH  ~/.dotfiles/bin  $PATH

function mkd
	mkdir -p $argv; and cd $argv
end
