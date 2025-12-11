-- which-key.nvim - Affiche les raccourcis clavier disponibles
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      preset = "modern",
      delay = 300,
      expand = 1,
      notify = true,
      replace = {
        key = {
          { "<Space>", "SPC" },
          { "<cr>", "RET" },
          { "<tab>", "TAB" },
        },
      },
      spec = {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>e", group = "Explorer/Edit" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>q", group = "Session" },
        { "<leader>r", group = "Rust" },
        { "<leader>t", group = "Theme" },
        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>6", hidden = true },
        { "<leader>7", hidden = true },
        { "<leader>8", hidden = true },
        { "<leader>9", hidden = true },
      },
    })

    -- Enregistrement manuel des keymaps avec descriptions
    wk.add({
      -- Buffers
      { "<leader>bd", desc = "Pick buffer to close" },
      { "<leader>bp", desc = "Pick buffer to go to" },
      { "<leader>bse", desc = "Sort buffers by extension" },
      { "<leader>bsd", desc = "Sort buffers by directory" },
      
      -- Explorer/Tree
      { "<leader>ef", desc = "Toggle explorer on current file" },
      { "<leader>ec", desc = "Collapse file explorer" },
      { "<leader>er", desc = "Refresh file explorer" },
      
      -- Find/Search
      { "<leader>fb", desc = "Find buffers" },
      { "<leader>fc", desc = "Find word under cursor" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>fo", desc = "Recent files" },
      { "<leader>fs", desc = "Search in current buffer" },
      
      -- Git
      { "<leader>gb", desc = "Git branches" },
      { "<leader>gc", desc = "Git commits" },
      
      -- Sessions
      { "<leader>qd", desc = "Delete session" },
      { "<leader>qf", desc = "Find sessions" },
      { "<leader>qp", desc = "Purge orphaned sessions" },
      { "<leader>qr", desc = "Restore session" },
      { "<leader>qs", desc = "Save session" },
      
      -- Code actions
      { "<leader>ca", desc = "Code actions" },
      
      -- Terminal
      { "<leader>tf", desc = "Floating terminal" },
      { "<leader>th", desc = "Horizontal terminal" },
      { "<leader>tv", desc = "Vertical terminal" },
      
      -- TreeSitter
      { "<leader>a", desc = "Swap parameter next" },
      { "<leader>A", desc = "Swap parameter previous" },

      -- Themes
      { "<leader>th", desc = "Switch theme" },

      -- Rust
      { "<leader>rr", desc = "Runnables" },
      { "<leader>rd", desc = "Debuggables" },
      { "<leader>re", desc = "Expand macro" },
      { "<leader>rc", desc = "Open Cargo.toml" },
      { "<leader>rp", desc = "Parent module" },
      { "<leader>rj", desc = "Join lines" },
      { "<leader>rn", desc = "Rename" },
    })

    -- Keymaps pour les modes spéciaux
    wk.add({
      mode = { "v" },
      { "S", desc = "Surround selection" },
      { "gc", desc = "Comment selection" },
      { "gb", desc = "Block comment selection" },
    })

    -- Keymaps de navigation
    wk.add({
      { "]m", desc = "Next function" },
      { "[m", desc = "Previous function" },
      { "]]", desc = "Next class" },
      { "[[", desc = "Previous class" },
      { "]o", desc = "Next loop" },
      { "[o", desc = "Previous loop" },
      { "]s", desc = "Next scope" },
      { "[s", desc = "Previous scope" },
      { "]z", desc = "Next fold" },
      { "[z", desc = "Previous fold" },
    })

    -- LSP keymaps
    wk.add({
      { "gD", desc = "Go to declaration" },
      { "gd", desc = "Go to definition" },
      { "gi", desc = "Go to implementation" },
      { "gr", desc = "Go to references" },
      { "K", desc = "Hover documentation" },
    })

    -- Surround keymaps (exemples)
    wk.add({
      { "ds", desc = "Delete surrounding" },
      { "cs", desc = "Change surrounding" },
      { "ys", desc = "Add surrounding" },
      { "yss", desc = "Add surrounding to line" },
    })

    -- Comment keymaps
    wk.add({
      { "gcc", desc = "Toggle line comment" },
      { "gbc", desc = "Toggle block comment" },
      { "gcO", desc = "Comment above" },
      { "gco", desc = "Comment below" },
      { "gcA", desc = "Comment end of line" },
    })
  end,
}