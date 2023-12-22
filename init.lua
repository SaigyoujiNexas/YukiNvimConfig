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
opt.autoindent = true
opt.wrap = true
opt.cursorline = true
-- opt.cursorlineopt = true
opt.mouse:append("a")
opt.ignorecase = true
opt.termguicolors = true

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


require("plugin")
require("keymap")
