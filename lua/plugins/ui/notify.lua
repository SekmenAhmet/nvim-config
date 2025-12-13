-- Nvim-notify - Notifications esthétiques
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")

    notify.setup({
      background_colour = "#000000",
      fps = 30,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
      level = 2,
      minimum_width = 30,
      max_width = 50,
      max_height = 10,
      render = "compact",
      stages = "slide", -- Slide from top-right corner
      timeout = 2500,
      top_down = false, -- Stack from top-right
    })

    -- Remplacer vim.notify par nvim-notify
    vim.notify = notify

    -- Keymaps pour gérer l'historique des notifications
    vim.keymap.set("n", "<leader>un", function()
      require("notify").dismiss({ silent = true, pending = true })
    end, { desc = "Dismiss all notifications" })

    vim.keymap.set("n", "<leader>uh", function()
      require("telescope").extensions.notify.notify()
    end, { desc = "Show notification history" })
  end,
}
