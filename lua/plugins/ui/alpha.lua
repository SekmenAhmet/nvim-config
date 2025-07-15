-- Alpha - Page d'accueil
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- ASCII Art Header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
      "      🚀 Prêt pour coder ? Choisissez votre mission ! ",
      "                                                     ",
    }

    -- Menu buttons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  Nouveau fichier", ":ene <BAR> startinsert <CR>"),
      dashboard.button("o", "  Fichiers récents", ":Telescope oldfiles <CR>"),
      dashboard.button("f", "  Chercher fichier", ":Telescope find_files <CR>"),
      dashboard.button("g", "  Chercher texte", ":Telescope live_grep <CR>"),
      dashboard.button("s", "  Restaurer session", ":SessionRestore <CR>"),
      dashboard.button("c", "  Configuration", ":e " .. vim.fn.stdpath("config") .. "/init.lua <CR>"),
      dashboard.button("l", "  Lazy", ":Lazy <CR>"),
      dashboard.button("m", "  Mason", ":Mason <CR>"),
      dashboard.button("q", "  Quitter", ":qa <CR>"),
    }

    -- Footer avec des stats
    local function footer()
      local total_plugins = require("lazy").stats().count
      local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return "⚡ " .. total_plugins .. " plugins" .. "   " .. datetime .. "   " .. nvim_version_info
    end

    dashboard.section.footer.val = footer()

    -- Configuration des couleurs
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "Type"

    -- Désactiver le folding sur alpha buffer
    dashboard.opts.opts.noautocmd = true

    -- Configuration finale
    alpha.setup(dashboard.opts)

    -- Auto-commandes pour alpha
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

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