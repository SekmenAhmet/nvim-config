-- nvim-dap centralisé : UI + virtual text + adaptateurs partagés
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>dt", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "DAP: eval" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- DAP UI (issu de la config Rust d'origine)
      dapui.setup({
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
          },
        },
        floating = {
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        render = { indent = 1, max_value_lines = 100 },
      })

      -- Signes visuels
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "👉", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- Auto-ouvrir / fermer l'UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Virtual text inline
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
      })

      -- Adaptateur codelldb mutualisé (Rust, C/C++)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Config C/C++ (réutilisable pour Rust si besoin)
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
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}
