-- =====================================================
-- Options de Base Neovim
-- =====================================================
-- Configuration des options Neovim uniquement
-- Diagnostics → diagnostics.lua | Keymaps → keymaps.lua

local opt = vim.opt

-- ==================== LEADERS ====================
-- Définir les leaders en premier
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ==================== NUMÉROTATION ====================
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- ==================== INDENTATION ====================
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

-- ==================== INTERFACE ====================
opt.wrap = false
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.showmode = false
opt.conceallevel = 0
opt.pumheight = 15 -- Plus de suggestions visibles (10 → 15)

-- ==================== RECHERCHE ====================
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- ==================== PERFORMANCE ====================
opt.updatetime = 250  -- Réduit de 1000ms → 250ms pour autocomplétion rapide
opt.timeoutlen = 300  -- Réduit de 500ms → 300ms pour keymaps plus rapides
opt.ttimeoutlen = 0   -- Pas de délai pour les touches terminales
opt.lazyredraw = false -- Désactivé pour meilleure réactivité

-- ==================== FICHIERS & SAUVEGARDE ====================
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000

-- Répertoires pour les fichiers temporaires
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- ==================== INTERFACE SYSTÈME ====================
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true

-- ==================== SESSIONS ====================
-- Configuration pour auto-session
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- ==================== COMPLÉTION ====================
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- ==================== VISUEL ====================
opt.cursorline = true
-- opt.colorcolumn = "120"
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- ==================== PLIAGE (FOLDING) ====================
opt.foldenable = false -- Désactivé par défaut
opt.foldlevel = 99