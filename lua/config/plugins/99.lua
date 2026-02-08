return {
   "ThePrimeagen/99",
   config = function()
      local _99 = require("99")

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      _99.setup({
         logger = {
            level = _99.DEBUG,
            path = "/tmp/" .. basename .. ".99.debug",
            print_on_error = true,
         },

         --- Set the correct model for OpenCode
         model = "github-copilot/claude-sonnet-4.5",

      --- A new feature that is centered around tags
      completion = {
         --- Defaults to .cursor/rules
         -- I am going to disable these until i understand the
         -- problem better.  Inside of cursor rules there is also
         -- application rules, which means i need to apply these
         -- differently
         -- cursor_rules = "<custom path to cursor rules>"

         --- A list of folders where you have your own SKILL.md
         --- Expected format:
         --- /path/to/dir/<skill_name>/SKILL.md
         ---
         --- Example:
         --- Input Path:
         --- "scratch/custom_rules/"
         ---
         --- Output Rules:
         --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
         --- ... the other rules in that dir ...
         ---
         custom_rules = {
            "scratch/custom_rules/",
         },

         --- What autocomplete do you use.  We currently only
         --- support cmp right now. Set to nil to disable completion.
         source = nil,
      },

         --- WARNING: if you change cwd then this is likely broken
         --- ill likely fix this in a later change
         ---
         --- md_files is a list of files to look for and auto add based on the location
         --- of the originating request.  That means if you are at /foo/bar/baz.lua
         --- the system will automagically look for:
         --- /foo/bar/AGENT.md
         --- /foo/AGENT.md
         --- assuming that /foo is project root (based on cwd)
         md_files = {
            "AGENT.md",
         },
      })

      -- Create your own short cuts for the different types of actions
      vim.keymap.set("n", "<leader>gf", function()
         _99.fill_in_function()
      end)
      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set("v", "<leader>gv", function()
         _99.visual()
      end)

      --- Visual prompt with markdown window
      vim.keymap.set("v", "<leader>gp", function()
         local Window = require("99.window")
         local geo = require("99.geo")
         local get_id = require("99.id")
         local RequestContext = require("99.request-context")
         local ops = require("99.ops")
         local Agents = require("99.extensions.agents")
         
         -- Escape visual mode to set marks
         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
         
         -- Get context and range
         local state = _99.__get_state()
         state:refresh_rules()
         local trace_id = get_id()
         local context = RequestContext.from_current_buffer(state, trace_id)
         context.operation = "over-range-with-prompt"
         local range = geo.Range.from_visual_selection()
         
         -- Open markdown prompt window
         Window.capture_input({
            filetype = "markdown",
            rules = state.rules,
            cb = function(ok, prompt_text)
               if not ok or prompt_text == "" then
                  return
               end
               
               -- Parse rules from prompt
               local rules_and_names = Agents.by_name(state.rules, prompt_text)
               local opts = {
                  additional_prompt = prompt_text,
                  additional_rules = rules_and_names.rules,
               }
               
               -- Execute visual operation with prompt
               context:add_agent_rules(rules_and_names.rules)
               ops.over_range(context, range, opts)
            end,
            on_load = function()
               -- Start in insert mode
               vim.cmd("startinsert")
            end,
         })
      end, { desc = "99: Visual prompt with markdown window" })

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set("v", "<leader>gs", function()
         _99.stop_all_requests()
      end)

   --- Example: Using rules + actions for custom behaviors
   --- Create a rule file like ~/.rules/debug.md that defines custom behavior.
   --- For instance, a "debug" rule could automatically add printf statements
   --- throughout a function to help debug its execution flow.
   vim.keymap.set("n", "<leader>9fd", function()
      _99.fill_in_function()
   end)

   --- Diagnostic: Check if 99 can detect the current function
   vim.keymap.set("n", "<leader>9d", function()
      local buffer = vim.api.nvim_get_current_buf()
      local ft = vim.bo[buffer].ft
      local cursor = { vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[2] }
      
      print("=== 99 Diagnostic ===")
      print("FileType: " .. ft)
      print("Cursor: line " .. (cursor[1] + 1) .. ", col " .. cursor[2])
      
      -- Check if treesitter parser is available
      local has_parser = pcall(vim.treesitter.get_parser, buffer, ft)
      print("Treesitter parser: " .. (has_parser and "✓ Found" or "✗ Missing - Run :TSInstall " .. ft))
      
      -- Check if 99-function query exists
      local query_path = vim.fn.stdpath("data") .. "/lazy/99/queries/" .. ft .. "/99-function.scm"
      local query_exists = vim.fn.filereadable(query_path) == 1
      print("99-function query: " .. (query_exists and "✓ Found" or "✗ Missing - Language not supported"))
      
      if query_exists then
         print("Query file: " .. query_path)
      end
      
      -- Try to get the query
      local ok, query = pcall(vim.treesitter.query.get, ft, "99-function")
      print("Query loadable: " .. (ok and query ~= nil and "✓ Yes" or "✗ No"))
      
      -- Try to find function
      if has_parser and ok and query then
         local state = _99.__get_state()
         local RequestContext = require("99.request-context")
         local geo = require("99.geo")
         local get_id = require("99.id")
         
         local context = RequestContext.from_current_buffer(state, get_id())
         local point = geo.Point.new(cursor[1], cursor[2])
         
         local editor = require("99.editor")
         local func = editor.treesitter.containing_function(context, point)
         
         if func then
            print("Function detected: ✓ Yes")
            print("Range: " .. func.function_range:to_string())
         else
            print("Function detected: ✗ No - Cursor might not be inside a function")
         end
      end
      
      print("==================")
   end, { desc = "99: Diagnostic - Check function detection" })
end,
}
