local M = {}

local function is_word_char(ch)
  return ch ~= "" and ch:match("[%w_]") ~= nil
end

local function char_at(col)
  if col <= 0 then
    return ""
  end
  local line = vim.fn.getline(".")
  if col > #line then
    return ""
  end
  return line:sub(col, col)
end

local function shiftwidth()
  local shift = vim.bo.shiftwidth
  if shift == 0 then
    shift = vim.bo.tabstop
  end
  return shift
end

local function indent_string(count)
  if count <= 0 then
    return ""
  end
  if vim.bo.expandtab then
    return string.rep(" ", count)
  end
  local tabstop = vim.bo.tabstop
  if tabstop == 0 then
    tabstop = 8
  end
  local tabs = math.floor(count / tabstop)
  local spaces = count % tabstop
  return string.rep("\t", tabs) .. string.rep(" ", spaces)
end

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

local function has_word_after()
  local col = vim.fn.col(".")
  return is_word_char(char_at(col))
end

local function confirm_completion()
  local ok, cmp = pcall(require, "cmp")
  if ok and cmp.visible() then
    cmp.confirm({ select = true })
    return true
  end
  return false
end

function M.smart_cr()
  if confirm_completion() then
    return
  end
  local col = vim.fn.col(".")
  local prev = char_at(col - 1)
  local next = char_at(col)
  if prev == "{" and next == "}" then
    local indent = vim.fn.indent(".")
    local inner = indent + shiftwidth()
    feedkeys("<CR>" .. indent_string(inner) .. "<CR>" .. indent_string(indent) .. "<Up><C-o>$")
    return
  end
  feedkeys("<CR>")
end

local insert_pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["\""] = "\"",
  ["'"] = "'",
  ["`"] = "`",
}

local function pair(open, close)
  return function()
    local next_char = char_at(vim.fn.col("."))
    if next_char == close then
      return open
    end
    if has_word_after() then
      return open
    end
    return open .. close .. "<Left>"
  end
end

function M.smart_bs()
  local col = vim.fn.col(".")
  if col <= 1 then
    return "<BS>"
  end
  local prev = char_at(col - 1)
  local next = char_at(col)
  local close = insert_pairs[prev]
  if close and next == close then
    return "<BS><Del>"
  end
  return "<BS>"
end

for open, close in pairs(insert_pairs) do
  vim.keymap.set("i", open, pair(open, close), { expr = true, noremap = true, silent = true })
end

vim.keymap.set("i", "<CR>", M.smart_cr, { noremap = true, silent = true })
vim.keymap.set("i", "<BS>", M.smart_bs, { expr = true, noremap = true, silent = true })

local surround_pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ["\""] = "\"",
  ["'"] = "'",
  ["`"] = "`",
}

local function surround_visual(open, close)
  local bufnr = 0
  local start = vim.fn.getpos("'<")
  local finish = vim.fn.getpos("'>")
  local srow, scol = start[2] - 1, start[3] - 1
  local erow, ecol = finish[2] - 1, finish[3] - 1
  if erow < srow or (erow == srow and ecol < scol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end

  local mode = vim.fn.visualmode()
  local end_col
  if mode == "V" then
    local line = vim.api.nvim_buf_get_lines(bufnr, erow, erow + 1, false)[1] or ""
    scol = 0
    end_col = #line
  else
    end_col = ecol + 1
  end

  vim.api.nvim_buf_set_text(bufnr, erow, end_col, erow, end_col, { close })
  vim.api.nvim_buf_set_text(bufnr, srow, scol, srow, scol, { open })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

local function surround_with_input()
  local ok, ch = pcall(vim.fn.getcharstr)
  if not ok or ch == "" then
    return
  end
  local close = surround_pairs[ch] or ch
  surround_visual(ch, close)
end

vim.keymap.set({ "x", "s" }, "gs", surround_with_input, { desc = "Surround selection", silent = true })

return M
