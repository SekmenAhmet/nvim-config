-- DAP - Debugging pour C/C++ avec codelldb
return {
  {
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp" },
    config = function()
      local dap = require("dap")

      -- Configuration codelldb pour C/C++ (réutilise le même que Rust)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }

      -- Copier les configurations C pour C++
      dap.configurations.cpp = dap.configurations.c

      -- Keymaps C/C++ spécifiques
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
          vim.keymap.set("n", "<leader>dc", require("dap").continue, vim.tbl_extend("force", opts, { desc = "Continue debugging" }))
          vim.keymap.set("n", "<leader>do", require("dap").step_over, vim.tbl_extend("force", opts, { desc = "Step over" }))
          vim.keymap.set("n", "<leader>di", require("dap").step_into, vim.tbl_extend("force", opts, { desc = "Step into" }))
          vim.keymap.set("n", "<leader>dO", require("dap").step_out, vim.tbl_extend("force", opts, { desc = "Step out" }))
          vim.keymap.set("n", "<leader>dr", require("dap").repl.open, vim.tbl_extend("force", opts, { desc = "Open REPL" }))
          vim.keymap.set("n", "<leader>dl", require("dap").run_last, vim.tbl_extend("force", opts, { desc = "Run last" }))
        end,
      })
    end,
  },
}
