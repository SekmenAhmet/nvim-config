-- Telescope - Fuzzy finder
return {
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
}