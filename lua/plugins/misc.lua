return {
	{ "tpope/vim-surround" },
	{
		"numToStr/Comment.nvim",
		opts = {
			-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		},
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({})

			vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
			vim.keymap.set(
				"n",
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				{ silent = true, noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>xd",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				{ silent = true, noremap = true }
			)
			vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
			vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		opts = {
			handlers = {
				gitsigns = true,
			},
		},
		dependencies = { "lewis6991/gitsigns.nvim" },
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
	{
		"stevearc/stickybuf.nvim",
		config = function()
			require("stickybuf").setup()
		end,
	},
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
			local gt = require("goto-preview")

			vim.keymap.set("n", "gpd", gt.goto_preview_definition)
			vim.keymap.set("n", "gpt", gt.goto_preview_type_definition)
			vim.keymap.set("n", "gpi", gt.goto_preview_implementation)
			vim.keymap.set("n", "gP", gt.close_all_win)
			vim.keymap.set("n", "gpr", gt.goto_preview_references)
		end,
	},
}
