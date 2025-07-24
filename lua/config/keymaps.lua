-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove flash binding for 's'
-- flash search rebound to: <leader>ss
-- See './lua/plugins/flash.lua' for the rebind
vim.keymap.del({ "n", "x", "o"}, "s")
