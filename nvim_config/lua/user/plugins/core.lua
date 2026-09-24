-- lua/user/plugins/core.lua
-- Core plugins that are fundamental to the setup

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- The main branch does not support lazy-loading
  { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
}
