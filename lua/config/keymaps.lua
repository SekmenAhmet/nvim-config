-- =====================================================
-- Keymaps Centralisés - Configuration Neovim
-- =====================================================
-- Tous les raccourcis clavier de l'application centralisés ici
-- Organisation : Navigation → LSP → Recherche → UI → Utils

local keymap = vim.keymap.set

-- ==================== THEMES ====================
local themes = { "tokyonight", "catppuccin" }
local current_theme = 1

keymap("n", "<leader>ut", function()
  current_theme = current_theme % #themes + 1
  vim.cmd("colorscheme " .. themes[current_theme])
end, { desc = "Toggle theme" })

-- ==================== NAVIGATION ====================

-- Navigation entre fenêtres
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Navigation entre buffers (BufferLine)
keymap("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Raccourcis directs pour buffers 1-9
for i = 1, 9 do
  keymap("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end

-- ==================== RECHERCHE & FICHIERS ====================

-- Telescope - Recherche de fichiers
keymap("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find files" }) -- Résout conflit avec nvim-tree
keymap("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find buffers" })

-- Telescope - Recherche dans le contenu
keymap("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fs", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in current buffer" })
keymap("n", "<leader>fc", "<Cmd>Telescope grep_string<CR>", { desc = "Grep string under cursor" })

-- Telescope - Aide et configuration
keymap("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- ==================== EXPLORATEUR DE FICHIERS ====================

-- Neo-tree - Explorateur moderne
keymap("n", "<C-b>", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<leader>en", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<leader>el", "<Cmd>Neotree focus<CR>", { desc = "Focus Neo-tree" })
keymap("n", "<leader>eg", "<Cmd>Neotree git_status<CR>", { desc = "Neo-tree git status" })
keymap("n", "<leader>eb", "<Cmd>Neotree buffers<CR>", { desc = "Neo-tree buffers" })

-- ==================== GESTION DES BUFFERS ====================

-- Gestion des buffers via BufferLine
keymap("n", "<leader>bd", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
keymap("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
keymap("n", "<leader>bse", "<Cmd>BufferLineSortByExtension<CR>", { desc = "Sort buffers by extension" })
keymap("n", "<leader>bsd", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort buffers by directory" })

-- ==================== TERMINAL ====================

-- ToggleTerm - Terminal intégré
keymap("n", "<C-t>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap("t", "<C-t>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap("n", "<leader>tf", function() _FLOAT_TERM:toggle() end, { desc = "Toggle floating terminal" })
keymap("n", "<leader>th", function() _HORIZONTAL_TERM:toggle() end, { desc = "Toggle horizontal terminal" })
keymap("n", "<leader>tv", function() _VERTICAL_TERM:toggle() end, { desc = "Toggle vertical terminal" })

-- Navigation dans le terminal
keymap("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
keymap("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Go to left window" })
keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Go to bottom window" })
keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Go to top window" })
keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Go to right window" })

-- ==================== GIT ====================

-- Git via Telescope
keymap("n", "<leader>gc", "<Cmd>Telescope git_commits<CR>", { desc = "Git commits" })
keymap("n", "<leader>gb", "<Cmd>Telescope git_branches<CR>", { desc = "Git branches" })
keymap("n", "<leader>gs", "<Cmd>Telescope git_status<CR>", { desc = "Git status" })

-- ==================== SESSIONS ====================

-- Auto-session management
keymap("n", "<leader>qs", "<Cmd>SessionSave<CR>", { desc = "Save session" })
keymap("n", "<leader>qr", "<Cmd>SessionRestore<CR>", { desc = "Restore session" })
keymap("n", "<leader>qd", "<Cmd>SessionDelete<CR>", { desc = "Delete session" })
keymap("n", "<leader>qf", function() require("auto-session.session-lens").search_session() end, { desc = "Find sessions" })
keymap("n", "<leader>qp", "<Cmd>SessionPurgeOrphaned<CR>", { desc = "Purge orphaned sessions" })

-- ==================== FORMATAGE ====================

-- Le formatage est géré par conform.lua avec <leader>lf

-- ==================== AUTRES RACCOURCIS UTILES ====================

-- Raccourcis de confort
keymap("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>wq", "<Cmd>x<CR>", { desc = "Save and quit" })

-- Nettoyage de la recherche
keymap("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Déplacement de lignes en mode visuel
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Rester en mode visuel lors de l'indentation
keymap("v", "<", "<gv", { desc = "Decrease indent" })
keymap("v", ">", ">gv", { desc = "Increase indent" })

-- ==================== TROUBLE & DIAGNOSTICS ====================

-- Trouble.nvim - Diagnostics avancés
keymap("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics (Trouble)" })
keymap("n", "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
keymap("n", "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
keymap("n", "<leader>cl", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP references (Trouble)" })
keymap("n", "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", { desc = "Location list (Trouble)" })
keymap("n", "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list (Trouble)" })

-- Navigation rapide dans Trouble
keymap("n", "]x", function() require("trouble").next({skip_groups = true, jump = true}) end, { desc = "Next trouble/quickfix item" })
keymap("n", "[x", function() require("trouble").prev({skip_groups = true, jump = true}) end, { desc = "Previous trouble/quickfix item" })

-- ==================== QUALITY OF LIFE ====================

-- Duplicate de lignes (comme dans VSCode)
keymap("n", "<A-j>", ":t.<CR>", { desc = "Duplicate line down", silent = true })
keymap("n", "<A-k>", ":t.-1<CR>", { desc = "Duplicate line up", silent = true })
keymap("v", "<A-j>", ":t'><CR>gv", { desc = "Duplicate selection down", silent = true })
keymap("v", "<A-k>", ":t'<-1<CR>gv", { desc = "Duplicate selection up", silent = true })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Sauvegarde rapide avec Ctrl+S (comme dans tous les éditeurs)
keymap({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save file" })

-- Undo/Redo plus intuitif
keymap("n", "<C-z>", "u", { desc = "Undo" })
keymap("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Meilleure navigation avec wrapped lines
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (wrapped)" })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrapped)" })

-- Centrer le curseur après recherche
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Coller sans perdre le registre en mode visuel
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Meilleure gestion des fenêtres
keymap("n", "<leader>-", "<C-w>s", { desc = "Split window below" })
keymap("n", "<leader>|", "<C-w>v", { desc = "Split window right" })
keymap("n", "<leader>=", "<C-w>=", { desc = "Equal window sizes" })

-- Resize rapide avec Ctrl+Arrows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height", silent = true })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height", silent = true })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width", silent = true })

-- Toggle options rapide
keymap("n", "<leader>uw", "<Cmd>set wrap!<CR>", { desc = "Toggle word wrap" })
keymap("n", "<leader>ur", "<Cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
keymap("n", "<leader>us", "<Cmd>set spell!<CR>", { desc = "Toggle spell check" })
keymap("n", "<leader>ul", "<Cmd>set list!<CR>", { desc = "Toggle list chars" })

-- Navigation diagnostics (plus rapide)
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error" })

-- Quick-fix list navigation
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix item", silent = true })
keymap("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item", silent = true })

-- Highlight sous le curseur
keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect position" })