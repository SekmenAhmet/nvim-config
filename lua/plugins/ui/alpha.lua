-- Alpha - Page d'accueil
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- ASCII Art Header clean et aligné
    dashboard.section.header.val = {
      "",
      "",
      "",
      "",
      "",
      "",
      "    ╔═════════════════════════════════════════════╗",
      "    ║                                             ║",
      "    ║  ███████╗████████╗ █████╗ ██████╗ ████████╗ ║",
      "    ║  ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝ ║",
      "    ║  ███████╗   ██║   ███████║██████╔╝   ██║    ║",
      "    ║  ╚════██║   ██║   ██╔══██║██╔══██╗   ██║    ║",
      "    ║  ███████║   ██║   ██║  ██║██║  ██║   ██║    ║",
      "    ║  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ║",
      "    ║                                             ║",
      "    ║                 Ready to code?              ║",
      "    ║                                             ║",
      "    ╚═════════════════════════════════════════════╝",
    }

    -- Pas de boutons
    dashboard.section.buttons.val = {}

    -- Pas de footer
    dashboard.section.footer.val = ""

    -- Configuration des couleurs avec dégradé
    dashboard.section.header.opts.hl = "Function"
    
    -- Couleurs personnalisées pour différentes parties
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
    vim.api.nvim_set_hl(0, "AlphaBorder", { fg = "#bb9af7" })
    vim.api.nvim_set_hl(0, "AlphaEmoji", { fg = "#f7768e" })
    
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- Désactiver le folding sur alpha buffer
    dashboard.opts.opts.noautocmd = true

    -- Configuration finale
    alpha.setup(dashboard.opts)


    -- Masquer la barre de statut sur la page alpha
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.laststatus = 0
        vim.opt_local.showtabline = 0
      end,
    })

    vim.api.nvim_create_autocmd("BufUnload", {
      buffer = 0,
      callback = function()
        vim.opt_local.laststatus = 3
        vim.opt_local.showtabline = 2
      end,
    })
  end,
}