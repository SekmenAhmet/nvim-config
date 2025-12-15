-- Conform - Formatage de code
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      vue = { { "prettierd", "prettier" } },
      svelte = { { "prettierd", "prettier" } },
      astro = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
      json = { { "prettierd", "prettier" } },
      yaml = { { "prettierd", "prettier" } },
      markdown = { { "prettierd", "prettier" } },
      html = { { "prettierd", "prettier" } },
      css = { { "prettierd", "prettier" } },
      scss = { { "prettierd", "prettier" } },
      graphql = { { "prettierd", "prettier" } },
      toml = { "taplo" },
      terraform = { "terraform_fmt" },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      ["*"] = { "lsp" }, -- Fallback pour tous les langages supportés par LSP
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },
  },
}
