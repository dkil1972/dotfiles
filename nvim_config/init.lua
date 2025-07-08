-- init.lua

-- Set the leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load your actual config
require("user.options")
require("user.keymaps")
require("user.lazy")
require("user.autocmds")

