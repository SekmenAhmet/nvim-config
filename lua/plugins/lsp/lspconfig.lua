-- LSP Configuration avec configuration centralisée et installations Mason
return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local configs = require("lspconfig.configs")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local function setup(server, opts)
      -- Charger la configuration du serveur sans passer par l'__index déprécié
      if configs[server] == nil then
        local ok, config_module = pcall(require, "lspconfig.configs." .. server)
        if ok then
          configs[server] = config_module
        end
      end
      local config_tbl = configs[server]
      if not config_tbl or not config_tbl.setup then
        return
      end
      local config = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts or {})
      config_tbl.setup(config)
    end

    -- Serveurs LSP
    setup("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = { checkThirdParty = false },
          diagnostics = { globals = { "vim" } },
          telemetry = { enable = false },
        },
      },
    })

    setup("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
            autoImportCompletions = true,
            indexing = true,
            logLevel = "Error",
          },
        },
      },
    })

    local ts_server = "ts_ls"
    if configs[ts_server] == nil then
      ts_server = "tsserver"
    end
    setup(ts_server, {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "literals",
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "literals",
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
      },
    })

    setup("gopls", {
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

    setup("clangd", {
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" },
      }),
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--all-scopes-completion",
        "--pch-storage=memory",
        "-j=4",
        "--limit-results=20",
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

    -- Rust géré via rustaceanvim

    setup("dockerls", {
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

    setup("docker_compose_language_service", {
      filetypes = { "yaml.docker-compose" },
    })

    setup("yamlls", {
      filetypes = { "yaml", "yml" },
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

    -- Raccourcis LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
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
