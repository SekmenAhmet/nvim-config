-- ToggleTerm - Terminal intégré
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<C-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = "powershell.exe",
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Fonction pour créer des terminaux spécialisés
    local Terminal = require("toggleterm.terminal").Terminal

    -- Terminal flottant
    local float_term = Terminal:new({
      direction = "float",
      float_opts = {
        border = "double",
      },
    })

    function _float_toggle()
      float_term:toggle()
    end

    -- Terminal horizontal
    local horizontal_term = Terminal:new({
      direction = "horizontal",
      size = 15,
    })

    function _horizontal_toggle()
      horizontal_term:toggle()
    end

    -- Terminal vertical
    local vertical_term = Terminal:new({
      direction = "vertical",
      size = vim.o.columns * 0.4,
    })

    function _vertical_toggle()
      vertical_term:toggle()
    end

    -- Keymaps pour ToggleTerm
    vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
    vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
    vim.keymap.set("n", "<leader>tf", "<cmd>lua _float_toggle()<cr>", { desc = "Toggle floating terminal" })
    vim.keymap.set("n", "<leader>th", "<cmd>lua _horizontal_toggle()<cr>", { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>tv", "<cmd>lua _vertical_toggle()<cr>", { desc = "Toggle vertical terminal" })

    -- Keymaps pour navigation dans le terminal
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}