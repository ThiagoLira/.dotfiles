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
        -- fuzzy finder
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope.nvim',
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
                end,
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- lsp
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

                                highlight = {
                                        -- `false` will disable the whole extension
                                        enable = true,

                                },
                        }
                end
        },
        { 'williamboman/mason.nvim',
                config = function()
                        -- enable mason
                        require('mason').setup()

                end
        },
        { "williamboman/mason-lspconfig.nvim",
                dependencies = { 'mason.nvim' },
                config = function()
                        require('mason-lspconfig').setup({
                                -- list of servers for mason to install
                                ensure_installed = {
                                        "tsserver",
                                        "pylsp",
                                        "rust_analyzer",
                                        "sumneko_lua",
                                },
                                -- auto-install configured servers (with lspconfig)
                                automatic_installation = true, -- not the same as ensure_installed
                        })
                end
        },
        { 'neovim/nvim-lspconfig',
                dependencies = { 'nvim-cmp', 'mason.nvim', "mason-lspconfig.nvim", "cmp-nvim-lsp" },
                init = function()

                        local opts = { noremap = true, silent = true }
                        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
                        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
                end,
                config = function()

                        -- Mappings.
                        -- See `:help vim.diagnostic.*` for documentation on any of the below functions

                        -- Use an on_attach function to only map the following keys
                        -- after the language server attaches to the current buffer
                        local on_attach = function(client, bufnr)
                                -- Enable completion triggered by <c-x><c-o>
                                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                                -- Mappings.
                                -- See `:help vim.lsp.*` for documentation on any of the below functions
                                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                                vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                                vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                                vim.keymap.set('n', '<leader>wl', function()
                                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                                end, bufopts)
                                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
                                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                                vim.keymap.set('n', '<leader>cf', vim.lsp.buf.formatting, bufopts)
                        end

                        local cmp = require 'cmp'

                        cmp.setup({
                                snippet = {
                                        expand = function(args)
                                                vim.fn["vsnip#anonymous"](args.body)
                                        end,
                                },
                                window = {
                                        completion = cmp.config.window.bordered(),
                                        documentation = cmp.config.window.bordered(),
                                },
                                mapping = cmp.mapping.preset.insert({
                                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                                        ['<C-Space>'] = cmp.mapping.complete(),
                                        ['<C-e>'] = cmp.mapping.abort(),
                                        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                                }),
                                sources = cmp.config.sources({
                                        { name = 'nvim_lsp' },
                                        { name = 'vsnip' }, -- For vsnip users.
                                }, {
                                        { name = 'buffer' },
                                })
                        })


                        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
                        cmp.setup.cmdline({ '/', '?' }, {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = {
                                        { name = 'buffer' }
                                }
                        })


                        require("mason").setup()
                        require("mason-lspconfig").setup()

                        local capabilities = require('cmp_nvim_lsp').default_capabilities()
                        require 'lspconfig'.pylsp.setup { on_attach = on_attach, capabilities = capabilities }
                        require 'lspconfig'.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities }
                        require 'lspconfig'.tsserver.setup { on_attach = on_attach, capabilities = capabilities }
                        require 'lspconfig'.sumneko_lua.setup { on_attach = on_attach, capabilities = capabilities,
                                -- add vim variable to globals
                                settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
                end

        },
        { 'jose-elias-alvarez/null-ls.nvim',

                config = function()

                        local null_ls = require("null-ls")

                        null_ls.setup({
                                sources = {
                                        null_ls.builtins.formatting.black
                                },
                        })


                end
        },
        -- completion
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        { 'hrsh7th/nvim-cmp',
                dependencies = { 'LuaSnip', 'lspkind.nvim' },
                config = function()
                        local lspkind = require('lspkind')
                        -- import nvim-cmp plugin safely
                        local cmp_status, cmp = pcall(require, "cmp")
                        if not cmp_status then
                                return
                        end

                        -- import luasnip plugin safely
                        local luasnip_status, luasnip = pcall(require, "luasnip")
                        if not luasnip_status then
                                return
                        end

                        -- super-tab like
                        local has_words_before = function()
                                unpack = unpack or table.unpack
                                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                                return col ~= 0 and
                                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
                                    nil
                        end


                        vim.opt.completeopt = "menu,menuone,noselect"

                        cmp.setup({
                                snippet = {
                                        expand = function(args)
                                                luasnip.lsp_expand(args.body)
                                        end,
                                },
                                mapping = cmp.mapping.preset.insert({
                                        ['<C-p>'] = cmp.mapping.select_prev_item(),
                                        ['<C-n>'] = cmp.mapping.select_next_item(),
                                        ['<TAB>'] = cmp.mapping(function(fallback)
                                                if cmp.visible() then
                                                        cmp.select_next_item()
                                                elseif luasnip.expand_or_jumpable() then
                                                        luasnip.expand_or_jump()
                                                elseif has_words_before() then
                                                        cmp.complete()
                                                else
                                                        fallback()
                                                end
                                        end, { "i", "s" }),

                                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                                                if cmp.visible() then
                                                        cmp.select_prev_item()
                                                elseif luasnip.jumpable(-1) then
                                                        luasnip.jump(-1)
                                                else
                                                        fallback()
                                                end
                                        end, { "i", "s" }),

                                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                                        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                                }),
                                -- sources for autocompletion
                                sources = cmp.config.sources({
                                        { name = "nvim_lsp" }, -- lsp
                                        { name = "buffer" }, -- text within current buffer
                                        { name = "path" }, -- file system paths
                                }),
                                -- configure lspkind for vs-code like icons
                                formatting = {
                                        format = lspkind.cmp_format({
                                                maxwidth = 50,
                                                ellipsis_char = "...",
                                        }),
                                },
                        })
                end
        },
        'hrsh7th/cmp-cmdline',
        -- completion for LSP
        "hrsh7th/cmp-nvim-lsp",
        -- vscode like icons
        "onsails/lspkind.nvim",
        -- snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
})
