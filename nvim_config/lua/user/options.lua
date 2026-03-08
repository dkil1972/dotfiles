-- lua/user/options.lua

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 250

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

