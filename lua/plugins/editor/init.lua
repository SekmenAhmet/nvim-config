-- Index des plugins Editor
return {
  require("plugins.editor.telescope"),
  require("plugins.editor.treesitter"),
  require("plugins.editor.comment"),
  require("plugins.editor.surround"),
  require("plugins.editor.autopairs"),
  -- TreeSitter text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- Dépendance pour Telescope
  {
    "nvim-lua/plenary.nvim",
  },
  -- Extension FZF pour Telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}