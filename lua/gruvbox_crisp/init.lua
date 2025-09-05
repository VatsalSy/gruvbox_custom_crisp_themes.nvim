-- luacheck: globals vim
local palette = require("gruvbox_crisp.palette")
local groups  = require("gruvbox_crisp.groups")

local M = {}

local defaults = {
  style = "dark",
  transparent = false,
  terminal_colors = true,
  contrast = "highest", -- "highest" | "soft"
  -- Visual intensity controls
  selection_intensity = "high",    -- "low" | "medium" | "high"
  cursorline_intensity = "subtle",  -- "subtle" | "normal" | "strong"
  italics = {
    comments = true,
    strings = false,
    keywords = false,
    functions = false,
    variables = false,
  },
  bold = {
    functions = true,
  },
  overrides = {},
}

M.options = vim.deepcopy(defaults)

local function set_terminal(p)
  local t = p.term or {}
  vim.g.terminal_color_0  = t.black   or p.bg0
  vim.g.terminal_color_1  = t.red     or p.red
  vim.g.terminal_color_2  = t.green   or p.green
  vim.g.terminal_color_3  = t.yellow  or p.warn
  vim.g.terminal_color_4  = t.blue    or p.info
  vim.g.terminal_color_5  = t.magenta or p.number
  vim.g.terminal_color_6  = t.cyan    or p.hint
  vim.g.terminal_color_7  = t.white   or p.fg1
  vim.g.terminal_color_8  = t.bright_black   or p.gray
  vim.g.terminal_color_9  = t.bright_red     or p.red
  vim.g.terminal_color_10 = t.bright_green   or p.green
  vim.g.terminal_color_11 = t.bright_yellow  or p.warn
  vim.g.terminal_color_12 = t.bright_blue    or p.info
  vim.g.terminal_color_13 = t.bright_magenta or p.number
  vim.g.terminal_color_14 = t.bright_cyan    or p.hint
  vim.g.terminal_color_15 = t.bright_white   or p.fg0
end

function M.setup(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts)
end

function M.load()
  local o = M.options
  vim.o.termguicolors = true

  -- Clear existing highlights and reset syntax to avoid stale groups
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  -- Choose palette based on style option, defaulting to dark for invalid values
  local style = (o.style or "dark"):lower()
  if style ~= "light" and style ~= "dark" then
    style = "dark"
  end
  vim.o.background = style
  vim.g.colors_name = "gruvbox_crisp"

  local p = (style == "light") and palette.light or palette.dark
  local function safe(key, fallback)
    return p[key] or fallback
  end

  if o.terminal_colors then set_terminal(p) end

  local specs = groups.get(p, o)
  for name, spec in pairs(specs) do
    if spec.link then
      vim.api.nvim_set_hl(0, name, { link = spec.link })
    else
      vim.api.nvim_set_hl(0, name, spec)
    end
  end

  -- Ensure whitespace and special keys are visible but subdued
  local fallback_border = p.gray or "#808080"
  vim.api.nvim_set_hl(0, "Whitespace", { fg = safe("border_neutral", fallback_border) })
  vim.api.nvim_set_hl(0, "NonText", { fg = safe("border_neutral", fallback_border) })
end

return M
