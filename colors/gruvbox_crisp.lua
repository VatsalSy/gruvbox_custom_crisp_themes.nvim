-- Safely attempt to load the theme to avoid hard failures when the plugin
-- is missing from the runtimepath (e.g., when :colorscheme is called early).
local ok, mod = pcall(require, "gruvbox_crisp")
if not ok then
  if vim and vim.notify then
    vim.notify("gruvbox_crisp: plugin not found on runtimepath", vim.log.levels.WARN)
  end
  return
end

mod.load()
