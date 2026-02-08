return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"jdtls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			-- Extend the existing servers configuration
			opts.servers = opts.servers or {}
			
			-- Set JAVA_HOME to Java 25 for jdtls (requires Java 21+)
			vim.env.JAVA_HOME = "/usr/lib/jvm/java-25-openjdk"
			
			opts.servers.jdtls = {
				on_attach = function(client, bufnr)
					-- Enable inlay hints for Java
					vim.lsp.inlay_hint.enable(true)

					-- Add Java-specific keymaps
					vim.keymap.set("n", "<leader>jo", vim.lsp.buf.code_action, 
						{ buffer = bufnr, desc = "( Java ) Code Actions / Organize Imports" })
				end,
				settings = {
					java = {
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" },
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*",
								-- WPILib common imports
								"edu.wpi.first.wpilibj.smartdashboard.SmartDashboard.*",
								"edu.wpi.first.wpilibj2.command.Commands.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
						},
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
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},
						configuration = {
							runtimes = {
								-- Java 17 for FRC 2024+ projects
								{
									name = "JavaSE-17",
									path = "/usr/lib/jvm/java-17-openjdk/",
								},
								-- Java 25 is used by jdtls itself
								{
									name = "JavaSE-25",
									path = "/usr/lib/jvm/java-25-openjdk/",
									default = true,
								},
							},
							-- Update Gradle configuration automatically
							updateBuildConfiguration = "automatic",
						},
						-- Important for WPILib projects to handle vendordeps correctly
						import = {
							gradle = {
								enabled = true,
								wrapper = {
									enabled = true,
								},
								version = nil, -- Use project's Gradle version
								home = nil, -- Use GRADLE_HOME or auto-detect
								java = {
									home = nil, -- Use JAVA_HOME or auto-detect
								},
								offline = false,
								arguments = nil, -- Use project's default Gradle args
								jvmArguments = nil,
								user = {
									home = nil, -- Use ~/.gradle
								},
							},
						},
						inlayHints = {
							parameterNames = {
								enabled = "all",
							},
						},
					},
				},
			}
			return opts
		end,
	},
}
