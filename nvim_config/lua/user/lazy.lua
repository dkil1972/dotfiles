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
  { "nvim-telescope/telescope.nvim",   tag = "0.1.4" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- JavaScript/TypeScript specific
  { "windwp/nvim-autopairs",             config = true }, -- Auto-close brackets
  { "windwp/nvim-ts-autotag",            config = true }, -- Auto-close HTML/JSX tags

  -- Mason: installs language servers
  { "williamboman/mason.nvim",           config = true, lazy = false },
  { "williamboman/mason-lspconfig.nvim", config = true, lazy = false },

  -- LSP config
  {
    config = function()
      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "eslint" },
        handlers = {
          -- Default handler for most servers
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          -- Custom handler for lua_ls
          ["lua_ls"] = function()
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
        },
      })
    end,
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
})
