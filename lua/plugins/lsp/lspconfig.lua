-- LSP Configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Configuration Python
    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          }
        }
      }
    })

    -- Configuration TypeScript
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      }
    })

    -- Configuration Go
    lspconfig.gopls.setup({
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            unreachable = true,
            fillstruct = true,
          },
          staticcheck = true,
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })

    -- Configuration Rust
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            allFeatures = true,
          },
          procMacro = {
            enable = true,
          },
          checkOnSave = {
            command = "clippy",
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = "never",
              useParameterNames = false,
            },
            expressionAdjustmentHints = {
              enable = "never",
            },
            reborrowHints = {
              enable = "never",
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
            parameterHints = {
              enable = true,
            },
            chainingHints = {
              enable = true,
            },
            maxLength = 25,
          },
          lens = {
            enable = true,
          },
          hover = {
            actions = {
              enable = true,
            },
          },
          semanticHighlighting = {
            strings = {
              enable = true,
            },
          },
          completion = {
            postfix = {
              enable = true,
            },
            privateEditable = {
              enable = false,
            },
            callable = {
              snippets = "fill_arguments",
            },
          },
        },
      },
    })

    -- Configuration Java
    lspconfig.jdtls.setup({
      capabilities = capabilities,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          compile = {
            nullAnalysis = {
              mode = "automatic",
            },
          },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
        },
      },
    })

    -- Configuration Docker
    lspconfig.dockerls.setup({
      capabilities = capabilities,
      settings = {
        docker = {
          languageserver = {
            formatter = {
              ignoreMultilineInstructions = true,
            },
          },
        },
      },
    })

    -- Configuration Docker Compose
    lspconfig.docker_compose_language_service.setup({
      capabilities = capabilities,
      settings = {},
    })

    -- Configuration YAML
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yaml",
          },
          format = {
            enable = true,
          },
          validate = true,
          completion = true,
          hover = true,
        },
      },
    })

    -- Keymaps LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      end,
    })
  end,
}