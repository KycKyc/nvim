return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-refactor",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end,
				config = function()
					require("nvim-treesitter-textobjects").init()
				end,
			},
		},
		cmd = { "TSUpdateSync" },
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			-- A list of parser names, or "all"
			ensure_installed = {
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"go",
				"dockerfile",
				"json",
				"gomod",
				"gosum",
				"scss",
				"css",
				"bash",
				"gitignore",
				"ini",
				"make",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				disable = function(lang, bufnr) -- Disable in large JSON buffers
					return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 50000
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			matchup = {
				enable = true, -- mandatory, false will disable the whole extension
				-- disable = { "json" }, -- optional, list of language that will be disabled
				disable = function(lang, bufnr) -- Disable in large JSON buffers
					return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 50000
				end,
				-- [options]
			},

			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},

			-- indent = { enable = true },

			autotag = {
				enable = true,
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ak"] = "@block.outer",
						["ik"] = "@block.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["a?"] = "@conditional.outer",
						["i?"] = "@conditional.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						-- ["]k"] = { query = "@block.outer", desc = "Next block start" },
						-- ["]f"] = { query = "@function.outer", desc = "Next function start" },
						-- ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
					},
					goto_next_end = {
						-- ["]K"] = { query = "@block.outer", desc = "Next block end" },
						-- ["]F"] = { query = "@function.outer", desc = "Next function end" },
						-- ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
					},
					goto_previous_start = {
						-- ["[k"] = { query = "@block.outer", desc = "Previous block start" },
						-- ["[f"] = { query = "@function.outer", desc = "Previous function start" },
						-- ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
					},
					goto_previous_end = {
						-- ["[K"] = { query = "@block.outer", desc = "Previous block end" },
						-- ["[F"] = { query = "@function.outer", desc = "Previous function end" },
						-- ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">K"] = { query = "@block.outer", desc = "Swap next block" },
						[">F"] = { query = "@function.outer", desc = "Swap next function" },
						[">A"] = { query = "@parameter.inner", desc = "Swap next parameter" },
					},
					swap_previous = {
						["<K"] = { query = "@block.outer", desc = "Swap previous block" },
						["<F"] = { query = "@function.outer", desc = "Swap previous function" },
						["<A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
					},
				},
			},

			refactor = {
				highlight_definitions = {
					enable = true,
					disable = function(lang, bufnr) -- Disable in large JSON buffers
						return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 50000
					end,
				},
				smart_rename = {
					enable = true,
					keymaps = {
						smart_rename = "grr",
					},
				},
				navigation = {
					enable = true,
					keymaps = {
						goto_definition = "gnd",
						list_definitions = "gnD",
						list_definitions_toc = "gO",
						goto_next_usage = false,
						goto_previous_usage = false,
					},
				},
			},
		},
		init = function() end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			local refactor = require("nvim-treesitter-refactor.navigation")
			local ts_move = require("nvim-treesitter.textobjects.move")

			-- Setup custom keybindings for navigation
			vim.keymap.set({ "n", "x" }, "<a-n>", function()
				refactor.goto_next_usage()
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "<a-b>", function()
				refactor.goto_previous_usage()
				vim.cmd.normal("zzzv")
			end)

			-- Goto next start
			vim.keymap.set({ "n", "x" }, "]k", function()
				ts_move.goto_next_start("@block.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "]f", function()
				ts_move.goto_next_start("@function.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "]a", function()
				ts_move.goto_next_start("@parameter.inner", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			-- Goto previous start
			vim.keymap.set({ "n", "x" }, "[k", function()
				ts_move.goto_previous_start("@block.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "[f", function()
				ts_move.goto_previous_start("@function.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "[a", function()
				ts_move.goto_previous_start("@parameter.inner", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			-- Goto next end
			vim.keymap.set({ "n", "x" }, "]K", function()
				ts_move.goto_next_end("@block.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "]F", function()
				ts_move.goto_next_end("@function.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "]A", function()
				ts_move.goto_next_end("@parameter.inner", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			-- Goto previous end
			vim.keymap.set({ "n", "x" }, "[K", function()
				ts_move.goto_previous_end("@block.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "[F", function()
				ts_move.goto_previous_end("@function.outer", "textobjects")
				vim.cmd.normal("zzzv")
			end)

			vim.keymap.set({ "n", "x" }, "[A", function()
				ts_move.goto_previous_end("@parameter.inner", "textobjects")
				vim.cmd.normal("zzzv")
			end)
		end,
	},
}
