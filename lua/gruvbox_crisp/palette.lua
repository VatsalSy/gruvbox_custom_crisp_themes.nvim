local M = {}

-- simple deepcopy fallback if vim.deepcopy is unavailable
local function deepcopy_tbl(t)
  if _G.vim and _G.vim.deepcopy then
    return _G.vim.deepcopy(t)
  end
  if type(t) ~= "table" then
    return t
  end
  local copy = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      copy[k] = deepcopy_tbl(v)
    else
      copy[k] = v
    end
  end
  return copy
end

-- Highest Contrast, pop variant
M.dark = {
  -- Base
  bg0 = "#000000", -- editor background (pure black)
  bg1 = "#1d1d1d", -- soft contrast background
  bg2 = "#1a1a1a", -- hover/list backgrounds
  bg3 = "#262626", -- subtle separators
  fg0 = "#ffffff", -- editor foreground (pure white)
  fg1 = "#f8f8f2", -- near-white for variables and UI text
  ui_fg = "#fbf1c7", -- general UI foreground per JSON

  -- Neutral borders from JSON
  border_neutral = "#3c3836",

  -- Core syntax (Dracula-inspired)
  comment = "#6272a4",
  string = "#50fa7b",
  keyword = "#f1fa8c",
  func = "#ff79c6", -- pink for functions
  func_green = "#b8bb26", -- green for LaTeX commands and entity names
  number = "#bd93f9",
  type = "#8be9fd", -- cyan for types/classes
  operator = "#ffb86c",
  variable = "#f8f8f2",
  decorator = "#9b4fa0",
  const = "#d3869b", -- non-numeric constants / enum members
  preproc = "#fe8019", -- preprocessor/meta
  kw_ctrl = "#fb4934", -- control keywords (if/for/return, storage)
  property = "#83a598", -- fields/properties/parameters
  magic = "#8ec07c", -- Python magic/dunder methods
  magic_method = "#8ec07c", -- legacy alias

  -- Language-specific colors
  latex_math = "#fabd2f", -- LaTeX math mode (yellow/gold)
  latex_comment = "#7c6f64", -- LaTeX comments (gruvbox gray)
  entity_name = "#b8bb26", -- Entity names (green)

  -- UI accents
  cursor = "#9b4fa0",
  -- Selection approximations of #bd93f9 over black with varying alpha
  selection = "#231b2e", -- low  (~18% alpha)
  selection_med = "#302440", -- mid  (~24% alpha)
  selection_high = "#392c4b", -- high (~30% alpha)
  -- Cursor line highlight (neutral gray overlay equivalents)
  linehl_subtle = "#0a0a0a",
  linehl = "#0e0e0e",
  linehl_strong = "#161313",
  border_focus = "#bd93f9",
  hover_bg = "#1a1a1a",
  link = "#bd93f9",
  link_active = "#d6acff",
  line_nr_active = "#ffb86c",
  line_nr = "#665c54",

  -- VCS / Diff
  red = "#ff5555",
  green = "#50fa7b",
  warn = "#ffb86c",
  info = "#83a598",
  hint = "#8be9fd",
  ok = "#50fa7b",
  diff_add_bg = "#0f2f17",
  diff_delete_bg = "#301010",
  diff_text = "#6cb6ff",

  gray = "#6272a4", -- blue-gray (comments)
  punct = "#a89984", -- warm gray for punctuation
  none = "NONE",

  -- Terminal ANSI
  term = {
    black = "#000000",
    red = "#ff5555",
    green = "#50fa7b",
    yellow = "#f1fa8c",
    blue = "#6cb6ff",
    magenta = "#bd93f9",
    cyan = "#8be9fd",
    white = "#cccccc",

    bright_black = "#6272a4",
    bright_red = "#ff6e6e",
    bright_green = "#69ff94",
    bright_yellow = "#ffffa5",
    bright_blue = "#79c7ff",
    bright_magenta = "#d6acff",
    bright_cyan = "#a4ffff",
    bright_white = "#ffffff",
  },
}

-- Light table kept for compatibility; mirrors dark variant.
-- Create an independent copy so future adjustments to light can diverge
M.light = deepcopy_tbl(M.dark)

-- make palettes readonly (shallow) to avoid accidental mutation
local function readonly(tbl)
  return setmetatable({}, {
    __index = tbl,
    __newindex = function()
      error("palette tables are readonly", 2)
    end,
    __pairs = function()
      return pairs(tbl)
    end,
    __ipairs = function()
      return ipairs(tbl)
    end,
  })
end

M.dark = readonly(M.dark)
M.light = readonly(M.light)

return M
