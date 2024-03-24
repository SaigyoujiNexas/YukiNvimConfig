vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
local opt = vim.opt
opt.grepformat = "%f:%l:%c:%m"
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

vim.opt.statuscolumn = [[%!v:lua.require'util'.ui.statuscolumn()]]
vim.opt.foldtext = "v:lua.require'util'.ui.foldtext()"

vim.o.formatexpr = "v:lua.require'util'.format.formatexpr()"
