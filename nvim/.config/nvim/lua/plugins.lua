local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' 
  -- lisp
  use 'Olical/aniseed'
  use 'bakpakin/fennel'
  use 'Olical/conjure'
  -- theme
  use 'tomasr/molokai'
  -- fuzzy finder
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzf-native.nvim'
  -- lsp
  use 'williamboman/mason.nvim'
  use "williamboman/mason-lspconfig.nvim"
  use 'neovim/nvim-lspconfig' 
  use 'jose-elias-alvarez/null-ls.nvim'
  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
 
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'


  if packer_bootstrap then
    require('packer').sync()
  end
end)

