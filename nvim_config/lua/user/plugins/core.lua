-- lua/user/plugins/core.lua
-- Core plugins that are fundamental to the setup

return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}
