-- Optimisations de performance pour Neovim
local opt = vim.opt

-- Optimiser le rendu
opt.lazyredraw = true
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

-- Optimiser les updatetime
opt.updatetime = 1000 -- Augmenter de 300ms à 1000ms
opt.timeoutlen = 500 -- Réduire le timeout des keymaps

-- Optimiser les swap et backup
opt.directory = vim.fn.stdpath("cache") .. "/swap"
opt.backupdir = vim.fn.stdpath("cache") .. "/backup"
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Réduire la fréquence de scan des plugins
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1