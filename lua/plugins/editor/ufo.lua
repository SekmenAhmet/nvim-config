-- nvim-ufo - Code folding ultra-moderne avec LSP (config simplifiée)
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  config = function()
    -- Configuration minimaliste du folding
    vim.o.foldcolumn = "0" -- Pas de colonne fold pour simplicité
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = false -- Aligne avec options.lua : folds désactivés par défaut

    require("ufo").setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })

    -- Keymaps pour folding
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })
    vim.keymap.set("n", "zp", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek fold or hover" })
  end,
}
