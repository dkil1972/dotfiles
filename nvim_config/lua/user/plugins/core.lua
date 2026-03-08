-- lua/user/plugins/core.lua
-- Core plugins that are fundamental to the setup

return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}
