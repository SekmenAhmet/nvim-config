-- Rust-Tools.nvim - Actions avancées et intégration parfaite
return {
  "simrat39/rust-tools.nvim",
  ft = "rust",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local rt = require("rust-tools")
    
    -- Configuration DAP simplifiée (codelldb sera configuré plus tard)
    local dap_config = nil
    
    -- Essayer de configurer codelldb si disponible
    local ok, mason_registry = pcall(require, "mason-registry")
    if ok then
      local codelldb_ok, codelldb_pkg = pcall(mason_registry.get_package, mason_registry, "codelldb")
      if codelldb_ok and codelldb_pkg:is_installed() then
        local codelldb_root = codelldb_pkg:get_install_path() .. "/extension/"
        local codelldb_path = codelldb_root .. "adapter/codelldb.exe"
        local liblldb_path = codelldb_root .. "lldb/bin/liblldb.dll"
        dap_config = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      end
    end
    
    rt.setup({
      -- Configuration DAP pour debugging
      dap = dap_config and {
        adapter = dap_config,
      } or {},
      
      -- Configuration serveur LSP avancée
      server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(client, bufnr)
          
          local opts = { buffer = bufnr, silent = true }
          
          -- === NAVIGATION AVANCÉE ===
          vim.keymap.set("n", "gd", rt.hover_actions.hover_actions, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))
          vim.keymap.set("n", "K", rt.hover_actions.hover_actions, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))
          vim.keymap.set("n", "<leader>ra", rt.code_action_group.code_action_group, vim.tbl_extend("force", opts, { desc = "Rust code actions" }))
          
          -- === DEBUGGING ===
          vim.keymap.set("n", "<leader>rd", rt.debuggables.debuggables, vim.tbl_extend("force", opts, { desc = "Rust debug" }))
          vim.keymap.set("n", "<F5>", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "Debug continue" }))
          vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "Debug step over" }))
          vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "Debug step into" }))
          vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "Debug step out" }))
          vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
          
          -- === RUST SPÉCIFIQUE ===
          vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
          vim.keymap.set("n", "<leader>rt", rt.runnables.runnables, vim.tbl_extend("force", opts, { desc = "Rust test" }))
          vim.keymap.set("n", "<leader>re", rt.expand_macro.expand_macro, vim.tbl_extend("force", opts, { desc = "Rust expand macro" }))
          vim.keymap.set("n", "<leader>rc", rt.open_cargo_toml.open_cargo_toml, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
          vim.keymap.set("n", "<leader>rp", rt.parent_module.parent_module, vim.tbl_extend("force", opts, { desc = "Parent module" }))
          vim.keymap.set("n", "<leader>rj", rt.join_lines.join_lines, vim.tbl_extend("force", opts, { desc = "Join lines" }))
          vim.keymap.set("n", "<leader>rh", rt.hover_range.hover_range, vim.tbl_extend("force", opts, { desc = "Hover range" }))
          
          -- === CARGO COMMANDES ===
          vim.keymap.set("n", "<leader>cb", "<cmd>!cargo build<cr>", vim.tbl_extend("force", opts, { desc = "Cargo build" }))
          vim.keymap.set("n", "<leader>cr", "<cmd>!cargo run<cr>", vim.tbl_extend("force", opts, { desc = "Cargo run" }))
          vim.keymap.set("n", "<leader>ct", "<cmd>!cargo test<cr>", vim.tbl_extend("force", opts, { desc = "Cargo test" }))
          vim.keymap.set("n", "<leader>cc", "<cmd>!cargo check<cr>", vim.tbl_extend("force", opts, { desc = "Cargo check" }))
          vim.keymap.set("n", "<leader>cl", "<cmd>!cargo clippy<cr>", vim.tbl_extend("force", opts, { desc = "Cargo clippy" }))
          vim.keymap.set("n", "<leader>cf", "<cmd>!cargo fmt<cr>", vim.tbl_extend("force", opts, { desc = "Cargo format" }))
          vim.keymap.set("n", "<leader>cu", "<cmd>!cargo update<cr>", vim.tbl_extend("force", opts, { desc = "Cargo update" }))
        end,
        
        settings = {
          ["rust-analyzer"] = {
            -- === PERFORMANCE OPTIMISÉE ===
            cachePriming = {
              enable = true,
              numThreads = 8,
            },
            files = {
              excludeDirs = { "target", ".git", ".vscode", "node_modules", ".direnv" },
            },
            
            -- === CARGO AVANCÉ ===
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            
            -- === PROCMACROS ===
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            
            -- === CLIPPY INTELLIGENT ===
            checkOnSave = true,
            check = {
              command = "clippy",
              extraArgs = { 
                "--", 
                "-W", "clippy::all",
                "-W", "clippy::pedantic",
                "-A", "clippy::module_name_repetitions",
                "-A", "clippy::too_many_arguments",
                "-A", "clippy::type_complexity",
              },
            },
            
            -- === DIAGNOSTICS AVANCÉS ===
            diagnostics = {
              enable = true,
              enableExperimental = true,
              disabled = { "unresolved-proc-macro" },
              warningsAsHint = {},
              warningsAsInfo = {},
            },
            
            -- === COMPLETION PARFAITE ===
            completion = {
              autoimport = {
                enable = true,
              },
              callable = {
                snippets = "fill_arguments",
              },
              postfix = {
                enable = true,
              },
              privateEditable = {
                enable = true,
              },
            },
            
            -- === INLAY HINTS OPTIMISÉS ===
            inlayHints = {
              bindingModeHints = {
                enable = true,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "with_block",
              },
              discriminantHints = {
                enable = "fieldless",
              },
              lifetimeElisionHints = {
                enable = "skip_trivial",
                useParameterNames = true,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "mutable",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
            
            -- === LENS ET ACTIONS ===
            lens = {
              enable = true,
              debug = {
                enable = true,
              },
              implementations = {
                enable = true,
              },
              references = {
                adt = {
                  enable = true,
                },
                enumVariant = {
                  enable = true,
                },
                method = {
                  enable = true,
                },
                trait = {
                  enable = true,
                },
              },
              run = {
                enable = true,
              },
            },
            
            -- === IMPORTS INTELLIGENTS ===
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
              merge = {
                blob = 20,
              },
            },
            
            -- === ASSIST ET REFACTORING ===
            assist = {
              importEnforceGranularity = true,
              importPrefix = "plain",
              emitMustUse = true,
            },
          },
        },
      },
      
      -- Configuration outils
      tools = {
        -- Hover actions dans popup flottant
        hover_actions = {
          border = "rounded",
          width = 60,
          height = 10,
        },
        
        -- Inlay hints visuels
        inlay_hints = {
          auto = true,
          only_current_line = false,
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        
        -- Runnables dans Telescope
        runnables = {
          use_telescope = true,
        },
        
        -- Debuggables dans Telescope  
        debuggables = {
          use_telescope = true,
        },
      },
    })
  end,
}