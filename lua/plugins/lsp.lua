-- local lsp_formatting = function(bufnr)
-- 	vim.lsp.buf.format({
-- 		filter = function(client)
-- 			-- apply whatever logic you want (in this example, we'll only use null-ls)
-- 			return client.name == "null-ls"
-- 		end,
-- 		bufnr = bufnr,
-- 		async = false,
-- 	})
-- end

local formatBuf = function(_, write)
	local formatter = require("formatter.format")
	local end_line = vim.fn.line("$")

	formatter.format("", "", 1, end_line, { write = write })
end

local on_attach = function(client, bufnr)
	-- local attached = vim.fn.getbufvar(bufnr, "lsp_attached")
	-- if attached then
	-- 	print("Already attached to a client")
	-- 	return
	-- end
	-- vim.fn.setbufvar(bufnr, "lsp_attached", true)

	-- Ignore copilot lsp, nothing to do with following defenitions
	if client.name == "copilot" then
		return
	end

	local lsp = require("lsp-zero")
	-- local augroup = vim.api.nvim_create_augroup("SmartFormatting", {})
	local telesope = require("telescope.builtin")

	lsp.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr }

	vim.keymap.set({ "n", "x" }, "<F3>", function()
		-- lsp_formatting(bufnr)
		formatBuf(bufnr, false)
	end, opts)

	vim.keymap.set({ "n", "x" }, "gd", function()
		-- telesope.lsp_definitions()
		vim.lsp.buf.definition()
		vim.cmd.normal("zzzv")
	end, opts)

	vim.keymap.set({ "n", "x" }, "go", function()
		telesope.lsp_type_definitions()
		vim.cmd.normal("zzzv")
	end, opts)

	vim.keymap.set({ "n", "x" }, "gi", function()
		telesope.lsp_implementations()
		vim.cmd.normal("zzzv")
	end, opts)

	vim.keymap.set({ "n", "x" }, "gr", function()
		telesope.lsp_references()
		vim.cmd.normal("zzzv")
	end, opts)

	-- if client.supports_method("textDocument/formatting") then
	-- 	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
	-- 		group = augroup,
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			lsp_formatting(bufnr)
	-- 		end,
	-- 	})
	-- end
end

