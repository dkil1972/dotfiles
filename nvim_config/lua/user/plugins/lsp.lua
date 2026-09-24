-- lua/user/plugins/lsp.lua
-- Language Server Protocol setup and configuration

return {
  -- Mason: installs language servers
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    config = true,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Custom settings for lua_ls (merged with nvim-lspconfig's defaults)
      vim.lsp.config("lua_ls", {
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

      -- mason-lspconfig v2 installs these and calls vim.lsp.enable() for them
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "eslint" },
      })
    end,
  },
}
