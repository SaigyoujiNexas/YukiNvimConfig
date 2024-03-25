-- lazy packet manager config start
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
-- lazy packet manager config end
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.dap" },
		{ import = "plugins.editor" },
		{ import = "plugins.formatting" },
		{ import = "plugins.lang" },
		{ import = "plugins.linting" },
		{ import = "plugins.lsp" },
		{ import = "plugins.test" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.ui" },
		{ import = "plugins.util" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = {
		colorscheme = {
			"tokyonight",
			"habamax",
		},
	},
	checker = {
		enabled = true,
	},
})
