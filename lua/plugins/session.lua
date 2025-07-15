-- Auto Session - Gestion automatique des sessions
return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = nil,
      auto_restore_enabled = nil,
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
          -- Commandes à exécuter après la restauration d'une session
          -- Peut être utile pour rouvrir certains plugins ou fenêtres
        end,
      },
    })

    -- Keymaps pour auto-session
    vim.keymap.set("n", "<leader>qs", ":SessionSave<CR>", { desc = "Save session" })
    vim.keymap.set("n", "<leader>qr", ":SessionRestore<CR>", { desc = "Restore session" })
    vim.keymap.set("n", "<leader>qd", ":SessionDelete<CR>", { desc = "Delete session" })
    vim.keymap.set("n", "<leader>qf", ":Autosession search<CR>", { desc = "Find sessions" })
    vim.keymap.set("n", "<leader>qp", ":SessionPurgeOrphaned<CR>", { desc = "Purge orphaned sessions" })
  end,
}