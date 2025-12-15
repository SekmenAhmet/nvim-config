-- Configuration Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import tous les plugins
    { import = "plugins.lsp" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.terminal" },
    { import = "plugins.session" },
    { import = "plugins.theme" },
    { import = "plugins.dap" },
    { import = "plugins.java" },
    { import = "plugins.rust" }, -- Configuration Rust ultime
    { import = "plugins.c" }, -- Configuration C/C++
    { import = "plugins.python" }, -- Configuration Python
  },
  checker = { enabled = true },
  rocks = {
    enabled = false, -- Désactiver luarocks car aucun plugin ne le requiert
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
