-- Index des plugins Editor
return {
  require("plugins.editor.telescope"),
  require("plugins.editor.treesitter"),
  require("plugins.editor.comment"),
  require("plugins.editor.surround"),
  require("plugins.editor.autopairs"),
  require("plugins.editor.conform"),
  require("plugins.editor.lint"),
  require("plugins.editor.gitsigns"),
  require("plugins.editor.spectre"),
  require("plugins.editor.trouble"),
  require("plugins.editor.flash"),
  -- Quality of Life plugins
  require("plugins.editor.colorizer"),     -- Visualisation couleurs inline
  require("plugins.editor.todo-comments"), -- TODOs colorés et searchables
  require("plugins.editor.ufo"),           -- Code folding intelligent
  require("plugins.editor.pdfview"),       -- Ouverture rapide des PDF
  require("plugins.editor.overseer"),      -- Gestionnaire de tâches/commandes
  require("plugins.editor.startuptime"),   -- Profil démarrage
}
