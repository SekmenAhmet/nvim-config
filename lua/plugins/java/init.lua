-- Support Java complet via nvim-jdtls
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  config = function()
    local mason_registry = require("mason-registry")
    if not mason_registry.is_installed("jdtls") then
      vim.notify("jdtls n'est pas installé via Mason. Lance :Mason et installe jdtls.", vim.log.levels.ERROR, { title = "nvim-jdtls" })
      return
    end

    local jdtls_pkg = mason_registry.get_package("jdtls")
    local jdtls_path = jdtls_pkg:get_install_path()
    local lombok_path = jdtls_path .. "/lombok.jar"
    local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local os_config = "config_linux"
    if vim.fn.has("macunix") == 1 then
      os_config = "config_mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "config_win"
    end
    local config_path = jdtls_path .. "/" .. os_config

    -- Workspace unique par projet
    local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }) or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspaces/" .. project_name

    -- Bundles pour le debugging et les tests (si installés via Mason)
    local bundles = {}
    local function extend_bundle(pkg_name, pattern)
      if mason_registry.has_package(pkg_name) then
        local pkg = mason_registry.get_package(pkg_name)
        local paths = vim.fn.glob(pkg:get_install_path() .. pattern, 1, 1)
        vim.list_extend(bundles, paths)
      end
    end
    extend_bundle("java-debug-adapter", "/extension/server/com.microsoft.java.debug.plugin-*.jar")
    extend_bundle("java-test", "/extension/server/*.jar")

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_path,
        "-jar", launcher_jar,
        "-configuration", config_path,
        "-data", workspace_dir,
      },

      root_dir = root_dir,

      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            importOrder = { "java", "javax", "com", "org" },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },

      init_options = {
        bundles = bundles,
      },

      on_attach = function(client, bufnr)
        local jdtls = require("jdtls")
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Java organize imports" }))
        vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Java extract variable" }))
        vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Java extract constant" }))
        vim.keymap.set("n", "<leader>jt", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Java test class" }))
        vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Java test method" }))

        -- Debug adapter (hot code replace auto)
        jdtls.setup_dap({ hotcodereplace = "auto" })

        -- Organize imports on save (buffer local)
        local group = vim.api.nvim_create_augroup("JdtlsFormat" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          buffer = bufnr,
          callback = function()
            jdtls.organize_imports()
          end,
        })
      end,
    }

    require("jdtls").start_or_attach(config)
  end,
}
