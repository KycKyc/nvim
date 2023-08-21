return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		opts = function()
			local lga_actions = require("telescope-live-grep-args.actions")
			return {
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--no-config",
						"--color=never",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"-g=!.git",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					live_grep_args = {
						auto_quoting = true,
						mappings = { -- extend mappings
							i = {
								["<a-k>"] = lga_actions.quote_prompt(),
								["<a-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
					},
				},
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					},
					buffers = {
						mappings = {
							i = {
								["<c-r>"] = require("telescope.actions").delete_buffer
									+ require("telescope.actions").move_to_top,
								["<CR>"] = require("telescope.actions").select_default
									+ require("telescope.actions").center,
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local builtin = require("telescope.builtin")
			local utils = require("telescope.utils")
			-- local actions = require("telescope.actions")

			require("telescope").setup(opts)

			local document_diagnostics = function()
				builtin.diagnostics({ bufnr = 0 })
			end

			vim.keymap.set(
				"n",
				"<leader>fg",
				":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
			)
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fr", builtin.git_files, {})
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {})
			vim.keymap.set("n", "<leader>fd", document_diagnostics)
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({ cwd = utils.buffer_dir() })
			end, { desc = "Find files in cwd" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},
}
