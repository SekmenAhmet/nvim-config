local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function lsp_cmd(bin)
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. bin
  if vim.fn.executable(mason_bin) == 1 then
    return mason_bin
  end
  return bin
end

local function run_cmd(cmd, cwd)
  if vim.system then
    local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
    if res.code == 0 and res.stdout then
      return vim.split(res.stdout, "\n", { trimempty = true })
    end
    return {}
  end
  local prefix = ""
  if cwd and cwd ~= "" then
    prefix = "cd " .. vim.fn.shellescape(cwd) .. " && "
  end
  local parts = {}
  for _, arg in ipairs(cmd) do
    table.insert(parts, vim.fn.shellescape(arg))
  end
  return vim.fn.systemlist(prefix .. table.concat(parts, " "))
end

local function venv_python(venv)
  if not venv or venv == "" then
    return nil
  end
  local python = venv .. "/bin/python"
  if vim.fn.executable(python) == 1 then
    return python
  end
  return nil
end

local function env_venv(env)
  if env and env ~= "" and vim.fn.isdirectory(env) == 1 then
    return env
  end
  return nil
end

local function local_venv(root, name)
  if not root or root == "" then
    return nil
  end
  local venv = root .. "/" .. name
  if vim.fn.filereadable(venv .. "/pyvenv.cfg") == 1 then
    return venv
  end
  return nil
end

local function poetry_venv(root)
  if vim.fn.executable("poetry") ~= 1 then
    return nil
  end
  if vim.fn.filereadable(root .. "/pyproject.toml") ~= 1 then
    return nil
  end
  local output = run_cmd({ "poetry", "env", "info", "-p" }, root)
  local venv = output[1]
  if venv and venv ~= "" and vim.fn.isdirectory(venv) == 1 then
    return venv
  end
  return nil
end

local function pipenv_venv(root)
  if vim.fn.executable("pipenv") ~= 1 then
    return nil
  end
  if vim.fn.filereadable(root .. "/Pipfile") ~= 1 then
    return nil
  end
  local output = run_cmd({ "pipenv", "--venv" }, root)
  local venv = output[1]
  if venv and venv ~= "" and vim.fn.isdirectory(venv) == 1 then
    return venv
  end
  return nil
end

local function python_env(root_dir)
  local root = root_dir or vim.fn.getcwd()
  local venv = env_venv(vim.env.VIRTUAL_ENV) or env_venv(vim.env.CONDA_PREFIX)
  if not venv then
    venv = local_venv(root, ".venv")
      or local_venv(root, "venv")
      or local_venv(root, "env")
      or poetry_venv(root)
      or pipenv_venv(root)
  end
  if venv then
    local python = venv_python(venv)
    if python then
      return python, venv
    end
  end
  local python = vim.fn.exepath("python3")
  if python == "" then
    python = vim.fn.exepath("python")
  end
  return python, nil
end

local function python_extra_paths(root_dir)
  local paths = {}
  if not root_dir or root_dir == "" then
    return paths
  end
  local function add_path(path)
    if path and path ~= "" and vim.fn.isdirectory(path) == 1 then
      for _, existing in ipairs(paths) do
        if existing == path then
          return
        end
      end
      table.insert(paths, path)
    end
  end
  add_path(root_dir)
  add_path(root_dir .. "/src")
  add_path(root_dir .. "/lib")
  return paths
end

local function get_clients(bufnr)
  if vim.lsp.get_clients then
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
  local clients = vim.lsp.get_active_clients()
  if not bufnr then
    return clients
  end
  local attached = {}
  for _, client in ipairs(clients) do
    if vim.lsp.buf_is_attached(bufnr, client.id) then
      table.insert(attached, client)
    end
  end
  return attached
end

local function buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.fn.getcwd()
  end
  return vim.fn.fnamemodify(name, ":p:h")
end

local function find_root(markers, startpath)
  if not markers or #markers == 0 then
    return startpath
  end
  local found = vim.fs.find(markers, { path = startpath, upward = true })[1]
  if found then
    local normalized = vim.fs.normalize(found)
    local dir = vim.fs.dirname(normalized)
    if dir and dir ~= "" then
      return dir
    end
  end
  return startpath
end

vim.keymap.set("n", "gd", function()
  if #get_clients(0) > 0 then
    vim.lsp.buf.definition()
  else
    vim.cmd("normal! gd")
  end
end, { desc = "Go to definition" })

