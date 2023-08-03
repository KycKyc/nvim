local autocmd = vim.api.nvim_create_autocmd
local filetype_exclude = {
	"",
	"help",
	"startify",
	"dashboard",
	"packer",
	"neogitstatus",
	"NvimTree",
	"neo-tree",
	"Trouble",
	"alpha",
	"lir",
	"Outline",
	"spectre_panel",
	"toggleterm",
}

autocmd({
	"BufWinEnter",
	"BufFilePost",
}, {
	callback = function()
		if vim.tbl_contains(filetype_exclude, vim.bo.filetype) then
			vim.opt_local.winbar = nil
			return
		end
		pcall(vim.api.nvim_set_option_value, "winbar", "%=%m %f", { scope = "local" })
	end,
})
