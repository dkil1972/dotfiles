-- lua/user/keymaps.lua

local keymap = vim.keymap

-- reload all lua files and neovim config
vim.keymap.set("n", "<leader><leader>r", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^user") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  print("🔁 Config reloaded")
end, { desc = "Reload Neovim config" })

