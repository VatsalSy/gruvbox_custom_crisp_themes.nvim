-- luacheck: globals vim
-- Safely attempt to load the theme to avoid hard failures when the plugin
-- is missing from the runtimepath (e.g., when :colorscheme is called early).
local ok, mod = pcall(require, "gruvbox_crisp")
if not ok then
  local msg = "gruvbox_crisp: plugin not found on runtimepath"
  if _G.vim then
    local has_levels = vim.log and vim.log.levels
    if vim.notify then
      if has_levels then
        vim.notify(msg, vim.log.levels.WARN)
      else
        vim.notify(msg)
      end
    elseif vim.api and vim.api.nvim_err_writeln then
      vim.api.nvim_err_writeln(msg)
    else
      print(msg)
    end
  else
    print(msg)
  end
  return
end

mod.load()
