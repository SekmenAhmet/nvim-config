-- overseer.nvim - Gestion et suivi des tâches (builds, tests, commandes)
return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction", "OverseerLoadBundle", "OverseerSaveBundle" },
  keys = {
    { "<leader>ot", "<Cmd>OverseerToggle<CR>", desc = "Overseer: toggle tasks" },
    { "<leader>or", "<Cmd>OverseerRun<CR>", desc = "Overseer: run task" },
  },
  opts = {
    strategy = "terminal",
    templates = { "builtin", "user" },
  },
}
