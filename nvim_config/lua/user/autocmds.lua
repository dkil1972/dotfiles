-- Format on save for Lua files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Wrap text in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Format on save for JavaScript/TypeScript files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
