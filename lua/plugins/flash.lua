return {
  "folke/flash.nvim",
  keys = {
    -- disable the default flash keymap
    { "<leader>ss", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Searches with Flash" },
  },
}
