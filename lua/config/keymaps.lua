-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove flash binding for 's'
-- flash search rebound to: <leader>ss
-- See './lua/plugins/flash.lua' for the rebind
vim.keymap.del({ "n", "x", "o"}, "s")

-- Pickers that escape the project root
vim.keymap.set("n", "<leader>fh", function()
  Snacks.picker.files({ cwd = vim.env.HOME, hidden = true })
end, { desc = "Find File (home)" })

vim.keymap.set("n", "<leader>f/", function()
  Snacks.picker.explorer({ cwd = "/", hidden = true })
end, { desc = "Browse Files (/)" })
