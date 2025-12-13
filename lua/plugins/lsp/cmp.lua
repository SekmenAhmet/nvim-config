-- Autocomplétion nvim-cmp - Configuration optimisée
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help", -- Signatures de fonctions
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp", -- Installe jsregexp pour les transformations LSP
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim", -- Icônes VSCode-like pour l'autocomplétion
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Charger les snippets VSCode
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Charger les snippets personnalisés
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

    -- Configuration LuaSnip
    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxOrange" } },
          },
        },
      },
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),

        -- Enter confirme la sélection actuelle (préselection activée)
        ["<CR>"] = cmp.mapping.confirm({
          select = true, -- Auto-sélectionne le premier item pour rapidité
          behavior = cmp.ConfirmBehavior.Insert,
        }),

        -- Flèches pour naviguer
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

        -- Scroll documentation
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Tab = confirme ET passe au prochain placeholder (ultra rapide)
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true }) -- Confirme directement avec Tab
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Shift+Tab pour revenir en arrière dans les snippets
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      -- Sources avec priorités et configurations OPTIMISÉES
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          priority = 1000,
          keyword_length = 0, -- IMMÉDIAT - Dès que tu tapes (0 caractère)
          max_item_count = 20, -- Réduit de 50 → 20 pour vitesse
          entry_filter = function(entry, ctx)
            -- Filtre les suggestions trop longues pour rapidité
            return string.len(entry:get_word()) < 50
          end,
        },
        {
          name = "nvim_lsp_signature_help",
          priority = 900,
        },
        {
          name = "luasnip",
          priority = 800,
          keyword_length = 1, -- Réduit de 2 → 1
          max_item_count = 5,  -- Réduit de 10 → 5 pour vitesse
        },
        {
          name = "path",
          priority = 300,
          keyword_length = 1, -- Réduit de 2 → 1
          max_item_count = 5,
        },
        {
          name = "buffer",
          priority = 200,
          keyword_length = 2, -- Réduit de 3 → 2
          max_item_count = 5, -- Réduit de 10 → 5 pour vitesse
          option = {
            get_bufnrs = function()
              -- Seulement le buffer courant pour plus de vitesse
              return { vim.api.nvim_get_current_buf() }
            end
          },
        },
      }),

      -- Formatting avec lspkind pour de belles icônes
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- Affiche l'icône + le texte
          maxwidth = 50,
          ellipsis_char = "...",
          before = function(entry, vim_item)
            -- Affiche la source entre crochets
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lsp_signature_help = "[Sig]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        })
      },

      -- Comportement de l'autocomplétion
      completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 0, -- IMMÉDIAT - commence à 0 caractère
      },

      -- Préselection du premier item pour rapidité maximale
      preselect = cmp.PreselectMode.Item,

      -- Performance MAXIMALE - Optimisé pour rapidité
      performance = {
        debounce = 0,        -- IMMÉDIAT (était 60ms)
        throttle = 0,        -- IMMÉDIAT (était 30ms)
        fetching_timeout = 200, -- Réduit de 500ms → 200ms
        confirm_resolve_timeout = 50, -- Réduit de 80ms → 50ms
        async_budget = 1,
        max_view_entries = 20, -- Réduit de 50 → 20 pour vitesse
      },

      -- Expérimental : suggestions "ghost text" (désactivé pour vitesse)
      experimental = {
        ghost_text = false, -- Désactivé pour performance maximale
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
}