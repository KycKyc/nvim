-- Redefine filetype for Nginx config files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*/Nginx/configs/*.conf" },
	callback = function()
		vim.api.nvim_command("setfiletype nginx")
	end,
})

-- Setup diagnostics window
vim.diagnostic.config({
	-- Enable virtual text, override spacing to 4
	virtual_text = {
		-- source = "if_many", -- Or "if_many"
		prefix = "●", -- Could be '■', '▎', 'x'
		spacing = 4,
	},
	underline = false,
	severity_sort = true,
	float = {
		source = "always", -- Or "if_many"
		border = "rounded",
	},
})
