return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local jdtls = require("jdtls")

		-- Find root of Java project
		local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
		local root_dir = require("jdtls.setup").find_root(root_markers)
		if not root_dir then
			return
		end

		-- Paths
		local home = os.getenv("HOME")
		local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
		local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

		-- Get platform-specific config
		local os_config = "linux"
		if vim.fn.has("mac") == 1 then
			os_config = "mac"
		elseif vim.fn.has("win32") == 1 then
			os_config = "win"
		end

		-- Find the launcher jar
		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		if launcher_jar == "" then
			vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
			return
		end

		local config = {
			cmd = {
				"/usr/lib/jvm/java-17-openjdk/bin/java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				launcher_jar,
				"-configuration",
				jdtls_path .. "/config_" .. os_config,
				"-data",
				workspace_dir,
			},

			root_dir = root_dir,

			settings = {
				java = {
					eclipse = {
						downloadSources = true,
					},
					configuration = {
						updateBuildConfiguration = "interactive",
					},
					maven = {
						downloadSources = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
					},
					references = {
						includeDecompiledSources = true,
					},
					format = {
						enabled = true,
					},
				},
				signatureHelp = { enabled = true },
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.hamcrest.CoreMatchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"java.util.Objects.requireNonNullElse",
						"org.mockito.Mockito.*",
					},
				},
				contentProvider = { preferred = "fernflower" },
				extendedClientCapabilities = jdtls.extendedClientCapabilities,
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
				codeGeneration = {
					toString = {
						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					},
					useBlocks = true,
				},
			},

			flags = {
				allow_incremental_sync = true,
			},

			init_options = {
				bundles = {},
			},
		}

		-- Get blink.cmp capabilities if available
		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			config.capabilities = blink.get_lsp_capabilities()
		end

		-- Start or attach to jdtls
		jdtls.start_or_attach(config)

		-- Keymaps
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, {
			buffer = 0,
			desc = "( Java ) Organize Imports",
		})
		vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, {
			buffer = 0,
			desc = "( Java ) Extract Variable",
		})
		vim.keymap.set("v", "<leader>jv", function()
			jdtls.extract_variable(true)
		end, {
			buffer = 0,
			desc = "( Java ) Extract Variable",
		})
		vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, {
			buffer = 0,
			desc = "( Java ) Extract Constant",
		})
		vim.keymap.set("v", "<leader>jc", function()
			jdtls.extract_constant(true)
		end, {
			buffer = 0,
			desc = "( Java ) Extract Constant",
		})
		vim.keymap.set("v", "<leader>jm", function()
			jdtls.extract_method(true)
		end, {
			buffer = 0,
			desc = "( Java ) Extract Method",
		})
	end,
}
