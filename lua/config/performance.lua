-- Optimisations de performance pour Neovim
local opt = vim.opt

-- Optimiser le rendu
opt.ttyfast = true
opt.redrawtime = 1500

-- Réduire la charge sur les fichiers volumineux
opt.synmaxcol = 200
opt.maxmempattern = 20000

-- Optimiser les fenêtres
opt.winminheight = 0
opt.winheight = 1

-- Désactiver les providers inutiles
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Les updatetime et timeoutlen sont définis dans options.lua

-- Optimiser les swap et backup
opt.directory = vim.fn.stdpath("cache") .. "/swap"
opt.backupdir = vim.fn.stdpath("cache") .. "/backup"
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Réduire la fréquence de scan des plugins
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1