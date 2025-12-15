-- Neotest - Tests Python avec pytest
return {
  "nvim-neotest/neotest",
  ft = "python",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG", "-vv" },
          runner = "pytest",
          python = function()
            -- Détection automatique du virtualenv
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return vim.fn.exepath("python3") or "python"
            end
          end,
        }),
      },

      -- Réutiliser la config de votre neotest Rust
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
        unknown = "?",
      },

      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },

      default_strategy = "integrated",
      log_level = vim.log.levels.WARN,

      output = {
        enabled = true,
        open_on_run = "short",
      },

      quickfix = {
        enabled = true,
        open = false,
      },

      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },

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
          watch = "w",
        },
      },
    })

    -- Keymaps pour tests Python (identiques à Rust)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local opts = { buffer = true, silent = true }

        -- EXÉCUTION TESTS
        vim.keymap.set("n", "<leader>tn", function()
          neotest.run.run()
        end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        vim.keymap.set("n", "<leader>tF", function()
          neotest.run.run(vim.fn.expand("%"))
        end, vim.tbl_extend("force", opts, { desc = "Run current file tests" }))
        vim.keymap.set("n", "<leader>ta", function()
          neotest.run.run(vim.fn.getcwd())
        end, vim.tbl_extend("force", opts, { desc = "Run all tests" }))
        vim.keymap.set("n", "<leader>tl", function()
          neotest.run.run_last()
        end, vim.tbl_extend("force", opts, { desc = "Run last test" }))

        -- DEBUGGING TESTS
        vim.keymap.set("n", "<leader>td", function()
          neotest.run.run({ strategy = "dap" })
        end, vim.tbl_extend("force", opts, { desc = "Debug nearest test" }))

        -- INTERFACE
        vim.keymap.set("n", "<leader>ts", function()
          neotest.summary.toggle()
        end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))
        vim.keymap.set("n", "<leader>to", function()
          neotest.output.open({ enter = true, auto_close = true })
        end, vim.tbl_extend("force", opts, { desc = "Show test output" }))
        vim.keymap.set("n", "<leader>tO", function()
          neotest.output_panel.toggle()
        end, vim.tbl_extend("force", opts, { desc = "Toggle output panel" }))

        -- NAVIGATION
        vim.keymap.set("n", "[T", function()
          neotest.jump.prev({ status = "failed" })
        end, vim.tbl_extend("force", opts, { desc = "Previous failed test" }))
        vim.keymap.set("n", "]T", function()
          neotest.jump.next({ status = "failed" })
        end, vim.tbl_extend("force", opts, { desc = "Next failed test" }))

        -- WATCH MODE
        vim.keymap.set("n", "<leader>tw", function()
          neotest.watch.toggle(vim.fn.expand("%"))
        end, vim.tbl_extend("force", opts, { desc = "Toggle watch mode" }))

        -- STOP
        vim.keymap.set("n", "<leader>tS", function()
          neotest.run.stop()
        end, vim.tbl_extend("force", opts, { desc = "Stop running tests" }))
      end,
    })
  end,
}
