return {
   "mfussenegger/nvim-jdtls",
   ft = { "java" },
   config = function()
      local jdtls = require('jdtls')
      local home = os.getenv("HOME")

      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = home .. "/.local/share/nvim/site/java/workspace-root/" .. project_name

      local jdtls_home = home .. "/.local/share/jdtls"

      -- Find exact launcher jar inside plugins directory (replace '*' with actual version)
      local launcher_jar = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")

      local jdtls_home = os.getenv("HOME") .. "/.local/share/jdtls"
      local workspace_dir = os.getenv("HOME") ..
          "/.local/share/nvim/site/java/workspace-root/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local launcher_jar = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")

      local config = {
         cmd = {
            "/usr/lib/jvm/java-17-openjdk/bin/java", -- force Java 17 here
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "-jar", launcher_jar,
            "-configuration", jdtls_home .. "/config_linux",
            "-data", workspace_dir,
         },

         root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml' }),

         settings = {
            java = {
               configuration = {
                  runtimes = {
                     {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk",
                     },
                  },
               },
            },
         },

         init_options = {
            bundles = {},
         },
      }

      jdtls.start_or_attach(config)
   end,

}
