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
      -- PR review: origin/HEAD resolves to the repo's default branch (main/master)
      { "<leader>gp", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>", desc = "Review PR vs default branch" },
      { "<leader>gc", "<cmd>DiffviewFileHistory --range=origin/HEAD...HEAD<CR>", desc = "PR commits" },
    },
    opts = {
      -- icons need nvim-web-devicons and a Nerd Font in the terminal
      use_icons = false,
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
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(l, r, d)
          vim.keymap.set("n", l, r, { buffer = bufnr, desc = d })
        end
        map("]h", gs.next_hunk, "Next hunk")
        map("[h", gs.prev_hunk, "Prev hunk")
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>gB", function() gs.change_base("origin/HEAD...", true) end, "Signs vs PR base")
        map("<leader>gR", function() gs.reset_base(true) end, "Signs vs working tree")
      end,
    },
  },
}
