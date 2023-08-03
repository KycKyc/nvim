local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
		async = false,
	})
end

local on_attach = function(client, bufnr)
	if client.name == "copilot" then
		return
	end
	local lsp = require("lsp-zero")
	local augroup = vim.api.nvim_create_augroup("SmartFormatting", {})
	local telesope = require("telescope.builtin")

	lsp.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr }

	vim.keymap.set({ "n", "x" }, "<F3>", function()
		lsp_formatting(bufnr)
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

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
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
			-- lspconfig.eslint.setup({})
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
			lspconfig.docker_compose_language_service.setup({})
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
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Depends on mason
			"williamboman/mason.nvim",
			-- Some functions are depends on telescope
			"nvim-telescope/telescope.nvim",
		},
		opts = function()
			local nls = require("null-ls")
			return {
				on_attach = on_attach,
				sources = {
					nls.builtins.diagnostics.eslint_d,
					nls.builtins.diagnostics.pylint.with({
						extra_args = {
							"--enable=W0614,E,W,F",
							"--max-line-length=256",
							"--disable=C0301,line-too-long,missing-function-docstring,invalid-name,missing-class-docstring,consider-using-f-string,abstract-class-instantiated,broad-except",
						},
					}),
					nls.builtins.diagnostics.stylelint,
					nls.builtins.formatting.eslint_d,
					nls.builtins.formatting.isort,
					nls.builtins.formatting.prettierd,
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.autopep8.with({
						extra_args = {
							"--max-line-length=256",
							"--experimental",
							"--ignore=E501",
						},
					}),
					nls.builtins.formatting.fixjson,
					nls.builtins.formatting.gofmt,
					nls.builtins.formatting.goimports,
					nls.builtins.code_actions.gitsigns,
				},
			}
		end,
	},

	-- Then setting up mason-null-ls to get predefined formatters and linters
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Depends on mason
			"williamboman/mason.nvim",
			-- And ofc we need null-ls to get presets working
			"jose-elias-alvarez/null-ls.nvim",
		},
		opts = {
			{
				ensure_installed = {
					"stylua",
					"pylint",
					"isort",
					"eslint_d",
					"prettierd",
					"stylelint",
					"autopep8",
					"fixjson",
					"gofmt",
					"goimports",
				},
				automatic_installation = false,
				handlers = {
					pylint = function(_, _)
						local null_ls = require("null-ls")
						null_ls.register(null_ls.builtins.diagnostics.pylint.with({
							extra_args = {
								"--enable=W0614,E,W,F",
								"--max-line-length=256",
								"--disable=C0301,line-too-long,missing-function-docstring,invalid-name,missing-class-docstring,consider-using-f-string,abstract-class-instantiated,broad-except",
							},
						}))
					end,
					autopep8 = function(_, _)
						local null_ls = require("null-ls")
						null_ls.register(null_ls.builtins.formatting.autopep8.with({
							extra_args = {
								"--max-line-length=256",
								"--experimental",
								"--ignore=E501",
							},
						}))
					end,
				},
			},
		},
		-- config = function(_, opts)
		-- 	require("mason-null-ls").setup(opts)
		-- 	require("null-ls").setup({
		-- 		sources = {
		-- 			require("null-ls").builtins.formatting.stylua,
		-- 		},
		-- 		on_attach = on_attach,
		-- 	})
		-- end,
	},
}
