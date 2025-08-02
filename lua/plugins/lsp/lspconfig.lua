-- LSP Configuration avec chargement conditionnel
return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  ft = { "python", "javascript", "typescript", "typescriptreact", "go", "rust", "java", "dockerfile", "yaml" },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Fonction helper pour setup conditionnel
    local function setup_lsp_for_filetype(server, filetypes, config)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
          lspconfig[server].setup(config)
        end,
        once = true,
      })
    end

    -- Python - seulement sur fichiers .py
    setup_lsp_for_filetype("pyright", { "python" }, {
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

    -- TypeScript/JavaScript - seulement sur fichiers .ts/.js/.tsx/.jsx
    setup_lsp_for_filetype("ts_ls", { "javascript", "typescript", "typescriptreact", "javascriptreact" }, {
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "literals",
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "literals",
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          }
        }
      }
    })

    -- Go - seulement sur fichiers .go
    setup_lsp_for_filetype("gopls", { "go" }, {
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
            assignVariableTypes = false,
            compositeLiteralFields = false,
            compositeLiteralTypes = false,
            constantValues = false,
            functionTypeParameters = false,
            parameterNames = false,
            rangeVariableTypes = false,
          },
          usePlaceholders = true,
          completeUnimported = true,
          importShortcut = "Both",
          symbolMatcher = "FastFuzzy",
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })

    -- Rust - seulement sur fichiers .rs
    setup_lsp_for_filetype("rust_analyzer", { "rust" }, {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        client.server_capabilities.codeLensProvider = nil
      end,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            loadOutDirsFromCheck = false,
            allFeatures = false,
          },
          procMacro = {
            enable = true,
          },
          checkOnSave = {
            command = "check",
          },
          diagnostics = {
            enable = true,
            experimental = {
              enable = false,
            },
          },
          completion = {
            callable = {
              snippets = "fill_arguments",
            },
            autoimport = {
              enable = true,
            },
          },
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          assist = {
            importEnforceGranularity = true,
            importPrefix = "plain",
          },
          inlayHints = {
            typeHints = {
              enable = false,
            },
            parameterHints = {
              enable = false,
            },
            chainingHints = {
              enable = false,
            },
          },
        },
      },
    })

    -- Java - seulement sur fichiers .java
    setup_lsp_for_filetype("jdtls", { "java" }, {
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
              enabled = "none",
            },
          },
        },
      },
    })

    -- Docker - seulement sur Dockerfile
    setup_lsp_for_filetype("dockerls", { "dockerfile" }, {
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

    -- Docker Compose - seulement sur docker-compose.yml
    setup_lsp_for_filetype("docker_compose_language_service", { "yaml" }, {
      capabilities = capabilities,
      settings = {},
    })

    -- YAML - seulement sur fichiers .yml/.yaml
    setup_lsp_for_filetype("yamlls", { "yaml" }, {
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
        vim.keymap.set("n", "<leader>oi", function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
        end, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      end,
    })
  end,
}