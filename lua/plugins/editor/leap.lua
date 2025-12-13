-- leap.nvim - Navigation ultra-rapide type EasyMotion/Hop
return {
  "ggandor/leap.nvim",
  dependencies = { "tpope/vim-repeat" },
  keys = {
    { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
    { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
    { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
  },
  config = function()
    local leap = require("leap")

    -- Configuration
    leap.opts.safe_labels = {}
    leap.opts.labels = { "s", "f", "n", "j", "k", "l", "h", "o", "d", "w", "e", "m", "b", "u", "y", "v", "r", "g", "t", "c", "x", "z", "a", "p", "q", "i" }
    leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

    -- Keymaps
    leap.add_default_mappings()

    -- Leap bidirectionnel (s pour forward, S pour backward)
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

    -- Leap entre toutes les fenêtres
    vim.keymap.set({ "n", "x", "o" }, "gs", function()
      require("leap").leap({ target_windows = vim.tbl_filter(function(win)
        return vim.api.nvim_win_get_config(win).focusable
      end, vim.api.nvim_tabpage_list_wins(0)) })
    end, { desc = "Leap between windows" })
  end,
}