return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"tsserver",
				"rust_analyzer",
				"jsonls",
				"yamlls",
				"gopls",
				"marksman",
				"html",
				"pylsp",
				"docker_compose_language_service",
				"dockerls",
				"bashls",
				"cssls",
			},
		},
		cmd = "Mason",
		build = ":MasonUpdate",
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		-- follow latest release.
		version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- LSP Support
			"williamboman/mason.nvim",
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					ensure_installed = {
						"tsserver",
						"rust_analyzer",
						"jsonls",
						"yamlls",
						"gopls",
						"marksman",
						"html",
						"pylsp",
						"docker_compose_language_service",
						"dockerls",
						"bashls",
						"cssls",
					},
				},
			},

			-- Some functions are depends on telescope
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- Setting up lsp-zero with default settings
			local lsp = require("lsp-zero").preset({})

			-- Adjusting lsp-configs
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
			lspconfig.jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
			lspconfig.yamlls.setup({
				filetypes = { "yaml", "yml", "compose" },
				settings = {
					yaml = {
						schemaStore = {
							-- You must disable built-in schemaStore support if you want to use
							-- this plugin and its advanced options like `ignore`.
							enable = false,
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
			-- lspconfig.eslint_d.setup({})
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			})
			lspconfig.marksman.setup({})
			lspconfig.html.setup({})
			lspconfig.pylsp.setup({
				settings = {
					-- configure plugins in pylsp
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pylint = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
						},
					},
				},
			})
			lspconfig.docker_compose_language_service.setup({
				filetypes = { "compose" },
			})
			lspconfig.dockerls.setup({})
			lspconfig.bashls.setup({})
			lspconfig.tsserver.setup({
				settings = {
					javascript = {
						inlayHints = {
							includeInlayEnumMemberValueHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayVariableTypeHints = true,
						},
					},
					typescript = {
						inlayHints = {
							includeInlayEnumMemberValueHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayVariableTypeHints = true,
						},
					},
				},
			})

			lsp.on_attach(on_attach)
			lsp.set_sign_icons({
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			})
			lsp.setup()
		end,
	},

	-- Setup autocomplete plugins
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "saadparwaiz1/cmp_luasnip" },
			"L3MON4D3/LuaSnip",
		},
		opts = function()
			local cmp_action = require("lsp-zero").cmp_action()
			local cmp = require("cmp")
			local snip = require("luasnip")

			return {
				snippet = {
					expand = function(args)
						snip.lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip", keyword_length = 2 },
				},
				mapping = {
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<C-y>"] = cmp.config.disable,
					["<C-Space>"] = cmp.mapping(require("cmp").mapping.complete(), { "i", "c" }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				},
			}
		end,
		config = function(_, opts)
			local cmp = require("cmp")
			cmp.setup(opts)
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Setting up null-ls
	-- {
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		-- Depends on mason
	-- 		"williamboman/mason.nvim",
	-- 		-- Some functions are depends on telescope
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	opts = function()
	-- 		local nls = require("null-ls")
	-- 		return {
	-- 			on_attach = on_attach,
	-- 			sources = {
	-- 				nls.builtins.diagnostics.eslint_d,
	-- 				nls.builtins.diagnostics.pylint.with({
	-- 					extra_args = {
	-- 						"--enable=W0614,E,W,F",
	-- 						"--max-line-length=256",
	-- 						"--disable=C0301,line-too-long,missing-function-docstring,invalid-name,missing-class-docstring,consider-using-f-string,abstract-class-instantiated,broad-except",
	-- 					},
	-- 				}),
	-- 				nls.builtins.diagnostics.stylelint,
	-- 				nls.builtins.formatting.eslint_d,
	-- 				nls.builtins.formatting.isort,
	-- 				nls.builtins.formatting.prettierd,
	-- 				nls.builtins.formatting.stylua,
	-- 				nls.builtins.formatting.autopep8.with({
	-- 					extra_args = {
	-- 						"--max-line-length=256",
	-- 						"--experimental",
	-- 						"--ignore=E501",
	-- 					},
	-- 				}),
	-- 				nls.builtins.formatting.fixjson,
	-- 				nls.builtins.formatting.gofmt,
	-- 				nls.builtins.formatting.goimports,
	-- 				nls.builtins.code_actions.gitsigns,
	-- 			},
	-- 		}
	-- 	end,
	-- },

	-- Setting up linters
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "pylint" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				lua = { "luacheck" },
				-- go = { "golangci_lint" },
				json = { "jsonlint" },
				yaml = { "yamllint" },
				compose = { "yamllint" },
				markdown = { "markdownlint" },
				vim = { "vint" },
				sh = { "shellcheck" },
				-- dockerfile = { "hadolint" },
				cpp = { "cppcheck" },
				c = { "cppcheck" },
				html = { "tidy" },
				css = { "stylelint" },
				scss = { "stylelint" },
				less = { "stylelint" },
				vue = { "eslint_d" },
				svelte = { "eslint_d" },
				sql = { "sqlint" },
			}

			lint.linters.luacheck.args = { "--formatter", "plain", "--codes", "--ranges", "--read-gloabals vim", "-" }
			lint.linters.pylint.args = {
				"--disable=C0301,line-too-long,missing-function-docstring,invalid-name,missing-class-docstring,consider-using-f-string,abstract-class-instantiated,broad-except",
				"--max-line-length=256",
				"--enable=W0614,E,W,F",
				"-f",
				"json",
			}
			lint.linters.yamllint.args = {
				"-f",
				"parsable",
				"-d",
				"{extends: default, rules: {line-length: {max: 256}, document-start: disable}}",
				"-",
			}

			vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWritePost" }, {
				pattern = {
					"*.lua",
					"*.go",
					"*.py",
					"*.js",
					"*.jsx",
					"*.ts",
					"*.tsx",
					"*.json",
					"*.yaml",
					"*.yml",
					"*.md",
					"*.vim",
					"*.sh",
					"*.Dockerfile",
					"*.cpp",
					"*.c",
					"*.html",
					"*.css",
					"*.scss",
					"*.less",
					"*.vue",
					"*.svelte",
					"*.sql",
					"*.fish",
				},
				callback = function(_)
					-- require("notify")(
					-- 	"Linting...",
					-- 	vim.log.levels.INFO,
					-- 	{ timeout = 500, position = "bottom_center", icon = "", render = "minimal" }
					-- )
					lint.try_lint()
				end,
			})

			-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			--              pattern = {"*.lua"},
			-- 	callback = function()
			-- 		lint.try_lint()
			-- 	end,
			-- })
		end,
	},

	-- Setting up formatter
	{
		"mhartington/formatter.nvim",
		opts = function()
			local stylelua = require("formatter.filetypes.lua").stylua
			local gofmt = require("formatter.filetypes.go").gofmt
			local goimports = require("formatter.filetypes.go").goimports
			local prettierd = require("formatter.defaults.prettierd")
			local eslint_d = require("formatter.defaults.eslint_d")
			-- local autopep8 = require("formatter.filetypes").autopep8
			-- local isort = require("formatter.filetypes.python").isort
			local rustfmt = require("formatter.filetypes.rust").rustfmt
			return {
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = {
						stylelua,
					},
					go = {
						gofmt,
						goimports,
					},
					rust = {
						rustfmt,
					},
					json = {
						prettierd,
					},
					yaml = {
						prettierd,
					},
					typescript = {
						prettierd, -- should be included into eslint_d
						eslint_d,
					},
					typescriptreact = {
						prettierd, -- should be included into eslint_d
						eslint_d,
					},
					javascript = {
						prettierd, -- should be included into eslint_d
						eslint_d,
					},
					javascriptreact = {
						prettierd, -- should be included into eslint_d
						eslint_d,
					},
					python = {
						function()
							return {
								exe = "isort",
								args = {
									"-q",
									"-l 256",
									"-",
								},
								stdin = 1,
							}
						end,
						function()
							return {
								exe = "autopep8",
								args = {
									"--max-line-length=256",
									"--experimental",
									"--ignore=E501",
									"-",
								},
								stdin = 1,
							}
						end,
					},
					markdown = {
						prettierd,
					},
					css = {
						prettierd,
					},
					scss = {
						prettierd,
					},
					["*"] = {},

					-- ["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					-- 	require("formatter.filetypes.any").remove_trailing_whitespace,
					-- },
				},
			}
		end,
		config = function(_, opts)
			require("formatter").setup(opts)

			local augroup = vim.api.nvim_create_augroup("FF", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = {
					"*.lua",
					"*.go",
					"*.py",
					"*.js",
					"*.jsx",
					"*.ts",
					"*.tsx",
					"*.json",
					"*.yaml",
					"*.yml",
					"*.md",
					"*.sh",
					"*.Dockerfile",
					"*.cpp",
					"*.c",
					"*.html",
					"*.css",
					"*.scss",
					"*.less",
				},
				group = augroup,
				callback = function(args)
					formatBuf(args.buf, true)
				end,
			})
		end,
	},

	-- Then setting up mason-null-ls to get predefined formatters and linters
	-- {
	-- 	"jay-babu/mason-null-ls.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		-- Depends on mason
	-- 		"williamboman/mason.nvim",
	-- 		-- And ofc we need null-ls to get presets working
	-- 		"jose-elias-alvarez/null-ls.nvim",
	-- 	},
	-- 	opts = {
	-- 		{
	-- 			ensure_installed = {
	-- 				"stylua",
	-- 				"pylint",
	-- 				"isort",
	-- 				"eslint_d",
	-- 				"prettierd",
	-- 				"stylelint",
	-- 				"autopep8",
	-- 				"fixjson",
	-- 				"gofmt",
	-- 				"goimports",
	-- 			},
	-- 			automatic_installation = false,
	-- 			handlers = {
	-- 				pylint = function(_, _)
	-- 					local null_ls = require("null-ls")
	-- 					null_ls.register(null_ls.builtins.diagnostics.pylint.with({
	-- 						extra_args = {
	-- 							"--enable=W0614,E,W,F",
	-- 							"--max-line-length=256",
	-- 							"--disable=C0301,line-too-long,missing-function-docstring,invalid-name,missing-class-docstring,consider-using-f-string,abstract-class-instantiated,broad-except",
	-- 						},
	-- 					}))
	-- 				end,
	-- 				autopep8 = function(_, _)
	-- 					local null_ls = require("null-ls")
	-- 					null_ls.register(null_ls.builtins.formatting.autopep8.with({
	-- 						extra_args = {
	-- 							"--max-line-length=256",
	-- 							"--experimental",
	-- 							"--ignore=E501",
	-- 						},
	-- 					}))
	-- 				end,
	-- 			},
	-- 		},
	-- 	},
	-- 	-- config = function(_, opts)
	-- 	-- 	require("mason-null-ls").setup(opts)
	-- 	-- 	require("null-ls").setup({
	-- 	-- 		sources = {
	-- 	-- 			require("null-ls").builtins.formatting.stylua,
	-- 	-- 		},
	-- 	-- 		on_attach = on_attach,
	-- 	-- 	})
	-- 	-- end,
	-- },
}
