vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() vim.highlight.on_yank() end })

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	'github/copilot.vim',
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			local builtin = require 'telescope.builtin'
			local utils = require 'telescope.utils'
			vim.keymap.set('n', '<leader>sd', function() builtin.find_files { cwd = utils.buffer_dir() } end,
				{ desc = '[S]earch in [D]irectory' })
			vim.keymap.set('n', '<leader>sf', function() builtin.find_files { hidden = true } end,
				{ desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sF', function() builtin.find_files { no_ignore = true } end,
				{ desc = '[S]earch [F]iles All' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		end,
	},
	{ -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#-installation
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		config = function()
			local harpoon = require 'harpoon'
			vim.keymap.set('n', '<leader>a', function()
				harpoon:list():add()
			end)
			vim.keymap.set('n', '<C-m>', function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set('n', '<C-a>', function()
				harpoon:list():select(1)
			end)
			vim.keymap.set('n', '<C-s>', function()
				harpoon:list():select(2)
			end)
			vim.keymap.set('n', '<C-e>', function()
				harpoon:list():select(3)
			end)
			vim.keymap.set('n', '<C-f>', function()
				harpoon:list():select(4)
			end)
			vim.keymap.set('n', '<C-j>', function()
				harpoon:list():select(5)
			end)
			vim.keymap.set('n', '<C-k>', function()
				harpoon:list():select(6)
			end)
		end,
	},
	{
		'folke/tokyonight.nvim',
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme 'tokyonight-night'
		end,

		-- https://www.reddit.com/r/neovim/comments/1h4wpst/how_can_i_change_my_neovim_kickstart_color_scheme/
		config = function()
			require('tokyonight').setup {
				transparent = true,
				on_colors = function(colors)
					colors.bg = '#000000'
				end,
				on_highlights = function() end,
			}
		end,
	},
})
