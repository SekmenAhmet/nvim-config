-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Configuration de base
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options de base
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- Navigation entre fenêtres
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Mason pour la gestion des LSP
    {
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
      end,
    },

    -- LSP Configuration
    {
      "neovim/nvim-lspconfig",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Configuration Python (nécessite pyright installé : npm install -g pyright)
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

        -- Configuration TypeScript (nécessite typescript-language-server : npm install -g typescript typescript-language-server)
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

        -- Configuration Go (nécessite gopls : go install golang.org/x/tools/gopls@latest)
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

        -- Configuration Rust (nécessite rust-analyzer : rustup component add rust-analyzer)
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

        -- Configuration Java (nécessite jdtls via Mason ou installation manuelle)
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

        -- Configuration Docker (nécessite dockerfile-language-server : npm install -g dockerfile-language-server-nodejs)
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

        -- Configuration Docker Compose (nécessite docker-compose-language-service : npm install -g @microsoft/compose-language-service)
        lspconfig.docker_compose_language_service.setup({
          capabilities = capabilities,
          settings = {},
        })

        -- Configuration YAML (pour docker-compose.yml)
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
    },

    -- Autocomplétion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Charger les snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
          formatting = {
            format = function(entry, vim_item)
              vim_item.kind = string.format('%s %s', vim_item.kind, vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end
          },
        })

        -- Configuration pour la ligne de commande
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })
      end,
    },

    -- nvim-tree - Explorateur de fichiers
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- Désactiver netrw au démarrage
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
          sort = {
            sorter = "case_sensitive",
          },
          view = {
            width = 30,
            relativenumber = true,
          },
          renderer = {
            group_empty = true,
            icons = {
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
              },
            },
          },
          filters = {
            dotfiles = false,
            git_ignored = false,
          },
          git = {
            enable = true,
            ignore = false,
            timeout = 400,
          },
          actions = {
            open_file = {
              quit_on_open = false,
              resize_window = true,
            },
          },
          update_focused_file = {
            enable = true,
            update_root = false,
            ignore_list = {},
          },
          diagnostics = {
            enable = true,
            show_on_dirs = false,
            debounce_delay = 50,
            severity = {
              min = vim.diagnostic.severity.HINT,
              max = vim.diagnostic.severity.ERROR,
            },
            icons = {
              hint = "H",
              info = "I",
              warning = "W",
              error = "E",
            },
          },
        })

        -- Keymaps pour nvim-tree
        vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
        vim.keymap.set("n", "<leader>ec", ":NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
        vim.keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
      end,
    },

    -- Icons pour nvim-tree
    {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({
          override = {},
          default = true,
        })
      end,
    },

    -- Telescope - Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = { 
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        require("telescope").setup({
          defaults = {
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
            },
            prompt_prefix = "   ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
              },
              vertical = {
                mirror = false,
              },
              width = 0.87,
              height = 0.80,
              preview_cutoff = 120,
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = { "node_modules", "%.git/", "target/", "%.git\\", "target\\", "build/", "%.class" },
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            mappings = {
              n = { ["q"] = require("telescope.actions").close },
            },
          },
          pickers = {
            find_files = {
              theme = "dropdown",
              previewer = false,
            },
            live_grep = {
              theme = "ivy",
            },
            buffers = {
              theme = "dropdown",
              previewer = false,
              initial_mode = "normal",
              mappings = {
                i = {
                  ["<C-d>"] = require("telescope.actions").delete_buffer,
                },
                n = {
                  ["dd"] = require("telescope.actions").delete_buffer,
                },
              },
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
          },
        })

        -- Charger les extensions
        require("telescope").load_extension("fzf")

        -- Keymaps pour Telescope
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>e", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<C-e>", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
        vim.keymap.set("n", "<leader>fs", builtin.current_buffer_fuzzy_find, { desc = "Telescope search in current buffer" })
        vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope old files" })
        vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Telescope grep string under cursor" })
        vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Telescope git commits" })
        vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Telescope git branches" })
      end,
    },

    -- Dépendance pour Telescope
    {
      "nvim-lua/plenary.nvim",
    },

    -- Extension FZF pour Telescope (améliore les performances)
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },

    -- ToggleTerm - Terminal intégré
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          size = 20,
          open_mapping = [[<C-i>]],
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 2,
          start_in_insert = true,
          insert_mappings = true,
          terminal_mappings = true,
          persist_size = true,
          persist_mode = true,
          direction = "float",
          close_on_exit = true,
          shell = "powershell.exe",
          auto_scroll = true,
          float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
              border = "Normal",
              background = "Normal",
            },
          },
        })

        -- Fonction pour créer des terminaux spécialisés
        local Terminal = require("toggleterm.terminal").Terminal

        -- Terminal flottant
        local float_term = Terminal:new({
          direction = "float",
          float_opts = {
            border = "double",
          },
        })

        function _float_toggle()
          float_term:toggle()
        end

        -- Terminal horizontal
        local horizontal_term = Terminal:new({
          direction = "horizontal",
          size = 15,
        })

        function _horizontal_toggle()
          horizontal_term:toggle()
        end

        -- Terminal vertical
        local vertical_term = Terminal:new({
          direction = "vertical",
          size = vim.o.columns * 0.4,
        })

        function _vertical_toggle()
          vertical_term:toggle()
        end

        -- Keymaps pour ToggleTerm
        vim.keymap.set("n", "<C-i>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
        vim.keymap.set("t", "<C-i>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
        vim.keymap.set("n", "<leader>tf", "<cmd>lua _float_toggle()<cr>", { desc = "Toggle floating terminal" })
        vim.keymap.set("n", "<leader>th", "<cmd>lua _horizontal_toggle()<cr>", { desc = "Toggle horizontal terminal" })
        vim.keymap.set("n", "<leader>tv", "<cmd>lua _vertical_toggle()<cr>", { desc = "Toggle vertical terminal" })

        -- Keymaps pour navigation dans le terminal
        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      end,
    },

    -- Autopairs - Auto-completion des paires de caractères
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({
          check_ts = true,
          ts_config = {
            lua = {'string', 'source'},
            javascript = {'string', 'template_string'},
            java = false,
          },
          disable_filetype = { "TelescopePrompt", "spectre_panel" },
          disable_in_macro = true,
          disable_in_visualblock = false,
          disable_in_replace_mode = true,
          ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
          enable_moveright = true,
          enable_afterquote = true,
          enable_check_bracket_line = true,
          enable_bracket_in_quote = true,
          enable_abbr = false,
          break_undo = true,
          check_comma = true,
          map_cr = true,
          map_bs = true,
          map_c_h = false,
          map_c_w = false,
        })

        -- Règles personnalisées pour différents types de fichiers
        local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')

        -- Règle pour les backticks en markdown
        npairs.add_rule(Rule('`', '`', 'markdown'))
        
        -- Règle pour les triple backticks en markdown
        npairs.add_rule(Rule('```', '```', 'markdown'))
        
        -- Règle pour les dollar signs en LaTeX/markdown (math mode)
        npairs.add_rule(Rule('$', '$', {'tex', 'latex', 'markdown'}))
        
        -- Règle pour les angles brackets
        npairs.add_rule(Rule('<', '>', {'html', 'xml', 'vue', 'typescript', 'javascript', 'rust'}))
        
        -- Amélioration pour les fonctions fléchées
        npairs.add_rule(Rule('%(.*%)%s*%=>$', ' {', {'typescript', 'javascript'}):use_regex(true):set_end_pair_length(1))
      end,
    },

    -- Bufferline - Onglets pour les buffers
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            mode = "buffers",
            style_preset = require("bufferline").style_preset.default,
            themable = true,
            numbers = "none",
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            indicator = {
              icon = "▎",
              style = "icon",
            },
            buffer_close_icon = "󰅖",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 30,
            max_prefix_length = 30,
            truncate_names = true,
            tab_size = 21,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              if context.buffer:current() then
                return ""
              end
              return "(" .. count .. ")"
            end,
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            show_duplicate_prefix = true,
            persist_buffer_sort = true,
            move_wraps_at_ends = false,
            separator_style = "slant",
            enforce_regular_tabs = true,
            always_show_bufferline = true,
            hover = {
              enabled = true,
              delay = 200,
              reveal = {'close'}
            },
            sort_by = 'insert_after_current',
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
              }
            },
          },
        })

        -- Keymaps pour bufferline
        vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
        vim.keymap.set("n", "<leader>bd", ":BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
        vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick buffer to go to" })
        vim.keymap.set("n", "<leader>bse", ":BufferLineSortByExtension<CR>", { desc = "Sort buffers by extension" })
        vim.keymap.set("n", "<leader>bsd", ":BufferLineSortByDirectory<CR>", { desc = "Sort buffers by directory" })
        
        -- Navigation rapide vers buffers 1-9
        for i = 1, 9 do
          vim.keymap.set("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
        end
      end,
    },

    -- Indent-blankline - Lignes d'indentation visuelles
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
        require("ibl").setup({
          enabled = true,
          debounce = 200,
          indent = {
            char = "│",
            tab_char = "│",
            highlight = "IblIndent",
            smart_indent_cap = true,
            priority = 1,
          },
          whitespace = {
            highlight = "IblWhitespace",
            remove_blankline_trail = true,
          },
          scope = {
            enabled = true,
            char = "│",
            highlight = "IblScope",
            priority = 1024,
            include = {
              node_type = {
                ["*"] = { "*" },
              },
            },
            exclude = {
              language = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm" },
              node_type = {
                ["*"] = { "source_file", "program" },
                lua = { "chunk" },
                python = { "module" },
              },
            },
          },
          exclude = {
            filetypes = {
              "help",
              "alpha",
              "dashboard",
              "neo-tree",
              "Trouble",
              "trouble",
              "lazy",
              "mason",
              "notify",
              "toggleterm",
              "lazyterm",
              "NvimTree",
            },
            buftypes = { "terminal", "nofile", "quickfix", "prompt" },
          },
        })

        -- Configuration des highlights pour s'adapter au thème
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
            vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2a2e42" })
          end,
        })

        -- Appliquer immédiatement les couleurs
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2a2e42" })
      end,
    },

    -- Comment.nvim - Toggle commentaires avec gcc
    {
      "numToStr/Comment.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("Comment").setup({
          padding = true,
          sticky = true,
          ignore = nil,
          toggler = {
            line = "gcc",
            block = "gbc",
          },
          opleader = {
            line = "gc",
            block = "gb",
          },
          extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
          },
          mappings = {
            basic = true,
            extra = true,
          },
          pre_hook = nil,
          post_hook = nil,
        })
      end,
    },

    -- nvim-surround - Manipulation des surroundings (quotes, brackets, tags, etc.)
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
            change_line = "cS",
          },
          aliases = {
            ["a"] = ">",
            ["b"] = ")",
            ["B"] = "}",
            ["r"] = "]",
            ["q"] = { '"', "'", "`" },
            ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
          },
          highlight = {
            duration = 0,
          },
          move_cursor = "begin",
          indent_lines = function(start, stop)
            local b = vim.bo
            if b.filetype == "html" or b.filetype == "xml" or b.filetype == "jsx" or b.filetype == "tsx" then
              return true
            end
            return false
          end,
        })
      end,
    },


    -- TreeSitter - Syntax highlighting et parsing améliorés
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "python",
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "json",
            "yaml",
            "toml",
            "go",
            "rust",
            "java",
            "dockerfile",
            "bash",
            "markdown",
            "markdown_inline",
            "regex",
            "sql",
            "gitignore",
            "gitcommit",
          },
          sync_install = false,
          auto_install = true,
          ignore_install = {},
          highlight = {
            enable = true,
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
            disable = { "python", "yaml" },
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ii"] = "@conditional.inner",
                ["ai"] = "@conditional.outer",
                ["il"] = "@loop.inner",
                ["al"] = "@loop.outer",
                ["at"] = "@comment.outer",
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
                ["]o"] = "@loop.*",
                ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
              },
              goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
              },
              goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[o"] = "@loop.*",
                ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
                ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
              },
              goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ["<leader>a"] = "@parameter.inner",
              },
              swap_previous = {
                ["<leader>A"] = "@parameter.inner",
              },
            },
          },
        })
        
        -- Configuration du folding avec TreeSitter
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false -- Désactiver le folding par défaut
      end,
    },

    -- TreeSitter text objects
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
      dependencies = "nvim-treesitter/nvim-treesitter",
    },

    -- Alpha - Page d'accueil
    {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII Art Header
        dashboard.section.header.val = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "                                                     ",
          "      🚀 Prêt pour coder ? Choisissez votre mission ! ",
          "                                                     ",
        }

        -- Menu buttons
        dashboard.section.buttons.val = {
          dashboard.button("e", "  Nouveau fichier", ":ene <BAR> startinsert <CR>"),
          dashboard.button("o", "  Fichiers récents", ":Telescope oldfiles <CR>"),
          dashboard.button("f", "  Chercher fichier", ":Telescope find_files <CR>"),
          dashboard.button("g", "  Chercher texte", ":Telescope live_grep <CR>"),
          dashboard.button("s", "  Restaurer session", ":SessionRestore <CR>"),
          dashboard.button("c", "  Configuration", ":e " .. vim.fn.stdpath("config") .. "/init.lua <CR>"),
          dashboard.button("l", "  Lazy", ":Lazy <CR>"),
          dashboard.button("m", "  Mason", ":Mason <CR>"),
          dashboard.button("q", "  Quitter", ":qa <CR>"),
        }

        -- Footer avec des stats
        local function footer()
          local total_plugins = require("lazy").stats().count
          local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
          local version = vim.version()
          local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

          return "⚡ " .. total_plugins .. " plugins" .. "   " .. datetime .. "   " .. nvim_version_info
        end

        dashboard.section.footer.val = footer()

        -- Configuration des couleurs
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"
        dashboard.section.footer.opts.hl = "Type"

        -- Désactiver le folding sur alpha buffer
        dashboard.opts.opts.noautocmd = true

        -- Configuration finale
        alpha.setup(dashboard.opts)

        -- Auto-commandes pour alpha
        vim.api.nvim_create_autocmd("User", {
          pattern = "LazyVimStarted",
          callback = function()
            dashboard.section.footer.val = footer()
            pcall(vim.cmd.AlphaRedraw)
          end,
        })

        -- Masquer la barre de statut sur la page alpha
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "alpha",
          callback = function()
            vim.opt_local.laststatus = 0
            vim.opt_local.showtabline = 0
          end,
        })

        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          callback = function()
            vim.opt_local.laststatus = 3
            vim.opt_local.showtabline = 2
          end,
        })
      end,
    },

    -- Auto Session - Gestion automatique des sessions
    {
      "rmagatti/auto-session",
      config = function()
        require("auto-session").setup({
          log_level = "error",
          auto_session_enable_last_session = false,
          auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
          auto_session_enabled = true,
          auto_save_enabled = nil,
          auto_restore_enabled = nil,
          auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "C:\\", "C:\\Users", "C:\\Users\\sekme" },
          auto_session_use_git_branch = false,
          bypass_session_save_file_types = {
            "alpha",
            "dashboard",
            "NvimTree",
            "Outline",
            "TelescopePrompt",
            "Mason",
            "lazy",
            "help",
            "nofile",
            "terminal",
          },
          auto_session_create_enabled = true,
          session_lens = {
            load_on_setup = true,
            theme_conf = { border = true },
            previewer = false,
          },
          pre_save_cmds = {
            function()
              -- Fermer nvim-tree avant de sauvegarder la session
              if vim.bo.filetype == "NvimTree" then
                vim.cmd("NvimTreeClose")
              end
            end,
          },
          post_restore_cmds = {
            function()
              -- Commandes à exécuter après la restauration d'une session
              -- Peut être utile pour rouvrir certains plugins ou fenêtres
            end,
          },
        })

        -- Keymaps pour auto-session
        vim.keymap.set("n", "<leader>qs", ":SessionSave<CR>", { desc = "Save session" })
        vim.keymap.set("n", "<leader>qr", ":SessionRestore<CR>", { desc = "Restore session" })
        vim.keymap.set("n", "<leader>qd", ":SessionDelete<CR>", { desc = "Delete session" })
        vim.keymap.set("n", "<leader>qf", ":Autosession search<CR>", { desc = "Find sessions" })
        vim.keymap.set("n", "<leader>qp", ":SessionPurgeOrphaned<CR>", { desc = "Purge orphaned sessions" })
      end,
    },

    
    -- Thème par défaut
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight]])
      end,
    },
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})