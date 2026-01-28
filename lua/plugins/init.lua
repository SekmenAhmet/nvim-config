return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")

      local function snippet_active()
        return vim.snippet and vim.snippet.active and vim.snippet.active()
      end

      local function snippet_jump(direction)
        if vim.snippet and vim.snippet.jump then
          vim.snippet.jump(direction)
          return true
        end
        return false
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            if vim.snippet and vim.snippet.expand then
              vim.snippet.expand(args.body)
            else
              local text = vim.api.nvim_replace_termcodes(args.body, true, false, true)
              vim.api.nvim_feedkeys(text, "i", true)
            end
          end,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippet_active() then
              snippet_jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippet_active() then
              snippet_jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "native_snippets", priority = 750 },
        }, {
          { name = "buffer", priority = 500, keyword_length = 3 },
          { name = "path", priority = 250 },
        }),
        performance = {
          max_view_entries = 20,
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
      
      -- Register native snippets source
      vim.defer_fn(function()
        local snip_ok, snippets = pcall(require, "config.snippets")
        if snip_ok then
          snippets.register_cmp_source()
        end
      end, 10)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSUpdateSync", "TSInstallSync" },
    opts = {
      ensure_installed = {
        "c",
        "python",
        "lua",
        "bash",
        "vim",
        "vimdoc",
        "query",
      },
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = { "clangd", "pyright", "lua_ls" },
    },
  },
}
