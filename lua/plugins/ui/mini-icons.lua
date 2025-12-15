-- mini.icons - icônes fallback pour les plugins qui en dépendent
return {
  "echasnovski/mini.icons",
  version = "*",
  config = function()
    require("mini.icons").setup()
  end,
}
