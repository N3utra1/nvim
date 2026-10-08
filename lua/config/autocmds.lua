-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 'number' and 'relativenumber' are window-local, so a window that last showed a
-- terminal, the starter screen or another UI buffer (all of which switch them off)
-- can hand that state on to the next file opened in it. Re-assert them whenever an
-- ordinary file buffer is shown in a non-floating window.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("file_line_numbers", { clear = true }),
  callback = function(ev)
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(win) ~= ev.buf or vim.api.nvim_win_get_config(win).relative ~= "" then
      return
    end
    if vim.bo[ev.buf].buftype == "" and vim.bo[ev.buf].buflisted then
      vim.wo[win].number = true
      vim.wo[win].relativenumber = true
    end
  end,
})
