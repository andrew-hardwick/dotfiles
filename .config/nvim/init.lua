vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.wo.number = true

local lazypath = vim.fn.stdpath('data') -- 'lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'nvim-tree/nvim-tree.lua',
	'nvim-tree/nvim-web-devicons',
	
	'tanvirtin/monokai.nvim',

	'neovim/nvim-lspconfig',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',

	'L3MON4D3/Luasnip',
	'saadparwaiz1/cmp_luasnip',

	'nvim-treesitter/nvim-treesitter',
	'nvim-telescope/telescope.nvim',

	'williamboman/mason.nvim',

	'christoomey/vim-tmux-navigator',
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		},
	},
})

require('monokai').setup { palette = require('monokai').pro }

require('nvim-tree').setup({
	sort_by = 'case_sensitive',
	view = {
		width = 30,
	},
	renderer = {
		add_trailing = true,
		group_empty = true,
		indent_markers = {
			enable = true,
			inline_arrows = false,
		},
	},
})

local cmp = require('cmp')

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
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
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})


require('lspconfig').clangd.setup{}
require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391', 'W191'},
          maxLineLength = 100
        }
      }
    }
  }
}

require('mason').setup()

 vim.api.nvim_create_autocmd("VimEnter", { callback = function() vim.cmd("NvimTreeOpen") end, })
