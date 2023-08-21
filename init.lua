-- Check if lazy.nvim is installed and install it if not
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load basic settings configs and remaps
require("remap")
require("winbar")
require("tweaks")
require("opts")
require("funcs")
require("filetypes")

-- Trick netrw into thinking it's loaded, we are using Neotree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load plugins
-- require("lazy").setup("plugins")
require("lazy").setup({
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
	spec = {
		import = "plugins",
	},
	ui = {
		border = "rounded",
	},
})
