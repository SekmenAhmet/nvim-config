-- CMake Tools - Intégration CMake pour C/C++
return {
  "Civitasv/cmake-tools.nvim",
  ft = { "c", "cpp" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("cmake-tools").setup({
      cmake_command = "cmake",
      cmake_build_directory = "build",
      cmake_build_directory_prefix = "",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = {},
      cmake_console_size = 10,
      cmake_console_position = "belowright",
      cmake_show_console = "always",
      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
        console = "integratedTerminal",
      },
      cmake_dap_open_command = require("dap").repl.open,
    })

    -- Keymaps CMake
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp" },
      callback = function()
        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", "<leader>cg", "<Cmd>CMakeGenerate<CR>", vim.tbl_extend("force", opts, { desc = "CMake generate" }))
        vim.keymap.set("n", "<leader>cb", "<Cmd>CMakeBuild<CR>", vim.tbl_extend("force", opts, { desc = "CMake build" }))
        vim.keymap.set("n", "<leader>cr", "<Cmd>CMakeRun<CR>", vim.tbl_extend("force", opts, { desc = "CMake run" }))
        vim.keymap.set("n", "<leader>cd", "<Cmd>CMakeDebug<CR>", vim.tbl_extend("force", opts, { desc = "CMake debug" }))
        vim.keymap.set("n", "<leader>cs", "<Cmd>CMakeSelectBuildType<CR>", vim.tbl_extend("force", opts, { desc = "Select build type" }))
        vim.keymap.set("n", "<leader>ct", "<Cmd>CMakeSelectBuildTarget<CR>", vim.tbl_extend("force", opts, { desc = "Select build target" }))
        vim.keymap.set("n", "<leader>cc", "<Cmd>CMakeClean<CR>", vim.tbl_extend("force", opts, { desc = "CMake clean" }))
      end,
    })
  end,
}
