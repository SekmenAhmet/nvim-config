-- Lualine - Statusline moderne et performante
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lualine = require("lualine")

    -- Configuration personnalisée avec intégration LSP, DAP, et modes
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "auto", -- S'adapte au thème actuel (tokyonight/catppuccin)
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true, -- Une seule statusline pour tous les splits
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        -- Gauche: Mode + Branch + Diff
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        -- Centre: Diagnostics
        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic" },
            sections = { "error", "warn", "info", "hint" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
          {
            "filename",
            file_status = true,
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            shorting_target = 40,
            symbols = {
              modified = "[+]",
              readonly = "[-]",
              unnamed = "[No Name]",
            },
          },
        },
        -- Droite: LSP + Formatters + Position
        lualine_x = {
          {
            -- Affiche les serveurs LSP actifs
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return "LSP Inactive"
              end

              local buf_client_names = {}
              for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" and client.name ~= "copilot" then
                  table.insert(buf_client_names, client.name)
                end
              end

              local unique_client_names = table.concat(buf_client_names, ", ")
              return "LSP: " .. unique_client_names
            end,
            icon = "",
            color = { gui = "bold" },
          },
          {
            -- Affiche le statut DAP
            function()
              local dap_status = require("dap").status()
              if dap_status ~= "" then
                return "DAP: " .. dap_status
              end
              return ""
            end,
            icon = "",
            color = { fg = "#e06c75" },
            cond = function()
              local ok, dap = pcall(require, "dap")
              return ok and dap.status() ~= ""
            end,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "neo-tree", "lazy", "mason", "trouble", "toggleterm" },
    })
  end,
}
