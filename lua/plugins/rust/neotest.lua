-- Neotest - Tests intégrés avec résultats inline
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "rust",
    config = function()
      local neotest = require("neotest")
      
      neotest.setup({
        adapters = {
            -- rustaceanvim will configure the adapter
        },
        
        -- Configuration interface
        consumers = {},
        
        -- Configuration des icônes
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✓",
          running = "●",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "○",
          unknown = "?"
        },
        
        -- Highlights pour résultats
        highlights = {
          adapter_name = "NeotestAdapterName",
          border = "NeotestBorder",
          dir = "NeotestDir",
          expand_marker = "NeotestExpandMarker",
          failed = "NeotestFailed",
          file = "NeotestFile",
          focused = "NeotestFocused",
          indent = "NeotestIndent",
          marked = "NeotestMarked",
          namespace = "NeotestNamespace",
          passed = "NeotestPassed",
          running = "NeotestRunning",
          select_win = "NeotestWinSelect",
          skipped = "NeotestSkipped",
          target = "NeotestTarget",
          test = "NeotestTest",
          unknown = "NeotestUnknown",
        },
        
        -- Configuration fenêtre flottante
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
          options = {}
        },
        
        -- Stratégies d'exécution
        default_strategy = "integrated",
        
        -- Configuration logs
        log_level = vim.log.levels.WARN,
        
        -- Configuration output
        output = {
          enabled = true,
          open_on_run = "short",
        },
        
        -- Configuration des projets
        projects = {
          ["~/rust-projects/"] = {
            discovery = {
              enabled = true,
              filter_dir = function(name, rel_path, root)
                return name ~= "target"
              end,
            },
          },
        },
        
        -- Configuration quickfix
        quickfix = {
          enabled = true,
          open = false,
        },
        
        -- Configuration status
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        
        -- Configuration stratégies
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        
        -- Configuration summary
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w"
          },
        },
      })
      
      -- Keymaps pour tests
      local opts = { silent = true }
      
      -- === EXÉCUTION TESTS ===
      vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Run current file tests" }))
      vim.keymap.set("n", "<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end, vim.tbl_extend("force", opts, { desc = "Run all tests" }))
      vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end, vim.tbl_extend("force", opts, { desc = "Run last test" }))
      
      -- === DEBUGGING TESTS ===
      vim.keymap.set("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end, vim.tbl_extend("force", opts, { desc = "Debug nearest test" }))
      
      -- === INTERFACE ===
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))
      vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, vim.tbl_extend("force", opts, { desc = "Show test output" }))
      vim.keymap.set("n", "<leader>tO", function() neotest.output_panel.toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle output panel" }))
      
      -- === NAVIGATION ===
      vim.keymap.set("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, vim.tbl_extend("force", opts, { desc = "Previous failed test" }))
      vim.keymap.set("n", "]t", function() neotest.jump.next({ status = "failed" }) end, vim.tbl_extend("force", opts, { desc = "Next failed test" }))
      
      -- === WATCH MODE ===
      vim.keymap.set("n", "<leader>tw", function() neotest.watch.toggle(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Toggle watch mode" }))
      
      -- === STOP ===
      vim.keymap.set("n", "<leader>tS", function() neotest.run.stop() end, vim.tbl_extend("force", opts, { desc = "Stop running tests" }))
    end,
  }
}