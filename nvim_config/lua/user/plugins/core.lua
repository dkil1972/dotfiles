-- lua/user/plugins/core.lua
-- Core plugins that are fundamental to the setup

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local actions = require("telescope.actions")
      return {
        pickers = {
          buffers = {
            mappings = {
              n = { ["dd"] = actions.delete_buffer },
            },
          },
        },
      }
    end,
  },
  -- The main branch does not support lazy-loading
  { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
}
