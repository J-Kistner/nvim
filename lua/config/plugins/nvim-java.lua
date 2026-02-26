return {
	{
		"nvim-java/nvim-java",
		dependencies = {
			"nvim-java/lua-async-await",
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            -- Use nvim-java's built-in refactor features; do not load the
            -- separate nvim-java-refactor plugin to avoid API conflicts.
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			{
				"JavaHello/spring-boot.nvim",
				commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
			},
		},
		config = function()
			require("java").setup({
			jdk = {
				auto_install = false,
			},
			java_test = {
				enable = true,
			},
			java_debug_adapter = {
				enable = true,
			},
			spring_boot_tools = {
				enable = true,
			},
		})

        -- Use the nvim-java plugin to manage jdtls and java tooling. We intentionally
        -- do not include any separate jdtls configuration here; nvim-java installs
        -- and configures the language server on-demand (project-aware). Keep this
        -- setup minimal so the plugin can manage its own lifecycle.

		-- Java-specific keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				vim.keymap.set("n", "<leader>jo", vim.lsp.buf.code_action, {
					buffer = true,
					desc = "( Java ) Code Actions / Organize Imports",
				})
			end,
		})
	end,
	},
}
