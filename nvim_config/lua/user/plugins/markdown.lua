-- lua/user/plugins/markdown.lua
-- In-buffer markdown rendering (raw text shown on the cursor line)

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
    },
    opts = {
      -- defaults use Nerd Font glyphs; plain characters instead
      heading = { icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " } },
      checkbox = {
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
    },
  },

  -- Live preview in a separate window (renders mermaid); needs Deno
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      { "<leader>mp", function() require("peek").open() end, ft = "markdown", desc = "Open markdown preview" },
      { "<leader>mq", function() require("peek").close() end, ft = "markdown", desc = "Close markdown preview" },
    },
    opts = {
      -- the webview app is unreliable on Windows; use the default browser
      app = "browser",
    },
  },
}
