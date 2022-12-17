-- boostrap packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


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
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- lsp
  use {
       'nvim-treesitter/nvim-treesitter',
       run = function()
       local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
       ts_update()
       end,
  }
  use 'williamboman/mason.nvim'
  use "williamboman/mason-lspconfig.nvim"
  use 'neovim/nvim-lspconfig'
  use 'jose-elias-alvarez/null-ls.nvim'
  -- completion
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-cmdline'
  -- completion for LSP
  use("hrsh7th/cmp-nvim-lsp")

  -- snippets
  use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})
  use "saadparwaiz1/cmp_luasnip"


  if packer_bootstrap then
    require('packer').sync()
  end
end)

