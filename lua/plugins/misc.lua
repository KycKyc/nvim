return {
	{ "tpope/vim-surround" },
    {
		"numToStr/Comment.nvim",
		opts = {
			-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		},
        dependencies = {
            {'JoosepAlviste/nvim-ts-context-commentstring'},
        },
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{
		"petertriho/nvim-scrollbar",
		opts = {
			handlers = {
				gitsigns = true,
			},
        },
        dependencies = {"lewis6991/gitsigns.nvim"}
    },
	{
		"cappyzawa/trim.nvim",
		opts = {
			trim_on_write = true,
			trim_trailing = true,
			trim_last_line = false,
			trim_first_line = false,
		},
	},
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({})

			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

			vim.keymap.set("n", "<leader>1", function()
				ui.nav_file(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				ui.nav_file(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				ui.nav_file(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				ui.nav_file(4)
			end)
		end,
	},
	{
		"andymass/vim-matchup",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	-- Change UI to be a bit more pleasing
	{ "stevearc/dressing.nvim" },
	{ "b0o/schemastore.nvim" },

	-- Automatically generate comment blocks
	{
		"danymat/neogen",
		init = function()
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
		end,
	},
	{ "github/copilot.vim" },

	-- Pin buffers in certain position
	{ "stevearc/stickybuf.nvim", config = function()
        require("stickybuf").setup()
    end},
	{
		"jedrzejboczar/possession.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			commands = {
				save = "SSave",
				load = "SLoad",
				delete = "SDelete",
				list = "SList",
			},
		},
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	},
}
