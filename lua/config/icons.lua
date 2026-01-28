if _G.MiniIcons ~= nil then
  return
end

local function icon(codepoint)
  return vim.fn.nr2char(codepoint) .. " "
end

-- Extended icon set for complete coverage
local icons_by_ext = {
  -- Programming languages
  asm = icon(0xe637),
  c = icon(0xe61e),
  cpp = icon(0xe61d),
  cc = icon(0xe61d),
  cxx = icon(0xe61d),
  h = icon(0xe61e),
  hpp = icon(0xe61d),
  py = icon(0xe606),
  pyw = icon(0xe606),
  pyc = icon(0xe606),
  pyo = icon(0xe606),
  lua = icon(0xe620),
  js = icon(0xe60c),
  jsx = icon(0xe625),
  ts = icon(0xe628),
  tsx = icon(0xe7ba),
  cjs = icon(0xe60c),
  mjs = icon(0xe60c),
  cts = icon(0xe628),
  mts = icon(0xe628),
  go = icon(0xe627),
  rs = icon(0xe7a8),
  java = icon(0xe738),
  sh = icon(0xf489),
  bash = icon(0xf489),
  zsh = icon(0xf489),
  fish = icon(0xf489),
  vim = icon(0xe62b),
  
  -- Data formats
  json = icon(0xe60b),
  yaml = icon(0xe60b),
  yml = icon(0xe60b),
  toml = icon(0xe60b),
  xml = icon(0xe619),
  html = icon(0xe60e),
  css = icon(0xe614),
  scss = icon(0xe614),
  sass = icon(0xe614),
  
  -- Documentation
  md = icon(0xe609),
  txt = icon(0xf15c),
  pdf = icon(0xf1c1),
  
  -- Build/Config
  makefile = icon(0xe615),
  cmake = icon(0xe615),
  
  -- Other
  s = icon(0xe637),
  S = icon(0xe637),
  nasm = icon(0xe637),
  o = icon(0xf471),
  so = icon(0xf471),
  a = icon(0xf471),
  out = icon(0xf489),
  exe = icon(0xf489),
  
  -- Default
  [" "] = icon(0xf15b),
}

local icons_by_ft = {
  -- Languages
  asm = icons_by_ext.asm,
  nasm = icons_by_ext.asm,
  c = icons_by_ext.c,
  cpp = icons_by_ext.cpp,
  python = icons_by_ext.py,
  lua = icons_by_ext.lua,
  javascript = icons_by_ext.js,
  javascriptreact = icons_by_ext.jsx,
  typescript = icons_by_ext.ts,
  typescriptreact = icons_by_ext.tsx,
  go = icons_by_ext.go,
  rust = icons_by_ext.rs,
  java = icons_by_ext.java,
  sh = icons_by_ext.sh,
  bash = icons_by_ext.bash,
  zsh = icons_by_ext.zsh,
  fish = icons_by_ext.fish,
  vim = icons_by_ext.vim,
  
  -- Data
  json = icons_by_ext.json,
  yaml = icons_by_ext.yaml,
  toml = icons_by_ext.toml,
  xml = icons_by_ext.xml,
  html = icons_by_ext.html,
  css = icons_by_ext.css,
  scss = icons_by_ext.scss,
  
  -- Docs
  markdown = icons_by_ext.md,
  text = icons_by_ext.txt,
  
  -- Build
  make = icons_by_ext.makefile,
  cmake = icons_by_ext.cmake,
}

-- Special file names
local icons_by_filename = {
  ["makefile"] = icons_by_ext.makefile,
  ["Makefile"] = icons_by_ext.makefile,
  ["CMakeLists.txt"] = icons_by_ext.cmake,
  ["README.md"] = icons_by_ext.md,
  ["readme.md"] = icons_by_ext.md,
  [".gitignore"] = icon(0xf1d3),
  [".gitconfig"] = icon(0xf1d3),
  ["LICENSE"] = icon(0xf48a),
  ["Dockerfile"] = icon(0xf308),
}

_G.MiniIcons = {
  get = function(cat, name)
    if not name or name == "" then
      return icons_by_ext[" "], "Special"
    end
    
    if cat == "filetype" then
      local icon_str = icons_by_ft[name]
      if icon_str then
        return icon_str, "Special"
      end
      return icons_by_ext[" "], "Special"
    end
    
    if cat == "extension" then
      local icon_str = icons_by_ext[name]
      if icon_str then
        return icon_str, "Special"
      end
      return icons_by_ext[" "], "Special"
    end
    
    if cat == "file" then
      -- Check special filenames first
      local icon_str = icons_by_filename[name]
      if icon_str then
        return icon_str, "Special"
      end
      
      -- Then check extension
      local ext = name:match("%.([%w_]+)$")
      if ext then
        icon_str = icons_by_ext[ext]
        if icon_str then
          return icon_str, "Special"
        end
      end
      
      return icons_by_ext[" "], "Special"
    end
    
    return icons_by_ext[" "], "Special"
  end,
}

-- Compatibility with nvim-web-devicons API
_G.require_web_devicons_fallback = function()
  return {
    get_icon = function(filename, ext, opts)
      if filename then
        local icon_str = icons_by_filename[filename]
        if icon_str then
          return icon_str:gsub("%s+$", ""), nil
        end
      end
      if ext then
        local icon_str = icons_by_ext[ext]
        if icon_str then
          return icon_str:gsub("%s+$", ""), nil
        end
      end
      return icons_by_ext[" "]:gsub("%s+$", ""), nil
    end,
    get_icon_by_filetype = function(filetype, opts)
      local icon_str = icons_by_ft[filetype]
      if icon_str then
        return icon_str:gsub("%s+$", ""), nil
      end
      return icons_by_ext[" "]:gsub("%s+$", ""), nil
    end,
    setup = function() end,
  }
end
