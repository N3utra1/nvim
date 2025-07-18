return {
  -- 1. Install the gruvbox.nvim plugin
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = function()
      -- 2. Set background to light for Gruvbox light mode
      vim.o.background = "light"
      require("gruvbox").setup({
        -- optionally tweak contrast, overrides, etc.
        -- e.g. contrast = "soft",
      })
    end },

  -- 3. Tell LazyVim to use gruvbox as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