local servers = {
  clangd = {
    name = "clangd",
    cmd = {
      lsp_cmd("clangd"),
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
      "--pch-storage=memory",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
      ".clangd",
      "compile_commands.json",
      "compile_flags.txt",
      "CMakeLists.txt",
      "Makefile",
      "meson.build",
      ".git",
    },
    single_file_support = true,
    init_options = {
      fallbackFlags = { "-Iinclude", "-Isrc" },
    },
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      offsetEncoding = { "utf-16" },
    }),
  },
  pyright = {
    name = "pyright",
    cmd = { lsp_cmd("pyright-langserver"), "--stdio" },
    filetypes = { "python" },
    root_markers = {
      "pyproject.toml",
      "pyrightconfig.json",
      "poetry.lock",
      "Pipfile",
      "Pipfile.lock",
      "requirements.txt",
      "setup.cfg",
      "setup.py",
      ".git",
    },
    single_file_support = true,
    capabilities = capabilities,
    before_init = function(_, config)
      local root_dir = config.root_dir or vim.fn.getcwd()
      local python, venv = python_env(root_dir)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = python
      config.settings.python.analysis = config.settings.python.analysis or {}
      if venv then
        config.settings.python.analysis.venvPath = vim.fn.fnamemodify(venv, ":h")
        config.settings.python.analysis.venv = vim.fn.fnamemodify(venv, ":t")
      end
      local extra = python_extra_paths(root_dir)
      if #extra > 0 then
        config.settings.python.analysis.extraPaths = config.settings.python.analysis.extraPaths or {}
        for _, path in ipairs(extra) do
          local exists = false
          for _, existing in ipairs(config.settings.python.analysis.extraPaths) do
            if existing == path then
              exists = true
              break
            end
          end
          if not exists then
            table.insert(config.settings.python.analysis.extraPaths, path)
          end
        end
      end
    end,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  },
  ts_ls = {
    name = "ts_ls",
    cmd = { lsp_cmd("typescript-language-server"), "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
    },
    single_file_support = true,
    capabilities = capabilities,
  },
  gopls = {
    name = "gopls",
    cmd = { lsp_cmd("gopls") },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    single_file_support = true,
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
  lua_ls = {
    name = "lua_ls",
    cmd = { lsp_cmd("lua-language-server") },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", "luarc.json", "luarc.jsonc", ".git" },
    single_file_support = true,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  rust_analyzer = {
    name = "rust_analyzer",
    cmd = { lsp_cmd("rust-analyzer") },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    single_file_support = true,
    capabilities = capabilities,
  },
}

local function start_server(server, bufnr)
  local root_dir = find_root(server.root_markers, buf_dir(bufnr))
  local config = vim.tbl_deep_extend("force", {}, server, {
    root_dir = root_dir,
    capabilities = server.capabilities or capabilities,
  })
  config.root_markers = nil
  config.filetypes = nil
  vim.lsp.start(config)
end

local lsp_group = vim.api.nvim_create_augroup("LspAutostart", { clear = true })
for _, server in pairs(servers) do
  vim.api.nvim_create_autocmd("FileType", {
    group = lsp_group,
    pattern = server.filetypes,
    callback = function(args)
      start_server(server, args.buf)
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
  end,
})

local lsp_hint = { win = nil, buf = nil }

local function close_lsp_hint()
  if lsp_hint.win and vim.api.nvim_win_is_valid(lsp_hint.win) then
    vim.api.nvim_win_close(lsp_hint.win, true)
  end
  if lsp_hint.buf and vim.api.nvim_buf_is_valid(lsp_hint.buf) then
    vim.api.nvim_buf_delete(lsp_hint.buf, { force = true })
  end
  lsp_hint.win = nil
  lsp_hint.buf = nil
end

local function should_show_lsp_hint()
  if vim.fn.pumvisible() == 1 then
    return false
  end
  return #get_clients(0) > 0
end

local function show_lsp_hint()
  if not should_show_lsp_hint() then
    return
  end
  if lsp_hint.win and vim.api.nvim_win_is_valid(lsp_hint.win) then
    return
  end

  local lines = {
    "LSP: gd def  gD decl  gr refs  gi impl  gy type",
    "     K hover  <leader>rn rename  <leader>ca action",
    "     <leader>ld diag  [d/]d prev/next  <leader>q loclist",
  }

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

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
    focusable = false,
    noautocmd = true,
  })
  vim.wo[win].wrap = false
  vim.wo[win].winblend = 10

  lsp_hint.win = win
  lsp_hint.buf = buf
end

local function toggle_lsp_hint()
  if lsp_hint.win and vim.api.nvim_win_is_valid(lsp_hint.win) then
    close_lsp_hint()
    return
  end
  show_lsp_hint()
end

vim.keymap.set("n", "<leader>lh", toggle_lsp_hint, { desc = "LSP key hint" })
vim.api.nvim_create_user_command("LspKeyHint", toggle_lsp_hint, {})

local hint_group = vim.api.nvim_create_augroup("LspKeyHint", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = hint_group,
  callback = close_lsp_hint,
})
