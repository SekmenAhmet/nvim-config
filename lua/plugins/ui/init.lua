-- Index des plugins UI - permet d'importer tout le dossier d'un coup
return {
  require("plugins.ui.alpha"),
  require("plugins.ui.nvim-tree"),
  require("plugins.ui.neo-tree"),
  require("plugins.ui.bufferline"),
  require("plugins.ui.indent-blankline"),
  require("plugins.ui.which-key"),
  -- Icons pour nvim-tree
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
      })
    end,
  },
}