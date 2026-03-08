-- lua/user/plugins/git.lua
-- Git integration: side-by-side diffs and gutter signs

return {
  -- Side-by-side diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff (working tree)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Close diffview" },
    },
    opts = {
      view = {
        default = { layout = "diff2_horizontal" },
        file_history = { layout = "diff2_horizontal" },
      },
    },
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
      },
    },
  },
}
