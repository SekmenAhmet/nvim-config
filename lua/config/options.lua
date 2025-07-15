-- Options de base Neovim
local opt = vim.opt

-- Numérotation des lignes
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Interface
opt.wrap = false
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 50

-- Recherche
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"