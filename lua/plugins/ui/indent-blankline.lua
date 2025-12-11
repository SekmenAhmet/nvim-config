-- Indent-blankline - Lignes d'indentation visuelles
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup({
      enabled = true,
      debounce = 200,
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "IblIndent",
        smart_indent_cap = true,
        priority = 1,
      },
      whitespace = {
        highlight = "IblWhitespace",
        remove_blankline_trail = true,
      },
      scope = {
        enabled = true,
        char = "│",
        highlight = "IblScope",
        priority = 1024,
        include = {
          node_type = {
            ["*"] = { "*" },
          },
        },
        exclude = {
          language = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm" },
          node_type = {
            ["*"] = { "source_file", "program" },
            lua = { "chunk" },
            python = { "module" },
          },
        },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    })

    -- Configuration des highlights pour s'adapter au thème
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2a2e42" })
      end,
    })

    -- Appliquer immédiatement les couleurs
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2a2e42" })
  end,
}