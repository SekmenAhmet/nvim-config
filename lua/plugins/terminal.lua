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

    -- Keymaps centralisés dans config/keymaps.lua
    -- Les fonctions restent accessibles globalement
    _G._FLOAT_TERM = float_term
    _G._HORIZONTAL_TERM = horizontal_term
    _G._VERTICAL_TERM = vertical_term
  end,
}