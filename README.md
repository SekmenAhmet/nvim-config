# ⚡️ Neovim Pro – config modulaire et ultra-rapide

Configuration Neovim hautes performances, pensée pour le dev quotidien : architecture claire, navigation moderne, LSP/DAP/Tests intégrés et UX soignée pour Rust, Python, C/C++, Java, JS/TS, Go, etc.

## 🚀 Points forts
- Démarrage < 50ms : Lazy.nvim, runtime allégé, optimisations préchargées.
- UX moderne : Alpha custom, Neo-tree, Bufferline, Lualine, Noice/Notify, Which-key documenté.
- Navigation & recherche : Flash.nvim, Telescope (+rg/fd), Trouble pour les diagnostics.
- LSP/Completion : Mason + lspconfig, nvim-cmp optimisé (latence quasi nulle), diagnostics épurés.
- Debug & tests : DAP centralisé (UI + virtual text), Neotest pour Rust/Python, JDTLS (DAP/tests) pour Java, codelldb pour C/C++.
- Langages clé en main : Rust (rustaceanvim), Python (debugpy), Java (jdtls + Lombok + workspace isolé), C/C++ (clangd + cmake-tools), JS/TS, Go, YAML, Docker, etc.
- Qualité de vie : Sessions auto, ToggleTerm multi-terminaux, Spectre (search/replace global), Todo-comments, Color preview, PDF viewer.

## ⚡️ Installation rapide
1) Prérequis : Neovim ≥ 0.9, git, ripgrep, fd, make, une police Nerd Font.
2) Clone : `git clone https://github.com/<ton-repo>/nvim ~/.config/nvim`
3) Lance Neovim : Lazy bootstrap automatiquement.
4) Outils LSP/DAP : `:Mason` puis installe `jdtls`, `java-debug-adapter`, `java-test`, `codelldb`, `debugpy`, `lua-language-server`, etc. (ensure_installed déjà rempli).

## 📁 Arborescence
```
init.lua
lua/
  config/     -- options, perf, diagnostics, keymaps, lazy
  plugins/    -- lsp, ui, editor, dap, rust, python, c, java, session, terminal, theme
snippets/     -- snippets custom (Rust, Python, C)
```

## 🧭 Raccourcis essentiels
- Leader : `<Space>` • LocalLeader : `\\`
- Thème : `<leader>ut` (tokyonight ↔ catppuccin)
- Fichiers : `<leader>ff` (find), `<leader>fg` (live grep)
- Explorer : `<C-b>` ou `<leader>en` (Neo-tree)
- Buffers : `<Tab>` / `<S-Tab>` ; fermer via `<leader>bd`
- Terminal : `<C-t>` (principal) / `<leader>tf` (flottant)
- Diagnostics : `<leader>xx` (Trouble), `[d` / `]d`
- Format : `<leader>lf` (Conform)
- Tests : `<leader>tF` (fichier), `[T` / `]T` (échecs)
- Debug : `<leader>dt` (UI), `<leader>db` (breakpoint)
- Sessions : `<leader>qs` / `<leader>qr`

## 🌐 Langages & outils
- Rust : rustaceanvim, crates, neotest-rust, codelldb.
- Java : nvim-jdtls (workspace dédié, Lombok, DAP, tests JUnit).
- Python : debugpy, neotest-python, lint/format via Mason.
- C/C++ : clangd (utf-16), cmake-tools, codelldb.
- JS/TS/HTML/CSS : tsserver, prettierd/prettier, eslint_d.
- Go : gopls (si Go installé).
- DevOps : shfmt, shellcheck, yamllint, dockerls, hadolint.

## 🧪 Debug & tests
- DAP UI : `<leader>dt` (toggle), `<leader>db` (breakpoint), `<F5>/<F10>/<F11>/<F12>`.
- Neotest : `<leader>tn` (nearest), `<leader>tF` (fichier), `<leader>ts` (summary), `[T`/`]T` (échecs).
- Java : DAP + tests via jdtls si `java-debug-adapter` et `java-test` sont installés (Mason).

## 🎛️ Maintenance
- Plugins : `:Lazy sync`
- Outils : `:Mason`
- Treesitter : `:TSUpdate`
- Perf : `:StartupTime`
- Sessions : auto-save/restore (auto-session), purge orphelins `<leader>qp`

Prêt pour le dev intensif : rapide, lisible, et outillé pour coder, tester et déboguer sans friction.
