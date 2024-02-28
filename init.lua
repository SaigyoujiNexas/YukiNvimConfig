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
require("config.lazy")
