-- lua/user/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Import all plugin configurations
require("lazy").setup({
  { import = "user.plugins.core" },
  { import = "user.plugins.completion" },
  { import = "user.plugins.lsp" },
  { import = "user.plugins.javascript" },
})
