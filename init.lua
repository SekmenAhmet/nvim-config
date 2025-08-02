-- =====================================================
-- Configuration Neovim Modulaire - Version Optimisée
-- =====================================================

-- Charger les optimisations de performance en premier
require("config.performance")

-- Charger les options de base
require("config.options")

-- Charger la configuration des diagnostics LSP
require("config.diagnostics")

-- Charger les keymaps centralisés
require("config.keymaps")

-- Charger et configurer Lazy.nvim + plugins
require("config.lazy")