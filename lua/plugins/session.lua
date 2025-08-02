-- Auto Session - Gestion automatique des sessions
return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = false, -- Désactiver la restauration automatique
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "C:\\", "C:\\Users", "C:\\Users\\sekme" },
      auto_session_use_git_branch = false,
      bypass_session_save_file_types = {
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
      auto_session_create_enabled = true,
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
      pre_save_cmds = {
        function()
          -- Fermer nvim-tree avant de sauvegarder la session
          if vim.bo.filetype == "NvimTree" then
            vim.cmd("NvimTreeClose")
          end
        end,
      },
      post_restore_cmds = {
        function()
          -- Désactiver les folds pour éviter les erreurs
          vim.cmd("set nofoldenable")
        end,
      },
    })

    -- Keymaps centralisés dans config/keymaps.lua
  end,
}