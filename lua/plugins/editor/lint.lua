-- Nvim-lint - Linting unifié et asynchrone
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configuration des linters par type de fichier
    lint.linters_by_ft = {
      c = { "clangtidy" },
      cpp = { "clangtidy" },
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      yaml = { "yamllint" },
      dockerfile = { "hadolint" },
    }

    -- Configuration personnalisée pour clang-tidy
    -- S'assure que clang-tidy utilise compile_commands.json
    lint.linters.clangtidy = {
      cmd = "clang-tidy",
      stdin = false,
      args = {
        "--quiet",
        "--checks=*",
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat(
        "%f:%l:%c: %trror: %m," .. "%f:%l:%c: %tarning: %m," .. "%f:%l:%c: %tote: %m"
      ),
    }

    -- Autocmd pour lancer le linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Ne pas linter si le fichier est trop grand
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
        if ok and stats and stats.size > max_filesize then
          return
        end

        lint.try_lint()
      end,
    })

    -- Keymap pour lancer le linting manuellement
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
