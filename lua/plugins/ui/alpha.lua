-- Alpha - Page d'accueil
return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    
    -- Fonctions utilitaires
    local function get_current_time()
      return os.date("%H:%M")
    end
    
    local function get_current_date()
      return os.date("%A, %B %d, %Y")
    end
    
    local function get_git_status()
      local ok, handle = pcall(io.popen, "git rev-parse --abbrev-ref HEAD 2>/dev/null")
      if not ok or not handle then
        return "󰊢 No Git Repository"
      end
      
      local branch = handle:read("*a"):gsub("\n", "")
      handle:close()
      
      if branch == "" then
        return "󰊢 No Git Repository"
      end
      
      return string.format("󰊢 %s", branch)
    end
    
    local function get_nvim_stats()
      local plugins_count = 0
      local ok, lazy = pcall(require, "lazy")
      if ok then
        plugins_count = vim.tbl_count(lazy.plugins() or {})
      end
      return string.format("󰂖 %d plugins loaded", plugins_count)
    end

    -- ASCII Art Header clean et aligné
    -- dashboard.section.header.val = {
    --   "",
    --   "",
    --   "",
    --   "",
    --   "",
    --   "",
    --   "    ╔═════════════════════════════════════════════╗",
    --   "    ║                                             ║",
    --   "    ║  ███████╗████████╗ █████╗ ██████╗ ████████╗ ║",
    --   "    ║  ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝ ║",
    --   "    ║  ███████╗   ██║   ███████║██████╔╝   ██║    ║",
    --   "    ║  ╚════██║   ██║   ██╔══██║██╔══██╗   ██║    ║",
    --   "    ║  ███████║   ██║   ██║  ██║██║  ██║   ██║    ║",
    --   "    ║  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ║",
    --   "    ║                                             ║",
    --   "    ║                 Ready to code?              ║",
    --   "    ║                                             ║",
    --   "    ╚═════════════════════════════════════════════╝",
    -- }

    -- Header dynamique avec infos
    local function create_dynamic_header()
      local time = get_current_time()
      local date = get_current_date()
      local git_info = get_git_status()
      local nvim_info = get_nvim_stats()
      
      return {
        "",
        "",
        "",
        "",
        "    ██╗  ██╗███████╗██╗     ██╗      ██████╗     ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗ ██╗",
        "    ██║  ██║██╔════╝██║     ██║     ██╔═══██╗    ██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗██║",
        "    ███████║█████╗  ██║     ██║     ██║   ██║    ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║██║",
        "    ██╔══██║██╔══╝  ██║     ██║     ██║   ██║    ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║╚═╝",
        "    ██║  ██║███████╗███████╗███████╗╚██████╔╝    ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝██╗",
        "    ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝      ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝",
        "",
        "",
        "",
        "                                ╔═════════════════════════════╗",
        "                                ║       Ready to code ?       ║",
        "                                ╚═════════════════════════════╝",
      }
    end
    
    dashboard.section.header.val = create_dynamic_header()

    -- Pas de boutons
    dashboard.section.buttons.opts.enabled = false

    -- Footer avec raccourcis utiles
    dashboard.section.footer.val = {
      "╭─────────────────────────────────────────────────────────────╮",
      "│                       QUICK SHORTCUTS                       │",
      "├─────────────────────────────────────────────────────────────┤",
      "│  SPC f f → Find Files        │  SPC g g → Git Status        │",
      "│  SPC f r → Recent Files      │  SPC l → Lazy Plugin Manager │",
      "│  SPC p → Projects            │  SPC s → Settings            │",
      "╰─────────────────────────────────────────────────────────────╯",
    }

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
