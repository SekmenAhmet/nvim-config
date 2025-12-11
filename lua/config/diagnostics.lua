-- Configuration des diagnostics LSP
-- Séparé de options.lua pour une meilleure organisation

-- Configuration des diagnostics CLEAN - seulement popup au hover
vim.diagnostic.config({
  virtual_text = false, -- Retire toutes les erreurs inline
  float = {
    max_width = 120,
    wrap = true,
    border = "double",
    source = "never", -- Pas de source affichée
    header = "", -- Pas de header
    focusable = true,
    style = "minimal",
    suffix = "",
    format = function(diagnostic)
      -- Message simple sans encadrement
      return diagnostic.message
    end,
  },
  signs = false, -- Retire toutes les icônes dans la marge
  underline = true, -- Garde les soulignements
  update_in_insert = false,
  severity_sort = true,
})

-- Keymaps pour les diagnostics
local keymap = vim.keymap.set

-- Affichage manuel des diagnostics
keymap("n", "<leader>cd", function()
  vim.diagnostic.open_float(nil, {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
  })
end, { desc = "Show diagnostic" })

-- Navigation dans les diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Auto-hover clean : popup simple au survol
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "double",
      source = "never",
      prefix = "",
      scope = "cursor",
      header = "",
    }
    vim.diagnostic.open_float(nil, opts)
  end
})