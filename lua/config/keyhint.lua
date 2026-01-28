local hint = { win = nil, buf = nil }

local function close_hint()
  if hint.win and vim.api.nvim_win_is_valid(hint.win) then
    vim.api.nvim_win_close(hint.win, true)
  end
  if hint.buf and vim.api.nvim_buf_is_valid(hint.buf) then
    vim.api.nvim_buf_delete(hint.buf, { force = true })
  end
  hint.win = nil
  hint.buf = nil
end

local function normalize_lhs(lhs)
  if lhs:sub(1, 8) == "<leader>" then
    return lhs
  end
  if lhs:sub(1, 8) == "<Leader>" then
    return "<leader>" .. lhs:sub(9)
  end
  local leader = vim.g.mapleader or "\\"
  if leader == " " and lhs:sub(1, 7) == "<Space>" then
    return "<leader>" .. lhs:sub(8)
  end
  if leader ~= "" and lhs:sub(1, #leader) == leader then
    return "<leader>" .. lhs:sub(#leader + 1)
  end
  return lhs
end

local function collect_leader_maps()
  local maps = {}
  local function add(list)
    for _, map in ipairs(list) do
      local lhs = normalize_lhs(map.lhs)
      if lhs:sub(1, 8) == "<leader>" then
        maps[lhs] = map.desc or map.rhs or ""
      end
    end
  end
  add(vim.api.nvim_get_keymap("n"))
  add(vim.api.nvim_buf_get_keymap(0, "n"))

  -- Group by category
  local categories = {
    ["Files"] = {},
    ["LSP"] = {},
    ["Diagnostics"] = {},
    ["Edit"] = {},
    ["Other"] = {},
  }
  
  for lhs, desc in pairs(maps) do
    if desc == "" then
      desc = "-"
    end
    local line = string.format("%-14s %s", lhs, desc)
    
    -- Categorize
    if lhs:match("^<leader>f") then
      table.insert(categories["Files"], line)
    elseif lhs:match("^<leader>e") or lhs:match("^<leader>b") then
      table.insert(categories["Files"], line)
    elseif lhs:match("^<leader>[rc]") or lhs:match("^<leader>l") then
      table.insert(categories["LSP"], line)
    elseif lhs:match("^<leader>[dq]") then
      table.insert(categories["Diagnostics"], line)
    elseif desc:lower():match("delete") or desc:lower():match("duplicate") then
      table.insert(categories["Edit"], line)
    else
      table.insert(categories["Other"], line)
    end
  end
  
  -- Build output with headers
  local lines = {}
  for _, cat in ipairs({"Files", "LSP", "Diagnostics", "Edit", "Other"}) do
    if #categories[cat] > 0 then
      table.insert(lines, "")
      table.insert(lines, "── " .. cat .. " ──")
      table.sort(categories[cat])
      for _, line in ipairs(categories[cat]) do
        table.insert(lines, line)
      end
    end
  end
  
  if #lines == 0 then
    lines = { "No leader mappings" }
  else
    -- Remove first empty line
    if lines[1] == "" then
      table.remove(lines, 1)
    end
  end
  
  return lines
end

local function show_hint()
  if hint.win and vim.api.nvim_win_is_valid(hint.win) then
    return
  end

  local lines = collect_leader_maps()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = 0
  for _, line in ipairs(lines) do
    if #line > width then
      width = #line
    end
  end
  local max_width = math.min(width + 2, vim.o.columns - 4)
  max_width = math.max(1, max_width)
  local height = math.min(#lines, vim.o.lines - 4)
  height = math.max(1, height)
  local col = math.max(0, math.floor((vim.o.columns - max_width) / 2))
  local row = math.max(1, math.floor((vim.o.lines - height) / 2))

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    row = row,
    col = col,
    width = max_width,
    height = height,
    style = "minimal",
    border = "rounded",
    focusable = false,
    noautocmd = true,
  })
  vim.wo[win].wrap = false
  vim.wo[win].winblend = 10

  hint.win = win
  hint.buf = buf
end

local function toggle_hint()
  if hint.win and vim.api.nvim_win_is_valid(hint.win) then
    close_hint()
    return
  end
  show_hint()
end

vim.keymap.set("n", "<leader>?", toggle_hint, { desc = "Key hints" })
vim.api.nvim_create_user_command("KeyHint", toggle_hint, {})

local hint_group = vim.api.nvim_create_augroup("KeyHint", { clear = true })
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "InsertEnter" }, {
  group = hint_group,
  callback = close_hint,
})
