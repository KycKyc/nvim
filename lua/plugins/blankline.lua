return {
	{
		"lukas-reineke/indent-blankline.nvim",
		init = function()
			vim.opt.list = true
			vim.opt.listchars:append("lead:·")
			vim.opt.listchars:append("eol:↴")
			vim.cmd([[highlight IndentBlanklineIndent1 guifg=#383A4B gui=nocombine]])
			vim.cmd([[highlight IndentBlanklineIndent2 guifg=#2d2f3c gui=nocombine]])
		end,
		opts = {
			show_end_of_line = true,
			show_current_context = true,
			show_trailing_blankline_indent = false,
			space_char_blankline = " ",
			strict_tabs = true,
			--char = "▏",
			--context_char = "▏",
			use_treesitter = true,
			-- show_current_context_start = true,
			char_highlight_list = {
				"IndentBlanklineIndent1",
			},
			space_char_highlight_list = {
				"IndentBlanklineIndent2",
			},
		},
	},
}
