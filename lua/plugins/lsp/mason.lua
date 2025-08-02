-- Mason - Gestionnaire LSP (version ultra-simple)
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
          package_uninstalled = "✗"
        }
      }
    })
    
    -- Auto-installation LSP + Debuggers + Tools pour Rust
    local packages = { 
      "rust-analyzer", 
      "codelldb", -- Debugger Rust
      "pyright", 
      "typescript-language-server", 
      "gopls" 
    }
    
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonLoaded", 
      callback = function()
        local mason_registry = require("mason-registry")
        for _, package in ipairs(packages) do
          if not mason_registry.is_installed(package) then
            mason_registry.get_package(package):install()
          end
        end
      end,
    })
  end,
}