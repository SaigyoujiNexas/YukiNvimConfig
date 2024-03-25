vim.uv = vim.uv or vim.loop

require("config.options")
require("config.lazy")
require("config").setup({
	colorscheme = "catppuccin",
})
