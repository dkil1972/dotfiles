-- lua/user/plugins/javascript.lua
-- JavaScript/TypeScript specific plugins and configuration

return {
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true }, -- Auto-close brackets
  { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, config = true }, -- Auto-close HTML/JSX tags
}
