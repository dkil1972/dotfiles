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

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim",     tag = "0.1.4" },
  { "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },

  -- Mason: installs language servers
  { "williamboman/mason.nvim",           config = true,      lazy = false },
  { "williamboman/mason-lspconfig.nvim", config = true,      lazy = false },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      -- Setup lua-language-server
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- Prevent 'undefined global vim'
            },
            format = {
              enable = true,
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
})
