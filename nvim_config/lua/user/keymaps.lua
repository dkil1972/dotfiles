-- lua/user/keymaps.lua

local keymap = vim.keymap

-- reload all lua files and neovim config
keymap.set("n", "<leader><leader>r", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^user") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  print("🔁 Config reloaded")
end, { desc = "Reload Neovim config" })

-- Expand %% to current buffer's directory in command-line mode
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  callback = function()
    vim.cmd([[
      cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') . '/' : '%%'
    ]])
  end,
})

-- expand the diagnostic window
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
-- telescope file finder
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffer" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
