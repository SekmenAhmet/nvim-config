-- LSP Configuration avec chargement conditionnel
return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  event = { "BufReadPre", "BufNewFile" },
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

    -- Python - seulement sur fichiers .py (OPTIMISÉ pour rapidité)
    setup_lsp_for_filetype("pyright", { "python" }, {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off", -- "basic" → "off" pour vitesse maximale
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly", -- Analyse seulement les fichiers ouverts
            autoImportCompletions = true,
            -- Performance optimisée
            indexing = true,
            logLevel = "Error",
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

    -- C/C++ - seulement sur fichiers .c/.cpp/.h/.hpp (OPTIMISÉ)
    setup_lsp_for_filetype("clangd", { "c", "cpp", "objc", "objcpp", "cuda" }, {
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" }, -- clangd nécessite utf-16
      }),
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=bundled", -- "detailed" → "bundled" pour vitesse
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--all-scopes-completion",
        "--pch-storage=memory",
        "-j=4", -- Utilise 4 threads pour rapidité
        "--limit-results=20", -- Limite à 20 résultats pour vitesse
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
      settings = {
        clangd = {
          InlayHints = {
            Designators = true,
            Enabled = true,
            ParameterNames = true,
            DeducedTypes = true,
          },
          fallbackFlags = { "-std=c++20" },
        },
      },
    })

    -- Rust - Géré par rustaceanvim (voir plugins/rust/)

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