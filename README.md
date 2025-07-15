# 🚀 Configuration Neovim Personnalisée

Une configuration Neovim moderne et complète avec support multi-langages, outils de productivité et interface élégante.

## 📦 Plugins Inclus

- **Lazy.nvim** - Gestionnaire de plugins performant
- **Mason** - Gestionnaire LSP, formatters et linters
- **nvim-tree** - Explorateur de fichiers
- **Telescope** - Fuzzy finder et recherche
- **ToggleTerm** - Terminal intégré
- **TreeSitter** - Syntax highlighting avancé
- **nvim-cmp** - Autocomplétion intelligente
- **Alpha** - Page d'accueil élégante
- **Auto-session** - Gestion automatique des sessions
- **Bufferline** - Onglets pour les buffers
- **Comment.nvim** - Toggle commentaires
- **nvim-surround** - Manipulation des surroundings
- **nvim-autopairs** - Auto-completion des paires
- **indent-blankline** - Lignes d'indentation visuelles

## 🎯 Support Langages

| Langage | LSP Server | Statut |
|---------|------------|--------|
| **Python** | pyright | ✅ |
| **TypeScript/JavaScript** | ts_ls | ✅ |
| **Go** | gopls | ✅ |
| **Rust** | rust-analyzer | ✅ |
| **Java** | jdtls | ✅ |
| **Docker** | dockerls + yamlls | ✅ |

## ⌨️ Raccourcis Clavier

### 🔧 Configuration de Base
- **Leader** : `<Space>`
- **Local Leader** : `\\`

### 🗂️ Navigation Fichiers & Fenêtres

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<C-h>` | Aller à la fenêtre de gauche | Normal |
| `<C-j>` | Aller à la fenêtre du bas | Normal |
| `<C-k>` | Aller à la fenêtre du haut | Normal |
| `<C-l>` | Aller à la fenêtre de droite | Normal |

### 📁 nvim-tree (Explorateur de fichiers)

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<C-b>` | Toggle explorateur | Normal |
| `<leader>ef` | Toggle sur fichier courant | Normal |
| `<leader>ec` | Réduire l'arbre | Normal |
| `<leader>er` | Rafraîchir l'arbre | Normal |

### 🔍 Telescope (Recherche)

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<leader>e` | Chercher fichiers | Normal |
| `<C-e>` | Chercher dans les buffers | Normal |
| `<leader>fg` | Recherche texte (live grep) | Normal |
| `<leader>fb` | Liste des buffers | Normal |
| `<leader>fh` | Aide (help tags) | Normal |
| `<leader>fs` | Recherche dans fichier courant | Normal |
| `<leader>fo` | Fichiers récents | Normal |
| `<leader>fc` | Chercher mot sous curseur | Normal |
| `<leader>gc` | Commits git | Normal |
| `<leader>gb` | Branches git | Normal |

### 💻 Terminal (ToggleTerm)

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<C-i>` | Toggle terminal | Normal/Terminal |
| `<leader>tf` | Terminal flottant | Normal |
| `<leader>th` | Terminal horizontal | Normal |
| `<leader>tv` | Terminal vertical | Normal |
| `<Esc>` | Sortir du mode terminal | Terminal |
| `jk` | Sortir du mode terminal | Terminal |

