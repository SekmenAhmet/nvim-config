-- Mason - Gestionnaire LSP / Linters / Formatters
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = "Mason",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local ensure_installed = {
      -- LSP
      "clangd",
      "dockerfile-language-server",
      "docker-compose-language-service",
      "gopls",
      "jdtls",
      "lua-language-server",
      "pyright",
      "rust-analyzer",
      "typescript-language-server",
      "yaml-language-server",
      -- Debuggers
      "codelldb",
      "debugpy",
      -- Linters / Formatters
      "black",
      "clang-format",
      "eslint_d",
      "hadolint",
      "isort",
      "prettierd",
      "ruff",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamllint",
    }

    -- gopls nécessite Go installé sur la machine
    if vim.fn.executable("go") == 0 then
      ensure_installed = vim.tbl_filter(function(name)
        return name ~= "gopls"
      end, ensure_installed)
      vim.notify("Go non détecté dans $PATH : gopls ignoré. Installe Go puis relance Mason si besoin.", vim.log.levels.WARN, { title = "Mason" })
    end

    local function install_missing()
      local registry = require("mason-registry")
      for _, name in ipairs(ensure_installed) do
        local ok, package = pcall(registry.get_package, name)
        if ok and not package:is_installed() then
          package:install()
        end
      end
    end

    local registry = require("mason-registry")
    if registry.refresh then
      registry.refresh(install_missing)
    else
      install_missing()
    end
  end,
}
