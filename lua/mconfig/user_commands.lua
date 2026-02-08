vim.api.nvim_create_user_command("W", function() vim.cmd("w") end, {})

vim.api.nvim_create_user_command("Just", function()
	local justfile_path = vim.fn.getcwd() .. "/justfile"
	local alt_justfile_path = vim.fn.getcwd() .. "/Justfile"

	-- Check if justfile exists (case-insensitive)
	local justfile_exists = vim.fn.filereadable(justfile_path) == 1 or vim.fn.filereadable(alt_justfile_path) == 1
	local file_to_read = vim.fn.filereadable(justfile_path) == 1 and justfile_path or alt_justfile_path

	if not justfile_exists then
		vim.notify("No justfile found in current directory", vim.log.levels.WARN)
		return
	end

	-- Read and parse justfile recipes
	local recipes = {}
	local file = io.open(file_to_read, "r")
	if file then
		for line in file:lines() do
			-- Match recipe definitions (lines starting with identifier followed by colon)
			-- Ignore lines starting with # (comments) or whitespace
			local recipe = line:match("^([%w_-]+)%s*:")
			if recipe then
				table.insert(recipes, recipe)
			end
		end
		file:close()
	end

	if #recipes == 0 then
		vim.notify("No recipes found in justfile", vim.log.levels.WARN)
		return
	end

	-- Use Telescope to select a recipe
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Just Recipes",
			finder = finders.new_table({
				results = recipes,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						-- Run the selected recipe
						vim.cmd("!just " .. selection[1])
					end
				end)
				return true
			end,
		})
		:find()
end, {})
