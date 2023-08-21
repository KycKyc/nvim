vim.filetype.add({
	pattern = {
		[".*compose.yml"] = "compose",
	},
})

vim.treesitter.language.register("yaml", "compose")
