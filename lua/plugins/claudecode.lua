-- Overrides on top of lazyvim.plugins.extras.ai.claudecode (enabled in lazyvim.json).
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
  },
}
