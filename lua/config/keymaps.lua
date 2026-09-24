-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove flash binding for 's'
-- flash search rebound to: <leader>ss
-- See './lua/plugins/flash.lua' for the rebind
vim.keymap.del({ "n", "x", "o"}, "s")

-- Pickers that escape the project root
local function find_home()
  Snacks.picker.files({ cwd = vim.env.HOME, hidden = true })
end

-- Bound twice: <leader>fh follows the LazyVim habit of a letter per picker,
-- <leader>f~ reads as the path it opens and mirrors <leader>f/ below.
vim.keymap.set("n", "<leader>fh", find_home, { desc = "Find File (home)" })
vim.keymap.set("n", "<leader>f~", find_home, { desc = "Find File (home)" })

vim.keymap.set("n", "<leader>f/", function()
  Snacks.picker.explorer({ cwd = "/", hidden = true })
end, { desc = "Browse Files (/)" })

-- Cheatsheets: <leader>fs lists the sheets in a picker; Enter shows the chosen one
-- rendered in a full-size float. In the float: q/<Esc> close, <BS> goes back to the
-- list, <CR> opens the file as a normal buffer. / and n/N search as usual.
local cheatsheet_dir = vim.fn.expand("~/Documents/cheatsheets")
local pick_cheatsheet

local function view_cheatsheet(file)
  local function close(self)
    self:close()
  end

  Snacks.win({
    text = vim.fn.readfile(file),
    title = " " .. vim.fn.fnamemodify(file, ":t:r") .. " ",
    footer = " <BS> list · <CR> open as buffer · q close ",
    footer_pos = "center",
    border = "rounded",
    backdrop = false,
    bo = { modifiable = false },
    wo = { wrap = true, linebreak = true, cursorline = true },
    -- Set the filetype once the window exists: render-markdown attaches on FileType
    -- and only draws immediately if the buffer is already shown in a window.
    on_win = function(self)
      vim.bo[self.buf].filetype = "markdown"
    end,
    keys = {
      q = close,
      ["<Esc>"] = close,
      ["<BS>"] = function(self)
        self:close()
        pick_cheatsheet()
      end,
      ["<CR>"] = function(self)
        self:close()
        vim.cmd.edit(vim.fn.fnameescape(file))
      end,
    },
  })
end

function pick_cheatsheet()
  Snacks.picker.files({
    title = "Cheatsheets",
    cwd = cheatsheet_dir,
    ft = "md",
    confirm = function(picker, item)
      picker:close()
      if item then
        view_cheatsheet(vim.fs.joinpath(cheatsheet_dir, item.file))
      end
    end,
  })
end

vim.keymap.set("n", "<leader>fs", pick_cheatsheet, { desc = "Cheatsheets" })
