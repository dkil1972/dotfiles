-- lua/user/plugins/lsp.lua
-- Language Server Protocol setup and configuration

return {
  -- Mason: installs language servers
  { "williamboman/mason.nvim", config = true, lazy = false },
  { "williamboman/mason-lspconfig.nvim", config = true, lazy = false },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
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
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
}
