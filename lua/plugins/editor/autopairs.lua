-- Autopairs - Auto-completion des paires de caractères
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup({
      check_ts = false,
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      check_comma = true,
      map_cr = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    })

    -- Intégration avec nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Règles personnalisées pour différents types de fichiers
    -- Règle pour les backticks en markdown
    npairs.add_rule(Rule("`", "`", "markdown"))
    
    -- Règle pour les triple backticks en markdown
    npairs.add_rule(Rule("```", "```", "markdown"))
    
    -- Règle pour les dollar signs en LaTeX/markdown (math mode)
    npairs.add_rule(Rule("$", "$", {"tex", "latex", "markdown"}))
    
    -- Règle pour les angles brackets
    npairs.add_rule(Rule("<", ">", {"html", "xml", "vue", "typescript", "javascript", "rust"}))
    
    -- Amélioration pour les fonctions fléchées
    npairs.add_rule(Rule("%(.*%)%s*%=>$", " {", {"typescript", "javascript"}):use_regex(true):set_end_pair_length(1))
  end,
}