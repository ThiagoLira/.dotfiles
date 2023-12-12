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
	{
		'rktjmp/hotpot.nvim',
		config = function()
			require('hotpot')
		end
	},
	'Olical/conjure',
	-- theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			vim.cmd.colorscheme "catppuccin"
		end,
	},
	-- gc to comment lines
	{ 'numToStr/Comment.nvim', opts = {} },
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
			}
			vim.keymap.set('n', '<leader>tt', function() vim.cmd('ToggleTerm') end)
		end
	},
	-- fuzzy finder
	'nvim-lua/plenary.nvim',
	'MunifTanjim/nui.nvim',
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
	{ 'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		-- check if we have make on our system
		cond = function()
			return vim.fn.executable 'make' == 1
		end, },
	-- lsp
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		dependencies = { 'nvim-treesitter/nvim-treesitter' }
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
		build = ":TSUpdate",
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
		branch       = 'v3.x',
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{ 'williamboman/mason.nvim' }, -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'hrsh7th/cmp-buffer' }, -- Optional
			{ 'hrsh7th/cmp-path' }, -- Optional
			{ 'hrsh7th/cmp-nvim-lua' }, -- Optional
			{
				"L3MON4D3/LuaSnip",
			},
			-- Snippets
			{ 'rafamadriz/friendly-snippets' }, -- Optional
		},
		config       = function()
			local lsp_zero = require('lsp-zero')

			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lsp_zero.on_attach(function(client, bufnr)
				-- K:  Displays hover information about the symbol under the cursor in a floating window.
				-- gd:  Jumps to the definition of the symbol under the cursor.
				-- gD:  Jumps to the declaration of the symbol under the cursor.
				-- gi:  Lists all the implementations for the symbol under the cursor in the quickfix window.
				-- go:  Jumps to the definition of the type of the symbol under the cursor.
				-- gr:  Lists all the references to the symbol under the cursor in the quickfix window.
				-- gs:  Displays signature information about the symbol under the cursor in a floating window.
				-- <F2>:  Renames all references to the symbol under the cursor.
				-- <F3>:  Format a buffer using the LSP servers attached to it.
				-- <F4>:  Selects a code action available at the current cursor position.
				-- gl: Show diagnostic in a floating window.
				-- [d:  Move to the previous diagnostic in the current buffer.
				-- ]d:  Move to the next diagnostic.
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'tsserver',
					'rust_analyzer',
					'pyright',
					'lua_ls'
				},
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require('lspconfig').lua_ls.setup(lua_opts)
					end,
				}
			})

			local cmp = require('cmp')
			local luasnip = require 'luasnip'
			require('luasnip.loaders.from_vscode').lazy_load()
			luasnip.config.setup {}
			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = 'menu,menuone,noinsert',
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs( -4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable( -1) then
							luasnip.jump( -1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			}
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
	},
	--chatGPT
	"dpayne/CodeGPT.nvim"
})
