-- Extra parsers on top of the LazyVim defaults.
-- `opts_extend = { "ensure_installed" }` in LazyVim's treesitter spec means this
-- list is appended to the defaults rather than replacing them.
--
-- LazyVim extras (lang.*, ui.*) do NOT belong here: importing them from a file
-- under lua/plugins/ bypasses lazyvim/plugins/xtras.lua, which is what assigns
-- their load priority. Register them in lazyvim.json instead (or via :LazyExtras).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
}
