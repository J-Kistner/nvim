return {
	"mfussenegger/nvim-jdtls",
	lazy = true,
	ft = "java",
	config = function()
		local jdtls = require("jdtls")

		local home = os.getenv("HOME")

		local function first_glob(pattern)
			local matches = vim.fn.glob(pattern, false, true)
			if type(matches) == "table" and #matches > 0 then
				table.sort(matches)
				return matches[1]
			end
			return nil
		end

		local function resolve_wpilib_jdk()
			local candidates = {
				home .. "/wpilib/2027_beta/jdk",
				home .. "/wpilib/2027_alpha5/jdk",
				home .. "/Storage/FRC/WIPLIB-2027-PRE/jdk",
				home .. "/Storage/FRC/WIPLIB 2027/jdk",
			}

			for _, candidate in ipairs(candidates) do
				if vim.fn.executable(candidate .. "/bin/java") == 1 then
					return candidate
				end
			end

			return nil
		end

		local function jdk_major(jdk_home)
			local release_file = jdk_home .. "/release"
			if vim.fn.filereadable(release_file) ~= 1 then
				return nil
			end
			for _, line in ipairs(vim.fn.readfile(release_file)) do
				local major = line:match('JAVA_VERSION="(%d+)')
				if major then
					return tonumber(major)
				end
			end
			return nil
		end

		local function resolve_java_cmd(runs_on_java25)
			local candidates = {}
			local env_home = os.getenv("JAVA_HOME")
			if env_home then
				table.insert(candidates, env_home)
			end
			for _, jdk in ipairs(vim.fn.glob("/usr/lib/jvm/*", false, true)) do
				if vim.fn.isdirectory(jdk) == 1 then
					table.insert(candidates, jdk)
				end
			end

			local function usable(jdk_home)
				if vim.fn.executable(jdk_home .. "/bin/java") ~= 1 then
					return false
				end
				local major = jdk_major(jdk_home)
				if not major then
					return false
				end
				if not runs_on_java25 and major >= 25 then
					return false
				end
				return true
			end

			for _, jdk_home in ipairs(candidates) do
				if usable(jdk_home) then
					return jdk_home .. "/bin/java", jdk_home
				end
			end

			if vim.fn.executable("java") == 1 then
				return "java", nil
			end
			return nil, nil
		end

		local function resolve_jdtls_install()
			local mason_dir = home .. "/.local/share/nvim/mason/packages/jdtls"
			if vim.fn.isdirectory(mason_dir) == 1 then
				return mason_dir
			end

			return nil
		end

		local function resolve_jdtls_bundles()
			local bundles = {}
			local seen = {}
			local patterns = {
				home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
				home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar",
				home .. "/.local/share/nvim/mason/packages/java-test/extension/jar/*.jar",
			}

			for _, pattern in ipairs(patterns) do
				local matches = vim.fn.glob(pattern, false, true)
				if type(matches) == "table" and #matches > 0 then
					table.sort(matches)
					for _, item in ipairs(matches) do
						if not seen[item] then
							seen[item] = true
							table.insert(bundles, item)
						end
					end
				end
			end

			return bundles
		end

		local jdtls_path = resolve_jdtls_install()
		if not jdtls_path then
			vim.notify("jdtls install not found in mason (MasonInstall jdtls)", vim.log.levels.ERROR)
			return
		end

		local jdtls_version = vim.fn.fnamemodify(jdtls_path, ":t"):match("^(%d+%.%d+)")
		local jdtls_runs_on_java25 = not jdtls_version or jdtls_version >= "1.51"

		local java_cmd, java_home = resolve_java_cmd(jdtls_runs_on_java25)
		if not java_cmd then
			vim.notify("java executable not found for jdtls", vim.log.levels.ERROR)
			return
		end
		local project_java_home = resolve_wpilib_jdk() or java_home

		local os_config = "linux"
		if vim.fn.has("mac") == 1 then
			os_config = "mac"
		elseif vim.fn.has("win32") == 1 then
			os_config = "win"
		end

		local launcher_jar = first_glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		if not launcher_jar then
			vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
			return
		end

		local function get_config(root_dir)
			local project_name = vim.fn.fnamemodify(root_dir, ":p:t")
			local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

			local config = {
				cmd = {
					java_cmd,
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
							runtimes = (function()
								local runtimes = {}
								local seen = {}
								local function add(jdk_home, default)
									local major = jdk_major(jdk_home)
									if not major then
										return
									end
									local name = "JavaSE-" .. major
									if not seen[name] then
										seen[name] = true
										table.insert(runtimes, { name = name, path = jdk_home, default = default })
									end
								end
								add(project_java_home, true)
								if java_home and java_home ~= project_java_home then
									add(java_home, false)
								end
								return runtimes
							end)(),
						},
						import = {
							gradle = {
								java = {
									home = project_java_home,
								},
							},
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
					bundles = resolve_jdtls_bundles(),
				},
			}

			local ok, blink = pcall(require, "blink.cmp")
			if ok then
				config.capabilities = blink.get_lsp_capabilities()
			end

			return config
		end

		local function setup_jdtls()
			local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle", ".git" }
			local root_dir = require("jdtls.setup").find_root(root_markers)
			if not root_dir then
				return
			end

			local config = get_config(root_dir)
			jdtls.start_or_attach(config)

			local function keymap(lhs, rhs, desc, is_visual)
				local opts = { buffer = 0, desc = desc }
				if is_visual then
					vim.keymap.set("v", lhs, rhs, opts)
				else
					vim.keymap.set("n", lhs, rhs, opts)
				end
			end

			keymap("<leader>jo", jdtls.organize_imports, "( Java ) Organize Imports")
			keymap("<leader>jv", jdtls.extract_variable, "( Java ) Extract Variable", true)
			keymap("<leader>jc", jdtls.extract_constant, "( Java ) Extract Constant", true)
			keymap("<leader>jm", function() jdtls.extract_method(true) end, "( Java ) Extract Method", true)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = setup_jdtls,
		})

		if vim.bo.filetype == "java" then
			setup_jdtls()
		end
	end,
}
