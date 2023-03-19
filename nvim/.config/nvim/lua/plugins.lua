-- boostrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        'Olical/aniseed',
        'bakpakin/fennel',
        'Olical/conjure',
        -- theme
        'tomasr/molokai',
        -- status line
        {
                'nvim-lualine/lualine.nvim',
                config = function()
                        require('lualine').setup {
                                options = {
                                        icons_enabled = false,
                                        theme = 'onedark',
                                        component_separators = '|',
                                        section_separators = '',
                                },
                        }
                end,
        },
        -- terminal
        {
                'akinsho/toggleterm.nvim',
                config = function()
                        require("toggleterm").setup {
                                size = 13,
                                open_mapping = [[<leader>tt]]
                        }
                end
        },
        -- fuzzy finder
        'nvim-lua/plenary.nvim',
        {
                'nvim-telescope/telescope.nvim',
                config = function()
                        require('telescope').load_extension('fzf')
                end,
                init = function()
                        local builtin = require('telescope.builtin')
                        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
                        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
                        vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
                        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
                        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                        vim.keymap.set('n', '<leader>?', builtin.oldfiles, {})
                        vim.keymap.set('n', '<leader><space>', builtin.buffers, {})
                end,
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- lsp
        {
                'nvim-treesitter/nvim-treesitter-textobjects',
                dependencies = { 'nvim-treesitter/nvim-treesitter' }
        },
        {
                'nvim-treesitter/nvim-treesitter',
                run = function()
                        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                        ts_update()
                end,
                config = function()
                        require 'nvim-treesitter.configs'.setup {
                                -- A list of parser names, or "all"
                                ensure_installed = { "python", "lua", "javascript", "vim", "typescript" },

                                -- Install parsers synchronously (only applied to `ensure_installed`)
                                sync_install = false,

                                highlight = { enable = true },
                                indent = { enable = true, disable = { 'python' } },
                                incremental_selection = {
                                        enable = true,
                                        keymaps = {
                                                init_selection = '<c-space>',
                                                node_incremental = '<c-space>',
                                                scope_incremental = '<c-s>',
                                                node_decremental = '<c-backspace>',
                                        },
                                },
                                textobjects = {
                                        select = {
                                                enable = true,
                                                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                                                keymaps = {
                                                        -- You can use the capture groups defined in textobjects.scm
                                                        ['aa'] = '@parameter.outer',
                                                        ['ia'] = '@parameter.inner',
                                                        ['af'] = '@function.outer',
                                                        ['if'] = '@function.inner',
                                                        ['ac'] = '@class.outer',
                                                        ['ic'] = '@class.inner',
                                                },
                                        },
                                        move = {
                                                enable = true,
                                                set_jumps = true, -- whether to set jumps in the jumplist
                                                goto_next_start = {
                                                        [']m'] = '@function.outer',
                                                        [']]'] = '@class.outer',
                                                },
                                                goto_next_end = {
                                                        [']M'] = '@function.outer',
                                                        [']['] = '@class.outer',
                                                },
                                                goto_previous_start = {
                                                        ['[m'] = '@function.outer',
                                                        ['[['] = '@class.outer',
                                                },
                                                goto_previous_end = {
                                                        ['[M'] = '@function.outer',
                                                        ['[]'] = '@class.outer',
                                                },
                                        },
                                        swap = {
                                                enable = true,
                                                swap_next = {
                                                        ['<leader>a'] = '@parameter.inner',
                                                },
                                                swap_previous = {
                                                        ['<leader>A'] = '@parameter.inner',
                                                },
                                        },
                                },
                        }
                end
        },
        {
                'VonHeikemen/lsp-zero.nvim',
                branch       = 'v2.x',
                dependencies = {
                        -- LSP Support
                        { 'neovim/nvim-lspconfig' },             -- Required
                        { 'williamboman/mason.nvim' },           -- Optional
                        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

                        -- Autocompletion
                        { 'hrsh7th/nvim-cmp' },     -- Required
                        { 'hrsh7th/cmp-nvim-lsp' }, -- Required
                        { 'hrsh7th/cmp-buffer' },   -- Optional
                        { 'hrsh7th/cmp-path' },     -- Optional
                        { 'hrsh7th/cmp-nvim-lua' }, -- Optional
                        {
                                "L3MON4D3/LuaSnip",
                                version = "<CurrentMajor>.*"
                        },
                        -- Snippets
                        { 'rafamadriz/friendly-snippets' }, -- Optional
                },
                config       = function()
                        local lsp = require('lsp-zero').preset({
                                name = 'recommended',
                                set_lsp_keymaps = true,
                                manage_nvim_cmp = true,
                                suggest_lsp_servers = false,
                        })

                        lsp.on_attach(function(client, bufnr)
                                lsp.default_keymaps({ buffer = bufnr })
                        end)

                        lsp.ensure_installed({
                                'tsserver',
                                'rust_analyzer',
                                'pyright',
                                'lua_ls'
                        })

                        -- (Optional) Configure lua language server for neovim
                        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

                        lsp.setup()
                end
        },
        {
                'jose-elias-alvarez/null-ls.nvim',
                config = function()
                        local null_ls = require("null-ls")

                        null_ls.setup({
                                sources = {
                                        null_ls.builtins.formatting.black
                                },
                        })
                end
        },
        {
                "folke/neodev.nvim",
                config = function()
                        require('neodev').setup()
                end
        }
})
--REMAPS
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- better use of <Space> leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- open dotfile location
vim.keymap.set('n', '<leader>df', function() vim.cmd('Ntree ' .. os.getenv('HOME') .. '/.config/nvim') end, {})
