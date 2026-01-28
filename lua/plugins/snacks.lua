return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = true },
    picker = {
      exclude = {
        ".git",
        "node_modules",
        ".next",
      },
      enabled = true,
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
        explorer = {
          hidden = true,
          ignored = true,
          layout = {
            preset = "sidebar",
            preview = false,
            hidden = { "input" },
          },
          formatters = {
            file = {
              git_status_hl = false,
            },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<C-b>", function() Snacks.explorer() end, desc = "File Explorer" },
  },
}
