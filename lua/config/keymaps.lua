-- =====================================================
-- Keymaps Centralisés - Configuration Neovim
-- =====================================================
-- Tous les raccourcis clavier de l'application centralisés ici
-- Organisation : Navigation → LSP → Recherche → UI → Utils

local keymap = vim.keymap.set

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

-- nvim-tree - NOUVEAU PREFIX: <leader>e pour explorer (plus logique)
keymap("n", "<C-b>", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap("n", "<leader>ee", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap("n", "<leader>ef", "<Cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
keymap("n", "<leader>ec", "<Cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
keymap("n", "<leader>er", "<Cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

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

-- Conform - NOUVEAU PREFIX: <leader>l pour 'language/lint' 
keymap("n", "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format buffer" })
keymap("v", "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format selection" })

-- ==================== AUTRES RACCOURCIS UTILES ====================

-- Raccourcis de confort
keymap("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", "<Cmd>x<CR>", { desc = "Save and quit" })

-- Nettoyage de la recherche
keymap("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Déplacement de lignes en mode visuel
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Rester en mode visuel lors de l'indentation
keymap("v", "<", "<gv", { desc = "Decrease indent" })
keymap("v", ">", ">gv", { desc = "Increase indent" })