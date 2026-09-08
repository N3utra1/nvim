-- Overrides on top of lazyvim.plugins.extras.ai.claudecode (enabled in lazyvim.json).

-- Claude's terminal is a Snacks terminal in a right-hand split, and its buffer is
-- unlisted, so bufferline never shows a tab for it. The helpers below give it the
-- same feel as a file opened from the explorer: the buffer is listed (so it gets a
-- bufferline entry) and can be shown full width in the main editor window.
--
-- The split is dismissed with :ClaudeCode (the toggle), which only hides the window.
-- :ClaudeCodeClose must not be used: it wipes the terminal buffer and kills the
-- running Claude process, because Snacks treats the terminal buffer as its scratch
-- buffer. :ClaudeCodeFocus recreates the split around the surviving buffer.

local function claude_bufnr()
  local ok, terminal = pcall(require, "claudecode.terminal")
  if not ok then
    return nil
  end
  local bufnr = terminal.get_active_terminal_bufnr()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr
  end
  return nil
end

-- Windows holding the explorer, pickers, the Claude split itself or any float are
-- not somewhere to put a buffer; anything else counts as the main editor area.
local sidebar_filetypes = {
  ["snacks_terminal"] = true,
  ["snacks_layout_box"] = true,
  ["snacks_picker_list"] = true,
  ["snacks_picker_input"] = true,
  ["neo-tree"] = true,
  ["trouble"] = true,
  ["help"] = true,
}

local function is_editor_win(win)
  if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  return not sidebar_filetypes[vim.bo[buf].filetype]
end

local function main_win()
  local cur = vim.api.nvim_get_current_win()
  if is_editor_win(cur) then
    return cur
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_editor_win(win) then
      return win
    end
  end
  return cur
end

-- The window Claude took over, plus the buffer it displaced, so the toggle can put
-- the file back rather than leaving the terminal behind.
local full = nil

-- Full screen only counts while that window still shows Claude: opening a file over
-- it (from the explorer, say) ends it, and Claude stays a tab in the bufferline.
local function full_win()
  if not (full and vim.api.nvim_win_is_valid(full.win)) then
    return nil
  end
  local bufnr = claude_bufnr()
  if bufnr and vim.api.nvim_win_get_buf(full.win) == bufnr then
    return full.win
  end
  return nil
end

local function show_full(bufnr)
  vim.bo[bufnr].buflisted = true -- gives it a bufferline tab, like a file
  if vim.fn.bufwinid(bufnr) ~= -1 then
    vim.cmd("ClaudeCode") -- hides the split window; keeps the buffer and the job
  end
  local win = main_win()
  local displaced = vim.api.nvim_win_get_buf(win)
  full = { win = win, buf = displaced ~= bufnr and displaced or nil }
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_set_current_win(win)
  vim.cmd("startinsert")
end

local function full_screen()
  local bufnr = claude_bufnr()
  if bufnr then
    show_full(bufnr)
    return
  end

  -- Not running yet: start it, then take over the main window as soon as the
  -- terminal buffer exists. Snacks may create it on a later tick, so poll briefly.
  local main = main_win()
  vim.cmd("ClaudeCode")
  local tries = 0
  local function grab()
    local buf = claude_bufnr()
    if buf then
      if vim.api.nvim_win_is_valid(main) then
        vim.api.nvim_set_current_win(main)
      end
      show_full(buf)
    elseif tries < 20 then
      tries = tries + 1
      vim.defer_fn(grab, 50)
    end
  end
  grab()
end

local function restore_split()
  local win = full_win()
  if win and full.buf and vim.api.nvim_buf_is_valid(full.buf) then
    vim.api.nvim_win_set_buf(win, full.buf)
  elseif win then
    vim.api.nvim_win_call(win, function()
      vim.cmd("silent! buffer #")
    end)
  end
  full = nil
  vim.cmd("ClaudeCodeFocus")
end

local function toggle_full_screen()
  if full_win() then
    restore_split()
  else
    full_screen()
  end
end

return {
  "coder/claudecode.nvim",
  -- The LazyVim extra is keys-only, so the plugin loads on <leader>a* and the
  -- :ClaudeCode* commands do not exist before then. Declaring cmd makes
  -- lazy.nvim create stubs that load the plugin on first command use instead.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeAdd",
    "ClaudeCodeClose",
    "ClaudeCodeCloseAllDiffs",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeFocus",
    "ClaudeCodeOpen",
    "ClaudeCodeSelectModel",
    "ClaudeCodeSend",
    "ClaudeCodeSendText",
    "ClaudeCodeStart",
    "ClaudeCodeStatus",
    "ClaudeCodeStop",
    "ClaudeCodeTreeAdd",
  },
  keys = {
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    -- snacks is the picker here, so allow adding files from its list too
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "snacks_picker_list" } },
    { "<leader>az", toggle_full_screen, desc = "Claude full screen (main window <-> sidebar)" },
  },
  init = function()
    -- Claude may also be started from <leader>ac, straight into the split. List its
    -- buffer there too so it always has a bufferline tab and survives opening a file
    -- over it.
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("claudecode_listed", { clear = true }),
      callback = function(ev)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ev.buf) and claude_bufnr() == ev.buf then
            vim.bo[ev.buf].buflisted = true
          end
        end)
      end,
    })
  end,
}
