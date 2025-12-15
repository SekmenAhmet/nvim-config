-- Auto Session - Gestion automatique des sessions
return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("auto-session").setup({
      -- Nouvelle syntaxe auto-session (mise à jour)
      enabled = true,
      auto_save = true,
      auto_restore = true,
      auto_create = true,
      auto_restore_last_session = true,
      log_level = "error",
      root_dir = vim.fn.stdpath("data") .. "/sessions/",
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      git_use_branch_name = false,
      bypass_save_filetypes = {
        "alpha",
        "dashboard",
        "NvimTree",
        "Outline",
        "TelescopePrompt",
        "Mason",
        "lazy",
        "help",
        "nofile",
        "terminal",
      },
      session_lens = {
        load_on_setup = true,
        picker_opts = { border = true },
        previewer = false,
      },
      pre_save_cmds = {
        function()
          -- Fermer l'explorateur avant de sauvegarder la session
          pcall(vim.cmd, "Neotree close")
        end,
      },
      post_restore_cmds = {
        function()
          -- Désactiver les folds pour éviter les erreurs
          vim.cmd("set nofoldenable")
        end,
      },
    })

    pcall(require("telescope").load_extension, "session-lens")

    -- Keymaps centralisés dans config/keymaps.lua
  end,
}
