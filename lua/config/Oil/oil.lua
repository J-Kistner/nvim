OilTerminal = {
   Open = false,
   TerminalBuffers = {},
   WindowBuffer = nil,
}

local function get_current_oil_dir()
   local current_dir = require("oil").get_current_dir(vim.api.nvim_get_current_buf())
   print("Current Oil Directory: " .. current_dir)
   return current_dir
end

local function toggle_oil_terminal()
   print(OilTerminal.Open)
   if OilTerminal.Open then
      OilTerminal.Open = false
      if OilTerminal.WindowBuffer ~= nil then
         vim.api.nvim_win_close(OilTerminal.WindowBuffer, true)
         OilTerminal.WindowBuffer = nil
      end
   else
      if vim.bo.filetype == "oil" then
         local current_dir = get_current_oil_dir()
         if current_dir == nil then
            return
         end
         OilTerminal.Open = true
         local new_buf = false
         if OilTerminal.TerminalBuffers[current_dir] == nil then
            local terminal_buf = vim.api.nvim_create_buf(false, true)
            if terminal_buf == nil then
               return
            end
            new_buf = true
            OilTerminal.TerminalBuffers[current_dir] = terminal_buf
         end
         vim.cmd("vsplit")
         local win = vim.api.nvim_get_current_win()
         OilTerminal.WindowBuffer = win
         local terminal_buf = OilTerminal.TerminalBuffers[current_dir]
         vim.api.nvim_win_set_buf(win, terminal_buf)
         if new_buf then
            vim.cmd("terminal")
            local chan = vim.b.terminal_job_id
            vim.fn.chansend(chan, "cd " .. current_dir .. "\n")
         end
         vim.api.nvim_feedkeys("i", "n", false)
      end
   end
end

vim.api.nvim_create_user_command("OilTerminalToggle", toggle_oil_terminal, {})

vim.api.nvim_create_augroup("OilTerminalToggle", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
   callback = function()
      if vim.bo.filetype == "oil" then
         Key("n", "<leader>t", function() vim.cmd("OilTerminalToggle") end, "Oil Terminal Toggle")
      end
   end,
})

vim.api.nvim_create_autocmd("BufLeave", {
   callback = function()
      if vim.bo.filetype == "terminal" then
         if OilTerminal.Open then
            if OilTerminal.WindowBuffer ~= nil then
               toggle_oil_terminal()
            end
         end
      end
   end,
})

Key("t", "<C-t>", function() vim.cmd("OilTerminal") end, "Oil Terminal Toggle")
