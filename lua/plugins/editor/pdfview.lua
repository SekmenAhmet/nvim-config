-- Intégration d'un viewer PDF externe depuis Neovim
return {
  "nvim-lua/plenary.nvim", -- Dépendance déjà présente via Telescope
  lazy = false,            -- On veut que la commande soit dispo dès le démarrage
  config = function()
    local function detect_viewer()
      local custom = vim.g.pdf_viewer
      if custom and (custom == "open" or vim.fn.executable(custom) == 1) then
        return custom
      end

      local candidates = {}
      if vim.fn.has("macunix") == 1 then
        table.insert(candidates, "open")
      end
      vim.list_extend(candidates, { "zathura", "mupdf", "evince", "okular", "atril", "chromium", "firefox", "xdg-open" })

      for _, cmd in ipairs(candidates) do
        if cmd == "open" or vim.fn.executable(cmd) == 1 then
          return cmd
        end
      end
      return nil
    end

    local function resolve_pdf(arg)
      if arg and arg ~= "" then
        return vim.fn.fnamemodify(arg, ":p")
      end

      local buf = vim.api.nvim_buf_get_name(0)
      if buf ~= "" and buf:lower():match("%.pdf$") then
        return vim.fn.fnamemodify(buf, ":p")
      end

      local candidates = vim.fn.glob("*.pdf", false, true)
      if #candidates > 0 then
        return vim.fn.fnamemodify(candidates[1], ":p")
      end
      return nil
    end

    local function open_pdf(path)
      local viewer = detect_viewer()
      if not viewer then
        vim.notify("Aucun viewer PDF détecté (installe zathura/evince ou définis g:pdf_viewer)", vim.log.levels.ERROR, { title = "PDF Viewer" })
        return
      end

      local cmd = { viewer, path }
      if viewer == "open" then
        cmd = { "open", path }
      end

      local job = vim.fn.jobstart(cmd, { detach = true })
      if job <= 0 then
        vim.notify("Impossible de lancer " .. viewer, vim.log.levels.ERROR, { title = "PDF Viewer" })
      else
        vim.notify("Ouverture de " .. path .. " via " .. viewer, vim.log.levels.INFO, { title = "PDF Viewer" })
      end
    end

    vim.api.nvim_create_user_command("PdfView", function(opts)
      local target = resolve_pdf(opts.args)
      if not target then
        vim.notify("Aucun fichier PDF trouvé (passe un chemin ou ouvre un PDF)", vim.log.levels.WARN, { title = "PDF Viewer" })
        return
      end
      open_pdf(target)
    end, { nargs = "?", complete = "file", desc = "Ouvrir le PDF avec un viewer externe" })
  end,
}
