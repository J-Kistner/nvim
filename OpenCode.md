Build Commands:
- Reload configuration: :source $MYVIMRC
- Formatting: :Lazy sync

Lint Commands
- Lua lint: luacheck lua/
- Check plugins: nvim --headless -c 'Lazy check' -c quit

Test Commands
- Run a single test: nvim -c '<YourTestCommand>'

Style Guidelines
- Use spaces (2), no tabs)
- Lua: snake_case for variables
- Folders grouped by plugin type
- Always prefer local requires
- Error handling: pcall() wrappers

No Copilot/Cursor rules defined yet.