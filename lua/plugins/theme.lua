return {
	{
		"rebelot/kanagawa.nvim",
		opts = {
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {
					waveBlue1 = "#3e3e50",
				},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors) -- add/modify highlights
			     local theme = colors.theme
			     return {}
			end,
			theme = "wave", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)

			vim.cmd("colorscheme kanagawa")
			vim.cmd("highlight TelescopeBorder guibg=none")
			vim.cmd("highlight TelescopeTitle guibg=none")
			vim.cmd("highlight FloatBorder guibg=none")
			vim.cmd("highlight NormalFloat guibg=none")
		end,
	},
}
