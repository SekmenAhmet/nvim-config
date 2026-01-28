-- Statusline minimaliste native
local M = {}

local function mode_name()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    R = "REPLACE",
    r = "PROMPT",
    ["!"] = "SHELL",
    t = "TERM",
  }
  local mode = vim.fn.mode()
  return modes[mode] or mode
end

local function mode_hl()
  local mode = vim.fn.mode()
  if mode == "n" then
    return "%#StatusLineMode#"
  elseif mode == "i" then
    return "%#StatusLineModeInsert#"
  elseif mode:match("^[vV\22]") then
    return "%#StatusLineModeVisual#"
  elseif mode == "c" then
    return "%#StatusLineModeCommand#"
  elseif mode == "R" then
    return "%#StatusLineModeReplace#"
  else
    return "%#StatusLine#"
  end
end

local function file_info()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    fname = "[No Name]"
  end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " [RO]" or ""
  return fname .. modified .. readonly
end

local function lsp_status()
  local clients = {}
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = 0 })
  else
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if vim.lsp.buf_is_attached(0, client.id) then
        table.insert(clients, client)
      end
    end
  end
  
  if #clients == 0 then
    return ""
  end
  
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return " LSP[" .. table.concat(names, ",") .. "]"
end

local function diagnostics_info()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  
  local parts = {}
  if errors > 0 then
    table.insert(parts, "%#DiagnosticError#✗" .. errors .. "%#StatusLine#")
  end
  if warnings > 0 then
    table.insert(parts, "%#DiagnosticWarn#⚠" .. warnings .. "%#StatusLine#")
  end
  if info > 0 then
    table.insert(parts, "%#DiagnosticInfo#ℹ" .. info .. "%#StatusLine#")
  end
  if hints > 0 then
    table.insert(parts, "%#DiagnosticHint#💡" .. hints .. "%#StatusLine#")
  end
  
  if #parts == 0 then
    return ""
  end
  return " " .. table.concat(parts, " ")
end

local function position_info()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)
  return string.format(" %d:%d  %d%%%% ", line, col, percent)
end

function M.statusline()
  return table.concat({
    mode_hl(),
    " " .. mode_name() .. " ",
    "%#StatusLine#",
    " ",
    file_info(),
    lsp_status(),
    diagnostics_info(),
    "%=",
    "%#StatusLine#",
    vim.bo.filetype ~= "" and " " .. vim.bo.filetype .. " " or "",
    position_info(),
  })
end

function M.setup()
  vim.opt.statusline = "%!v:lua.require('config.statusline').statusline()"
  
  -- Mode highlights
  vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#1a1b26", bg = "#7c9acc", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = "#1a1b26", bg = "#d0e7da", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = "#1a1b26", bg = "#e8bed3", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineModeCommand", { fg = "#1a1b26", bg = "#e0af68", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineModeReplace", { fg = "#1a1b26", bg = "#f7768e", bold = true })
end

return M
