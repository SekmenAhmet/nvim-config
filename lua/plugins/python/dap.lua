-- DAP - Debugging pour Python avec debugpy
return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    -- Configuration debugpy (installé via Mason)
    local python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(python_path)

    -- Configurations de debugging
    local dap = require("dap")
    table.insert(dap.configurations.python, {
      type = "python",
      request = "launch",
      name = "Launch file with arguments",
      program = "${file}",
      args = function()
        local args_string = vim.fn.input("Arguments: ")
        return vim.split(args_string, " +")
      end,
      console = "integratedTerminal",
    })

    table.insert(dap.configurations.python, {
      type = "python",
      request = "attach",
      name = "Attach remote",
      connect = function()
        local host = vim.fn.input("Host [127.0.0.1]: ")
        host = host ~= "" and host or "127.0.0.1"
        local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
        return { host = host, port = port }
      end,
    })

    -- Keymaps Python spécifiques
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Debugging standard
        vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
        vim.keymap.set("n", "<leader>dc", require("dap").continue, vim.tbl_extend("force", opts, { desc = "Continue debugging" }))
        vim.keymap.set("n", "<leader>do", require("dap").step_over, vim.tbl_extend("force", opts, { desc = "Step over" }))
        vim.keymap.set("n", "<leader>di", require("dap").step_into, vim.tbl_extend("force", opts, { desc = "Step into" }))
        vim.keymap.set("n", "<leader>dO", require("dap").step_out, vim.tbl_extend("force", opts, { desc = "Step out" }))
        vim.keymap.set("n", "<leader>dr", require("dap").repl.open, vim.tbl_extend("force", opts, { desc = "Open REPL" }))
        vim.keymap.set("n", "<leader>dl", require("dap").run_last, vim.tbl_extend("force", opts, { desc = "Run last" }))

        -- Python-specific test debugging
        vim.keymap.set("n", "<leader>dtn", require("dap-python").test_method, vim.tbl_extend("force", opts, { desc = "Debug test method" }))
        vim.keymap.set("n", "<leader>dtc", require("dap-python").test_class, vim.tbl_extend("force", opts, { desc = "Debug test class" }))
      end,
    })
  end,
}
