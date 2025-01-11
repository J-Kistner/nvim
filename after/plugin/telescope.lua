local builtin = require( "telescope.builtin" )
vim.keymap.set( "n", "<leader>ff", builtin.find_files, {} )
vim.keymap.set( "n", "<leader>gf", builtin.git_files, {} )
vim.keymap.set( "n", "<C-g>", function()
	builtin.grep_string( { seach = vim.fn.input( "Grep > " ) });
end)
vim.keymap.set( "n", "<leader>fh", builtin.help_tags, {} )
vim.keymap.set( "n", "<leader>fd", function()
   builtin.find_files()
   vim.cmd( "Ex" )
end )


