local M = {}
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.clipboard:append("unnamed")
opt.clipboard:append("unnamedplus")
opt.scrolloff = 4
opt.incsearch = true
opt.smartcase = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.wrap = true
opt.cursorline = true
opt.mouse:append("a")
opt.ignorecase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
-- opt.autochdir = true
opt.virtualedit = "block"
opt.updatetime = 300

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
		{ import = "plugins.coding" },
		{ import = "plugins.dap" },
		{ import = "plugins.formatting" },
		{ import = "plugins.linting" },
		{ import = "plugins.lsp" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.ui" },
		{ import = "plugins.editor" },
		{ import = "plugins.util" },
		{ import = "plugins.test" },
		{ import = "plugins.lang" },
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

function M.setup(opts)
    require("config").setup(opts)
end

require("config")

return M
