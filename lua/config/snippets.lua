-- Native snippet system using vim.snippet
local M = {}

M.snippets = {}

-- Load snippets from JSON file
local function load_json_snippets(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return nil
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Use native JSON decoder
  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then
    return nil
  end
  
  local snippets = {}
  
  for name, snippet_def in pairs(data) do
    if type(snippet_def) == "table" and snippet_def.prefix and snippet_def.body then
      local body_text
      
      if type(snippet_def.body) == "table" then
        -- Body is an array of lines
        body_text = table.concat(snippet_def.body, "\n")
      else
        -- Body is a string
        body_text = tostring(snippet_def.body)
      end
      
      snippets[snippet_def.prefix] = {
        body = body_text,
        description = snippet_def.description or "",
      }
    end
  end
  
  return snippets
end

-- Load all snippet files for current filetype
function M.load_snippets_for_ft(ft)
  if M.snippets[ft] then
    return M.snippets[ft]
  end
  
  local snippet_dir = vim.fn.stdpath("config") .. "/snippets"
  local filepath = snippet_dir .. "/" .. ft .. ".json"
  
  local snippets = load_json_snippets(filepath)
  if snippets then
    M.snippets[ft] = snippets
    return snippets
  end
  
  M.snippets[ft] = {}
  return {}
end

-- Get snippet completion items for nvim-cmp
function M.get_completion_items()
  local ft = vim.bo.filetype
  if ft == "" then
    return {}
  end
  
  local snippets = M.load_snippets_for_ft(ft)
  local items = {}
  
  for prefix, snippet in pairs(snippets) do
    table.insert(items, {
      label = prefix,
      kind = vim.lsp.protocol.CompletionItemKind.Snippet,
      insertText = snippet.body,
      documentation = snippet.description,
      data = { is_snippet = true },
    })
  end
  
  return items
end

-- Expand snippet at cursor
function M.expand_or_jump()
  -- Check if we're in a snippet and can jump
  if vim.snippet and vim.snippet.active() then
    vim.snippet.jump(1)
    return true
  end
  
  -- Try to expand snippet
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)
  
  -- Get word before cursor
  local word = before_cursor:match("(%S+)$")
  if not word then
    return false
  end
  
  local ft = vim.bo.filetype
  local snippets = M.load_snippets_for_ft(ft)
  local snippet = snippets[word]
  
  if snippet then
    -- Delete the trigger word
    local start_col = col - #word
    vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, start_col, vim.fn.line(".") - 1, col, {})
    
    -- Expand snippet
    if vim.snippet and vim.snippet.expand then
      vim.snippet.expand(snippet.body)
    else
      -- Fallback: insert as text
      local cursor_line = vim.fn.line(".") - 1
      local lines = vim.split(snippet.body, "\n")
      vim.api.nvim_buf_set_text(0, cursor_line, start_col, cursor_line, start_col, lines)
    end
    
    return true
  end
  
  return false
end

-- Jump backwards in snippet
function M.jump_prev()
  if vim.snippet and vim.snippet.active() then
    vim.snippet.jump(-1)
    return true
  end
  return false
end

-- CMP source
local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.bo.filetype ~= ""
end

function source:get_debug_name()
  return "native_snippets"
end

function source:complete(params, callback)
  local items = M.get_completion_items()
  callback({ items = items, isIncomplete = false })
end

-- Register as cmp source
function M.register_cmp_source()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    cmp.register_source("native_snippets", source.new())
  end
end

-- Setup function
function M.setup()
  -- Register with cmp if available
  vim.defer_fn(function()
    M.register_cmp_source()
  end, 100)
  
  -- Setup keymaps for manual expansion (optional)
  vim.keymap.set("i", "<C-k>", function()
    if not M.expand_or_jump() then
      return "<C-k>"
    end
  end, { expr = true, desc = "Expand or jump snippet" })
  
  vim.keymap.set("i", "<C-j>", function()
    if not M.jump_prev() then
      return "<C-j>"
    end
  end, { expr = true, desc = "Jump snippet backwards" })
end

return M
