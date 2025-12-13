-- Crates.nvim - Gestion intelligente des dépendances Cargo
return {
  "saecki/crates.nvim",
  event = "BufRead Cargo.toml",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local crates = require("crates")
    
    crates.setup({
      -- Interface utilisateur
      text = {
        loading = "  Loading...",
        version = "  %s",
        prerelease = "  %s",
        yanked = "  %s yanked",
        nomatch = "  Not found",
        upgrade = "  %s",
        error = "  Error fetching crate",
      },
      
      -- Highlights personnalisés
      highlight = {
        loading = "CratesNvimLoading",
        version = "CratesNvimVersion", 
        prerelease = "CratesNvimPreRelease",
        yanked = "CratesNvimYanked",
        nomatch = "CratesNvimNoMatch",
        upgrade = "CratesNvimUpgrade",
        error = "CratesNvimError",
      },
      
      -- Popup d'informations détaillé
      popup = {
        autofocus = false,
        hide_on_select = false,
        copy_register = '"',
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
        text = {
          title = " %s ",
          pill_left = "",
          pill_right = "",
          description = "%s",
          created_label = " created        ",
          created = "%s",
          updated_label = " updated        ",
          updated = "%s",
          downloads_label = " downloads      ",
          downloads = "%s",
          homepage_label = " homepage       ",
          homepage = "%s",
          repository_label = " repository     ",
          repository = "%s",
          documentation_label = " documentation  ",
          documentation = "%s",
          crates_io_label = " crates.io      ",
          crates_io = "%s",
          categories_label = " categories     ",
          keywords_label = " keywords       ",
          version = "  %s",
          prerelease = " %s",
          yanked = " %s",
          version_date = "  %s",
          feature = "  %s",
          enabled = " %s",
          transitive = " %s",
          normal_dependencies_title = " Dependencies ",
          build_dependencies_title = " Build dependencies ",
          dev_dependencies_title = " Dev dependencies ",
          dependency = "  %s",
          optional = " %s",
          dependency_version = "  %s",
          loading = "  ",
        },
      },

      -- Complétion automatique
      completion = {
        insert_closing_quote = true,
        text = {
          prerelease = "  pre-release ",
          yanked = "  yanked ",
        },
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
      },
      
      -- Linting automatique
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          -- Keymaps spécifiques Cargo.toml
          local opts = { buffer = bufnr, silent = true }
          
          -- === VERSIONS ET UPDATES ===
          vim.keymap.set("n", "<leader>cv", function() require('crates').show_versions_popup() end, vim.tbl_extend("force", opts, { desc = "Show crate versions" }))
          vim.keymap.set("n", "<leader>cf", function() require('crates').show_features_popup() end, vim.tbl_extend("force", opts, { desc = "Show crate features" }))
          vim.keymap.set("n", "<leader>cd", function() require('crates').show_dependencies_popup() end, vim.tbl_extend("force", opts, { desc = "Show dependencies" }))
          
          -- === UPDATES ===
          vim.keymap.set("n", "<leader>cu", function() require('crates').update_crate() end, vim.tbl_extend("force", opts, { desc = "Update crate" }))
          vim.keymap.set("v", "<leader>cu", function() require('crates').update_crates() end, vim.tbl_extend("force", opts, { desc = "Update selected crates" }))
          vim.keymap.set("n", "<leader>ca", function() require('crates').update_all_crates() end, vim.tbl_extend("force", opts, { desc = "Update all crates" }))
          vim.keymap.set("n", "<leader>cU", function() require('crates').upgrade_crate() end, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
          vim.keymap.set("v", "<leader>cU", function() require('crates').upgrade_crates() end, vim.tbl_extend("force", opts, { desc = "Upgrade selected crates" }))
          vim.keymap.set("n", "<leader>cA", function() require('crates').upgrade_all_crates() end, vim.tbl_extend("force", opts, { desc = "Upgrade all crates" }))
          
          -- === NAVIGATION ===
          vim.keymap.set("n", "<leader>ch", function() require('crates').open_homepage() end, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
          vim.keymap.set("n", "<leader>cr", function() require('crates').open_repository() end, vim.tbl_extend("force", opts, { desc = "Open repository" }))
          vim.keymap.set("n", "<leader>cD", function() require('crates').open_documentation() end, vim.tbl_extend("force", opts, { desc = "Open documentation" }))
          vim.keymap.set("n", "<leader>cC", function() require('crates').open_crates_io() end, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
          
          -- === RELOAD ===
          vim.keymap.set("n", "<leader>cR", function() require('crates').reload() end, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
          
          -- === TOGGLE FEATURES ===
          vim.keymap.set("n", "<leader>ct", function() require('crates').toggle_feature() end, vim.tbl_extend("force", opts, { desc = "Toggle feature" }))
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    })
    
    -- Couleurs personnalisées
    vim.api.nvim_set_hl(0, "CratesNvimLoading", { fg = "#a6adc8", italic = true })
    vim.api.nvim_set_hl(0, "CratesNvimVersion", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "CratesNvimPreRelease", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "CratesNvimYanked", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "CratesNvimNoMatch", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "CratesNvimUpgrade", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "CratesNvimError", { fg = "#f38ba8" })
  end,
}