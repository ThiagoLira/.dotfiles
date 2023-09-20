--  set  leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- require plugins
require('plugins')

-- [[ Options ]]
-- See `:help vim.o`
-- Set highlight on search

vim.o.hlsearch = false

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true


-- [[  REMAPS   ]]
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- better use of <Space> leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- open dotfile location
vim.keymap.set('n', '<leader>df', function() vim.cmd('Ntree ' .. os.getenv('HOME') .. '/.config/nvim') end, {})
--  switch between last two files
vim.keymap.set('n', '<leader><tab>',  '<C-^>' )
--  split  panes
vim.keymap.set('n', '<leader>ws',  function() vim.cmd('split') end)
vim.keymap.set('n', '<leader>wv',  function() vim.cmd('vsplit') end)
--  walk on  splits
vim.keymap.set('n', '<c-j>',  '<c-w>j' )
vim.keymap.set('n', '<c-k>',  '<c-w>k' )
vim.keymap.set('n', '<c-l>',  '<c-w>l' )
vim.keymap.set('n', '<c-h>',  '<c-w>h' )
-- term mode configuration
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
