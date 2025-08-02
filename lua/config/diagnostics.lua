-- Configuration des diagnostics LSP
-- Séparé de options.lua pour une meilleure organisation

-- Configuration globale des diagnostics
vim.diagnostic.config({
  virtual_text = false,
  float = {
    max_width = 80,
    wrap = true,
    border = "rounded",
    source = "always",
  },
  signs = true,
  underline = true,
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