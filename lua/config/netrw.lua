-- Explorateur natif netrw (leger, sans plugins)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_preview = 1

local state = { win = nil, buf = nil, target = nil }
local icon_group = "NetrwIcons"

vim.fn.sign_define("NetrwDirSign", { text = ">", texthl = "NetrwSignDir" })
vim.fn.sign_define("NetrwFileSign", { text = ".", texthl = "NetrwSignFile" })
vim.fn.sign_define("NetrwLinkSign", { text = "@", texthl = "NetrwSignLink" })

local function icon_for_line(line)
  local trimmed = line:gsub("%s+$", "")
  if trimmed == "" or trimmed:sub(1, 1) == '"' then
    return nil
  end
  if trimmed:sub(-1) == "/" then
    return "NetrwDirSign"
  end
  if trimmed:sub(-1) == "@" then
    return "NetrwLinkSign"
  end
  return "NetrwFileSign"
end

local function apply_netrw_icons(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.fn.sign_unplace(icon_group, { buffer = bufnr })
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for idx, line in ipairs(lines) do
    local sign = icon_for_line(line)
    if sign then
      vim.fn.sign_place(0, icon_group, sign, bufnr, { lnum = idx, priority = 10 })
    end
  end
end

local function is_netrw_buf(bufnr)
  return vim.bo[bufnr].filetype == "netrw"
end

local function is_normal_win(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  if is_netrw_buf(buf) then
    return false
  end
  if vim.bo[buf].buftype ~= "" then
    return false
  end
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative ~= "" then
    return false
  end
  return true
end

local function find_netrw()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_netrw_buf(buf) then
      return win, buf
    end
  end
end

local function find_normal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_normal_win(win) then
      return win
    end
  end
end

local function sync_netrw_state()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    local buf = vim.api.nvim_win_get_buf(state.win)
    if is_netrw_buf(buf) then
      state.buf = buf
      return
    end
  end
  local win, buf = find_netrw()
  state.win = win
  state.buf = buf
end

local function set_target(win)
  if not is_normal_win(win) then
    return
  end
  state.target = win
end

local function ensure_target()
  if state.target and is_normal_win(state.target) then
    return state.target
  end
  local win = find_normal()
  if win then
    state.target = win
    return win
  end
end

local function update_chgwin()
  sync_netrw_state()
  local target = ensure_target()
  if state.win and target then
    vim.g.netrw_chgwin = vim.api.nvim_win_get_number(target)
  end
end

local function set_netrw_width(win, width)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_width(win, width)
  end
end

local function open_netrw()
  local current = vim.api.nvim_get_current_win()
  if is_normal_win(current) then
    state.target = current
  end
  vim.cmd("Lexplore")
  vim.schedule(function()
    sync_netrw_state()
    if state.win then
      set_netrw_width(state.win, 30)
    end
    update_chgwin()
  end)
end

local function close_netrw()
  sync_netrw_state()
  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    return
  end
  if #vim.api.nvim_tabpage_list_wins(0) == 1 then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("enew")
  else
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

local function toggle_netrw()
  sync_netrw_state()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_netrw()
    return
  end
  open_netrw()
end

local function resize_netrw(delta)
  sync_netrw_state()
  if not state.win then
    return
  end
  local width = vim.api.nvim_win_get_width(state.win)
  local new_width = math.max(20, width + delta)
  vim.api.nvim_win_set_width(state.win, new_width)
end

vim.keymap.set("n", "<leader>e", toggle_netrw, { desc = "Explorer" })
vim.keymap.set("n", "<C-b>", toggle_netrw, { desc = "Explorer" })
vim.keymap.set("n", "<C-A-Right>", function() resize_netrw(5) end, { desc = "Explorer wider" })
vim.keymap.set("n", "<C-A-Left>", function() resize_netrw(-5) end, { desc = "Explorer narrower" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(args)
    sync_netrw_state()

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "yes"
    vim.opt_local.cursorline = true
    vim.opt_local.winfixwidth = true
    vim.opt_local.winhighlight = table.concat({
      "Normal:NetrwNormal",
      "NormalNC:NetrwNormal",
      "LineNr:NetrwLineNr",
      "SignColumn:NetrwSignColumn",
      "CursorLine:NetrwCursorLine",
      "CursorLineNr:NetrwCursorLineNr",
      "EndOfBuffer:NetrwNormal",
    }, ",")

    vim.keymap.set("n", "<C-h>", "<C-w>h", { buffer = args.buf, silent = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = args.buf, silent = true })

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, remap = true, desc = desc })
    end

    map("a", "%", "Create file")
    map("A", "d", "Create directory")
    map("r", "R", "Rename")
    map("d", "D", "Delete")

    apply_netrw_icons(args.buf)

    local group = vim.api.nvim_create_augroup("NetrwIcons" .. args.buf, { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI" }, {
      group = group,
      buffer = args.buf,
      callback = function()
        apply_netrw_icons(args.buf)
      end,
    })

    update_chgwin()
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(args)
    if state.buf == args.buf then
      state.win = nil
      state.buf = nil
    end
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if is_normal_win(vim.api.nvim_get_current_win()) then
      set_target(vim.api.nvim_get_current_win())
      update_chgwin()
    end
  end,
})