### 📑 Buffers & Onglets

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<Tab>` | Buffer suivant | Normal |
| `<S-Tab>` | Buffer précédent | Normal |
| `<leader>bd` | Choisir buffer à fermer | Normal |
| `<leader>bp` | Choisir buffer à ouvrir | Normal |
| `<leader>1-9` | Aller au buffer N | Normal |

### 💬 Commentaires

| Raccourci | Action | Mode |
|-----------|---------|------|
| `gcc` | Toggle commentaire ligne | Normal |
| `gbc` | Toggle commentaire bloc | Normal |
| `gc` | Commentaire (opérateur) | Normal |
| `gb` | Commentaire bloc (opérateur) | Normal |
| `gcO` | Commentaire au-dessus | Normal |
| `gco` | Commentaire en-dessous | Normal |
| `gcA` | Commentaire en fin de ligne | Normal |

### 🎯 Surroundings (nvim-surround)

| Raccourci | Action | Mode |
|-----------|---------|------|
| `ys{motion}{char}` | Ajouter surround | Normal |
| `yss{char}` | Ajouter surround ligne | Normal |
| `S{char}` | Ajouter surround | Visuel |
| `ds{char}` | Supprimer surround | Normal |
| `cs{old}{new}` | Changer surround | Normal |

**Exemples :**
- `ysiw"` - Entourer mot de guillemets
- `ds"` - Supprimer guillemets
- `cs"'` - Changer " en '

### 🔧 LSP (Language Server)

| Raccourci | Action | Mode |
|-----------|---------|------|
| `gD` | Aller à la déclaration | Normal |
| `gd` | Aller à la définition | Normal |
| `K` | Afficher documentation | Normal |
| `gi` | Aller à l'implémentation | Normal |
| `<leader>rn` | Renommer symbole | Normal |
| `<leader>ca` | Actions de code | Normal |
| `gr` | Références | Normal |

### ⚡ Autocomplétion

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<C-Space>` | Déclencher complétion | Insert |
| `<CR>` | Confirmer sélection | Insert |
| `<C-e>` | Annuler complétion | Insert |
| `<Tab>` | Élément suivant | Insert |
| `<S-Tab>` | Élément précédent | Insert |
| `<C-u>` | Scroll docs haut | Insert |
| `<C-d>` | Scroll docs bas | Insert |

### 🎨 TreeSitter

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<C-Space>` | Sélection incrémentale | Normal |
| `<BS>` | Réduire sélection | Normal |
| `]m` | Fonction suivante | Normal |
| `[m` | Fonction précédente | Normal |
| `]]` | Classe suivante | Normal |
| `[[` | Classe précédente | Normal |

**Text Objects :**
- `af`/`if` - Fonction (around/inner)
- `ac`/`ic` - Classe (around/inner)
- `aa`/`ia` - Paramètre (around/inner)

### 💾 Sessions

| Raccourci | Action | Mode |
|-----------|---------|------|
| `<leader>qs` | Sauvegarder session | Normal |
| `<leader>qr` | Restaurer session | Normal |
| `<leader>qd` | Supprimer session | Normal |
| `<leader>qf` | Chercher sessions | Normal |
| `<leader>qp` | Nettoyer sessions orphelines | Normal |

## 🎨 Page d'Accueil (Alpha)

Raccourcis disponibles sur la page d'accueil :

| Touche | Action |
|--------|--------|
| `e` | Nouveau fichier |
| `o` | Fichiers récents |
| `f` | Chercher fichier |
| `g` | Chercher texte |
| `s` | Restaurer session |
| `c` | Configuration |
| `l` | Lazy (plugins) |
| `m` | Mason (LSP) |
| `q` | Quitter |

## 🚀 Installation

1. **Cloner la configuration :**
   ```bash
   git clone <repo> ~/.config/nvim
   ```

2. **Lancer Neovim :**
   ```bash
   nvim
   ```

3. **Installer les LSP servers :**
   - Ouvrir Mason : `:Mason`
   - Installer les serveurs requis

4. **Installer les parsers TreeSitter :**
   ```vim
   :TSUpdate
   ```

## 🔧 Personnalisation

- **Fichier principal :** `init.lua`
- **Thème :** Tokyo Night (configurable)
- **Leader key :** Space (modifiable ligne 10)

## 📝 Notes

- **Terminal :** Configuré pour PowerShell sur Windows
- **Exclusions Telescope :** `.git`, `target`, `node_modules`, `build`
- **Auto-session :** Sauvegarde automatique par répertoire
- **Folding :** Basé sur TreeSitter (désactivé par défaut)

---

**🎯 Configuration optimisée pour la productivité et le développement multi-langages !**