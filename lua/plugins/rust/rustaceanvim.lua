return {
  "mrcjkb/rustaceanvim",
  version = "*",
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", function() vim.cmd.RustLsp('hover actions') end, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp('codeAction') end, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end, opts)
          vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp('debuggables') end, opts)
          vim.keymap.set("n", "<leader>re", function() vim.cmd.RustLsp('expandMacro') end, opts)
          vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp('openCargo') end, opts)
          vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp('parentModule') end, opts)
          vim.keymap.set("n", "<leader>rj", function() vim.cmd.RustLsp('joinLines') end, opts)
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              command = "clippy",
            },
            inlayHints = {
              bindingModeHints = {
                enable = true,
              },
            },
          },
        },
      },
      tools = {
        test_executor = "neotest",
      },
    }
  end,
}
