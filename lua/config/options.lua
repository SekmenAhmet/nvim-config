-- Options de base
local opt = vim.opt

vim.g.python_highlight_all = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

opt.autoread = true

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- Navigation fenêtres (tree <-> code)
map("n", "<C-h>", "<C-w>h", { desc = "Fenêtre gauche" })
map("n", "<C-l>", "<C-w>l", { desc = "Fenêtre droite" })

-- Move lines up/down (Alt+Shift+Arrows or Meta+Shift+Arrows)
local function move_up()
  return ":move .-2<CR>=="
end
local function move_down()
  return ":move .+1<CR>=="
end
map("n", "<A-S-Up>", move_up, { desc = "Move line up", silent = true })
map("n", "<A-S-Down>", move_down, { desc = "Move line down", silent = true })
map("n", "<M-S-Up>", move_up, { desc = "Move line up", silent = true })
map("n", "<M-S-Down>", move_down, { desc = "Move line down", silent = true })

map("x", "<A-S-Up>", ":move '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map("x", "<A-S-Down>", ":move '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("x", "<M-S-Up>", ":move '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map("x", "<M-S-Down>", ":move '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })

map("s", "<A-S-Up>", ":move '<-2<CR>gv<C-g>", { desc = "Move selection up", silent = true })
map("s", "<A-S-Down>", ":move '>+1<CR>gv<C-g>", { desc = "Move selection down", silent = true })
map("s", "<M-S-Up>", ":move '<-2<CR>gv<C-g>", { desc = "Move selection up", silent = true })
map("s", "<M-S-Down>", ":move '>+1<CR>gv<C-g>", { desc = "Move selection down", silent = true })

-- Duplicate lines/selection up/down
local function dup_up()
  return ":t -1<CR>k"
end
local function dup_down()
  return ":t .<CR>j"
end
map("n", "<A-C-S-Up>", dup_up, { desc = "Duplicate line up", silent = true })
map("n", "<A-C-S-Down>", dup_down, { desc = "Duplicate line down", silent = true })
map("n", "<M-C-S-Up>", dup_up, { desc = "Duplicate line up", silent = true })
map("n", "<M-C-S-Down>", dup_down, { desc = "Duplicate line down", silent = true })

map("x", "<A-C-S-Up>", ":t '<-1<CR>gv", { desc = "Duplicate selection up", silent = true })
map("x", "<A-C-S-Down>", ":t '><CR>gv", { desc = "Duplicate selection down", silent = true })
map("x", "<M-C-S-Up>", ":t '<-1<CR>gv", { desc = "Duplicate selection up", silent = true })
map("x", "<M-C-S-Down>", ":t '><CR>gv", { desc = "Duplicate selection down", silent = true })

map("s", "<A-C-S-Up>", ":t '<-1<CR>gv<C-g>", { desc = "Duplicate selection up", silent = true })
map("s", "<A-C-S-Down>", ":t '><CR>gv<C-g>", { desc = "Duplicate selection down", silent = true })
map("s", "<M-C-S-Up>", ":t '<-1<CR>gv<C-g>", { desc = "Duplicate selection up", silent = true })
map("s", "<M-C-S-Down>", ":t '><CR>gv<C-g>", { desc = "Duplicate selection down", silent = true })

local function in_insert_mode()
  local mode = vim.api.nvim_get_mode().mode
  return mode:sub(1, 1) == "i" or mode:sub(1, 1) == "s"
end

local function resume_insert(was_insert)
  if not was_insert then
    return
  end
  vim.schedule(function()
    if not in_insert_mode() then
      vim.cmd("startinsert")
    end
  end)
end

local function set_cursor_safe(row, col)
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local max_col = #line
  local new_col = col
  if new_col < 0 then
    new_col = 0
  elseif new_col > max_col then
    new_col = max_col
  end
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

local function move_line_insert(delta)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line_count = vim.api.nvim_buf_line_count(0)
  if delta < 0 and row == 1 then
    return
  end
  if delta > 0 and row == line_count then
    return
  end
  local was_insert = in_insert_mode()
  if was_insert then
    vim.cmd("stopinsert")
  end
  if delta > 0 then
    vim.cmd("move .+1")
  else
    vim.cmd("move .-2")
  end
  vim.cmd("normal! ==")
  set_cursor_safe(row + delta, col)
  resume_insert(was_insert)
end

local function duplicate_line_insert(delta)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local was_insert = in_insert_mode()
  if was_insert then
    vim.cmd("stopinsert")
  end
  if delta > 0 then
    vim.cmd("t .")
  else
    vim.cmd("t -1")
  end
  local target_row = row + delta
  if target_row < 1 then
    target_row = 1
  end
  set_cursor_safe(target_row, col)
  resume_insert(was_insert)
end

-- Move/duplicate lines in insert mode
map("i", "<A-S-Up>", function() move_line_insert(-1) end, { desc = "Move line up" })
map("i", "<A-S-Down>", function() move_line_insert(1) end, { desc = "Move line down" })
map("i", "<M-S-Up>", function() move_line_insert(-1) end, { desc = "Move line up" })
map("i", "<M-S-Down>", function() move_line_insert(1) end, { desc = "Move line down" })
map("i", "<A-C-S-Up>", function() duplicate_line_insert(-1) end, { desc = "Duplicate line up" })
map("i", "<A-C-S-Down>", function() duplicate_line_insert(1) end, { desc = "Duplicate line down" })
map("i", "<M-C-S-Up>", function() duplicate_line_insert(-1) end, { desc = "Duplicate line up" })
map("i", "<M-C-S-Down>", function() duplicate_line_insert(1) end, { desc = "Duplicate line down" })

-- Sauvegarde
map("n", "<C-s>", "<Cmd>w<CR>", { desc = "Save" })
map("v", "<C-s>", "<Cmd>w<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc><Cmd>w<CR>", { desc = "Save" })

-- Undo/Redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- Clear search highlight
map("n", "<leader>/", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Delete without clipboard
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without clipboard" })
map("n", "<leader>D", '"_D', { desc = "Delete line end without clipboard" })

-- Better page navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Page down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up centered" })

-- Search navigation
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Numéros de ligne
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true

-- Interface
opt.wrap = false
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.showmode = false
opt.cursorline = true

-- Recherche
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Fichiers
opt.swapfile = false
opt.backup = false
opt.undofile = true
local undodir = vim.fn.stdpath("cache") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

-- Système
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 200
opt.whichwrap = "b,s,<,>,[,],h,l"
opt.confirm = true

-- Complétion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 15

-- Recharger les fichiers modifiés et restaurer la position du curseur
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local last = vim.fn.line([['"]])
    if last > 1 and last <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Diagnostics: virtual text inline with improved visibility
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
    severity = { min = vim.diagnostic.severity.HINT },
  },
  virtual_lines = false,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.INFO] = "ℹ",
      [vim.diagnostic.severity.HINT] = "💡",
    },
  },
  underline = true,
  float = {
    focusable = true,
    border = "rounded",
    source = "if_many",
  },
})

-- Filetypes NASM pour x86_64
vim.filetype.add({
  extension = {
    asm = "nasm",
    nasm = "nasm",
  },
})

-- Indentation ASM (ARM32 + x86_64)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "asm", "nasm" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = false
    if vim.bo.filetype == "nasm" then
      vim.bo.commentstring = "; %s"
    else
      vim.bo.commentstring = "# %s"
    end
  end,
})
