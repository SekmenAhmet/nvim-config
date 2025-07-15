-- nvim-surround - Manipulation des surroundings
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
      aliases = {
        ["a"] = ">",
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        ["q"] = { '"', "'", "`" },
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
      },
      highlight = {
        duration = 0,
      },
      move_cursor = "begin",
      indent_lines = function(start, stop)
        local b = vim.bo
        if b.filetype == "html" or b.filetype == "xml" or b.filetype == "jsx" or b.filetype == "tsx" then
          return true
        end
        return false
      end,
    })
  end,
}